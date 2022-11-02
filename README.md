# An example scheduler job in Python

This project contains a sample application which can be packaged into a Docker container for running in the LUSID [scheduler](https://www.lusid.com/scheduler2/swagger/index.html). Feel free to use this project as a template. Clone the project, add your own Python application, and then upload your image which can be run in the LUSID scheduler. 

For the purposes of this template, our sample application will call some instruments from the [LUSID APIs](https://www.lusid.com/api/swagger/index.html).

The application will authenticate with environment variables (see <b>Section 5</b> below).

### 1. Install Docker on your local machine

First off, you need to ensure that you have [Docker](https://www.docker.com/) installed on your local machine.

### 2. Build and run your image locally

Before uploading your image to LUSID, you'll want to build and run it locally, just to check it works ok. Here is the official [Docker Python guide](https://docs.docker.com/language/python/), but there are many tutorials out there for building and running Python images.

Build the image using the following command.

Two notes on this command:

* You'll need to run it in the same directory as the Dockerfile
* The `-t` is the image name (defined by you) which will be used in LUSID

```
docker build . -t scheduler-job-example-python
```

Run a container:

```
docker run \
-e FBN_LUSID_API_URL=<YOUR_DOMAIN_API_URL> \
-e FBN_PASSWORD=<YOUR_USER_PW> \
-e FBN_APP_NAME=<YOUR_APP_NAME> \
-e FBN_USERNAME=<YOUR_USERNAME> \
-e FBN_CLIENT_SECRET=<YOUR_SECRET> \
-e FBN_CLIENT_ID=<YOUR_CLIENT_ID> \
-e FBN_TOKEN_URL=<YOUR_TOKEN_URL> \
scheduler-job-example-python
```

### 3. Upload image to your LUSID account

Once you're happy with your image, push it up to LUSID. There are two ways:

1. ~~Run the commands one-by-one~~ [Not currently supported]
2. Use the `docker_setup.sh` script from this directory which has packaged up the relevant commands into one script

#### 3.1 Run the commands one-by-one

There are 6 commands you'll need to run to build, push, and tag the image. We are extending the LUSID UI to generate these commands.

#### 3.2 Run the setup script

Alternatively, you can run the `docker_setup.sh` script in this directory, which packages the 6 commands together. To run this script, you will need a standard [secrets.json](https://support.lusid.com/knowledgebase/article/KA-01663/#secrets-file) file in the root of this project, then run.

```
docker_setup.sh -n scheduler-job-example-python -v 0.0.8
```

The options are as follows:

* `-n` is image name
* `-v` is image version

### 4. Use the image in a Scheduler job

Once the image is uploaded to LUSID, you can use it when creating a scheduler job - see instructions at [Creating a Scheduler Job](https://support.lusid.com/knowledgebase/article/KA-01645/#create-job).

* Under **Uploading your Docker image**, reference the image you uploaded in the previous step
* There is no need to supply any command line arguments
* Specify the environment variables as listed [here](https://support.lusid.com/knowledgebase/article/KA-01645/#config-store), if necessary setting up the Configuration Store as described [here](https://support.lusid.com/knowledgebase/article/KA-01645/#upload-credentials)
* Complete the remaining steps to setup and test the Job

### FAQ

<b>How do I run the tests in this project?</b>

```
python -m unittest discover tests
```
