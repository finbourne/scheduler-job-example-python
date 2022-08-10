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

sudo apt update && sudo apt install jq

apiUrl=$(cat secrets.json | jq -r '.apiUrl')
schedulerUrl=$(cat secrets.json | jq -r '.schedulerUrl')
tokenUrl=$(cat secrets.json | jq -r '.tokenUrl')
clientId=$(cat secrets.json | jq -r '.clientId')
clientSecret=$(cat secrets.json | jq -r '.clientSecret')
username=$(cat secrets.json | jq -r '.username')
password=$(cat secrets.json | jq -r '.password')

echo "$(log_date): Collecting token from" $tokenUrl

token=$(curl -s -X POST $tokenUrl \
   -H "Content-Type: application/x-www-form-urlencoded; charset=ISO-8859-1" \
   --data-urlencode grant_type="password" \
   --data-urlencode username=$username \
   --data-urlencode password=$password \
   --data-urlencode scope="openid client groups" \
   --data-urlencode client_id=$clientId \
   --data-urlencode client_secret=$clientSecret \
    | jq -r '.access_token' ) 

echo "$(log_date): Generating commands to generate and push image for: $image_name:$image_version" 

images_api="{$schedulerUrl}/api/images"

image_commands=$(curl -s -X POST $images_api \
   -H "Authorization: Bearer "$token \
   -H "Content-Type: application/json-patch+json" \
   -d "{'imageName':'$image_name:$image_version'}") \

dockerLoginCommand=$(echo $image_commands | jq -r '.dockerLoginCommand')
buildVersionedDockerImageCommand=$(echo $image_commands | jq -r '.buildVersionedDockerImageCommand')
tagVersionedDockerImageCommand=$(echo $image_commands | jq -r '.tagVersionedDockerImageCommand')
pushVersionedDockerImageCommand=$(echo $image_commands | jq -r '.pushVersionedDockerImageCommand')
tagLatestDockerImageCommand=$(echo $image_commands | jq -r '.tagLatestDockerImageCommand')
pushLatestDockerImageCommand=$(echo $image_commands | jq -r '.pushLatestDockerImageCommand')

echo "$(log_date): Running login and build commands" 

# We dont echo this command as it contains an AWS secret
eval $dockerLoginCommand
echo "$(log_date):" $buildVersionedDockerImageCommand && eval $buildVersionedDockerImageCommand

echo "$(log_date): Pushing image up into LUSID" 
echo "$(log_date):" $tagVersionedDockerImageCommand && eval $tagVersionedDockerImageCommand
echo "$(log_date):" $pushVersionedDockerImageCommand && eval $pushVersionedDockerImageCommand
echo "$(log_date):" $tagLatestDockerImageCommand && eval $tagLatestDockerImageCommand
echo "$(log_date):" $pushLatestDockerImageCommand && eval $pushLatestDockerImageCommand