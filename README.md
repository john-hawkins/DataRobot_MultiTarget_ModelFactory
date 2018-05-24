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

We assume that your data contains multiple target columns and a set of 
feature columns you want to reuse for each model.

Each model built will have a different target but use all non-target columns 
as features.

It also currently assumes that you want to run the full autopilot and 
choose the model at the top of the leaderboard.

