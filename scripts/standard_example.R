source("DataRobot_multitarget_model_factory.R")

dataset = "../data/standard_example.csv"
df = read()
targets = [] 
project_name = "Multi-Target Example" 
result_dir = "results"
metric = "MAE"
other_metrics = ""

datarobot_multitarget_model_factory(df, targets, project_name, result_dir, metric, other_metrics)


