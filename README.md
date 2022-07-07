# An example scheduler job in Python

This project contains a sample application which can be packaged into a Docker container for running in the LUSID [scheduler](https://www.lusid.com/scheduler2/swagger/index.html). Feel free to use this project as a template. Clone the project, add your own Python application, and then upload your image which can be run in the LUSID scheduler. 

For the purposes of this template, our sample application will call some instruments from the [LUSID APIs](https://www.lusid.com/api/swagger/index.html).

### 1. Install Docker on your local machine

First off, you need to ensure that you have [Docker](https://www.docker.com/) installed on your local machine.

### 2. Build and run your image locally

Before uploading your image to LUSID, you'll want to build and run it locally, just to check it works ok. Here is the official [Docker Python guide](https://docs.docker.com/language/python/), but there are many tutorials out there for building and running Python images.

### 3. Upload image to your LUSID account

Once you're happy with your image, push it up to LUSID. There are a number of commands you'll need to run locally. See this guide for more details:

[How do I upload a Docker image to the FINBOURNE AWS store?](https://support.lusid.com/knowledgebase/article/KA-01698/en-us)

### 4. Use the image in a Scheduler job

Once the image is up on LUSID, you can use it when creating a scheduler job.

See the [Uploading your Docker image](https://support.lusid.com/knowledgebase/article/KA-01645/#create-job) section.

### 5. Adding LUSID login credentials

As part of the job setup, you'll want to add environment variables with your login credentials. This is what the scheduler will use to authenticate and call the APIs. 

See the [Authenticating to the LUSID Python SDK using environment variables](https://support.lusid.com/knowledgebase/article/KA-01645/#create-job) section.


### FAQ

<b>How do I run the tests in this project?</b>

```
python -m unittest discover tests
```