Multi Target Model Factory with API Container
===============================================

The goal of this project is to demonstrate a Multi Target Model Factory.

The code will allow you to build and deploy a large number of models 
on the same dataset, where there are multiple targets that you want to
predict. 

It will allow you to do this in an automated fashion. 

It will also build an intermediate API container that demonstrates how 
you could deploy these models in a way that gives you the scores for all
targets in a single return function. 


### Assumptions

This project assumes you have a valid DataRobot account and that you
have set up your account credentials in the drconfig.yaml file so that
you can use the API.
 
We assume that you have R installed with the DataRobot package.

We assume you have docker installed.

We assume that your data contains multiple target columns and a set of 
feature columns you want to reuse for each model.

Each model built will have a different target but use all non-target columns 
as features.

It also currently assumes that you want to run the full autopilot and 
choose the model at the top of the leaderboard.


### What you get

The model factory code will store the details of each project and model 
(one for each target) in a config file that will be used by the intermediate API.

You can then use the dockerfile to build a container that runs a python
API to accept scoring requests. Each scoring request is forwarded to all
models, and the results a compiled into a single return value.



### How to use it

The [EXAMPLE.R](EXAMPLE.R) script shows you how to run the model factory component
alone. This will build all the models for each KEY in the data and store the results.

To do a complete run including setting up the required config and building the docker
image, you can use the [RUN.sh](RUN.sh) script and pass in the following parameters:

* The training data 
* The key column
* The target column
* A directory name for your output (will be created)
* Your DataRobot credendtials: USERNAME, API_TOKEN, and API_KEY
* The metric you want to see reported (Commonly AUC for binary classification and MAPE or MAE for regression) 

This script will do the following:

* Create the app directory
* Copy the dockerfile and python code inside
* Create the required config file
* Execute the model factory on your dataset 
** and write the results to a model config file in your app
* Execute the docker script to build your container

You can then deploy the container and use it. 

