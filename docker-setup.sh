#!/bin/bash -e

usage()
{
  echo
  echo "Usage: $0 "
  echo
  echo " -n Image Name"
  echo " -v Image Version e.g. 0.1.1"
  echo
  exit 1
}

while getopts v:n: flag
do
    case "${flag}" in
        n) image_name=${OPTARG};;
        v) image_version=${OPTARG};;
    esac
done

([ -z "$image_name" ] || [ -z "$image_version" ]) && usage

function log_date {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}


apiUrl=$(cat secrets.json | jq -er '.api.apiUrl')
tokenUrl=$(cat secrets.json | jq -er '.api.tokenUrl')
clientId=$(cat secrets.json | jq -er '.api.clientId')
clientSecret=$(cat secrets.json | jq -er '.api.clientSecret')
username=$(cat secrets.json | jq -er '.api.username')
password=$(cat secrets.json | jq -er '.api.password')

echo "$(log_date): Collecting token from" $tokenUrl

token=$(curl -s -X POST $tokenUrl \
   -H "Content-Type: application/x-www-form-urlencoded; charset=ISO-8859-1" \
   --data-urlencode grant_type="password" \
   --data-urlencode username=$username \
   --data-urlencode password=$password \
   --data-urlencode scope="openid client groups" \
   --data-urlencode client_id=$clientId \
   --data-urlencode client_secret=$clientSecret \
    | jq -er '.access_token' ) 

images_api=$(echo $apiUrl | sed -e "s;api$;scheduler2\/api\/images;")
echo Token: $token

echo "$(log_date): Determine if image $image_name:$image_version already exists in the repo"
get_image_status=$(curl -s -X GET $images_api/$image_name:$image_version \
   -o /dev/null -w "%{http_code}" \
   -H "Authorization: Bearer $token" \
   -H "Content-Type: application/json-patch+json")

if [ $get_image_status -eq 200 ]
then
  echo "$(log_date): $image_name:$image_version already exists, please choose a new version number"

  exit 1
fi

echo "$(log_date): Generating commands to generate and push image for: $image_name:$image_version to: $images_api" 

image_commands=$(curl -s -X POST $images_api \
   -H "Authorization: Bearer $token" \
   -H "Content-Type: application/json-patch+json" \
   -d "{'imageName':'$image_name:$image_version'}") \

echo  "$(log_date): $(echo $image_commands | jq -er '.title')"

dockerLoginCommand=$(echo $image_commands | jq -er '.dockerLoginCommand')
buildVersionedDockerImageCommand=$(echo $image_commands | jq -er '.buildVersionedDockerImageCommand')
tagVersionedDockerImageCommand=$(echo $image_commands | jq -er '.tagVersionedDockerImageCommand')
pushVersionedDockerImageCommand=$(echo $image_commands | jq -er '.pushVersionedDockerImageCommand')
tagLatestDockerImageCommand=$(echo $image_commands | jq -er '.tagLatestDockerImageCommand')
pushLatestDockerImageCommand=$(echo $image_commands | jq -er '.pushLatestDockerImageCommand')

echo "$(log_date): Running login and build commands" 

# We don't echo this command as it contains an AWS secret
eval $dockerLoginCommand
echo "$(log_date):" $buildVersionedDockerImageCommand && eval $buildVersionedDockerImageCommand

echo "$(log_date): Pushing image up into LUSID" 
echo "$(log_date):" $tagVersionedDockerImageCommand && eval $tagVersionedDockerImageCommand
echo "$(log_date):" $pushVersionedDockerImageCommand && eval $pushVersionedDockerImageCommand
echo "$(log_date):" $tagLatestDockerImageCommand && eval $tagLatestDockerImageCommand
echo "$(log_date):" $pushLatestDockerImageCommand && eval $pushLatestDockerImageCommand
