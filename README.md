Multi Target Model Factory with API Container
===============================================

This project contains scripts for building large numbers of models
using DataRobot, where each project uses a different target column 
from the same datset. We call this a is Multi-Target Model Factory.

### Assumptions

This project assumes you have a valid DataRobot account and that you
have set up your account credentials in the 
[drconfig.yaml](https://datarobot-public-api-client.readthedocs-hosted.com/en/v2.19.0/setup/configuration.html) 
file so that you can use the API.
 
We assume that you have R installed with the [DataRobot R Package](https://cran.r-project.org/web/packages/datarobot/index.html).
 
We assume that you have a single dataset that contains multiple target columns and a set of 
feature columns you want to reuse for each model.

Each model built will have a different target but use all non-target columns 
as features. The script provided currently assume that you want to run the full autopilot on each
target and choose the model at the top of the leaderboard. This logic is easily modified.


### Instructions

The script [standard_example.R](scripts/standard_example.R) shows how to run a model factory for a classification or regression project.

```
cd scripts
Rscript standard_example.R 
```

The script [timeseries_example.R](scripts/timeseries_example.R) shows how to do it for a time series project.

```
cd scripts
Rscript timeseries_example.R
```

