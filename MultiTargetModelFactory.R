library(datarobot)
library(data.table)

# ####################################################################
# Generate a range of models from the specified data
# df - A dataframe containing all data
# targets - The list of target columns to build independent models
# projectName - Prefix for project name in datarobot
# resultDir - Path to write the results
# metric - The metric to include in the results file
# ####################################################################

runMultiTargetModelFactory <- function(df, targets, projectNamePrefix, resultDir, metric) {

	# WE WRITE OUT THE MODEL RESULTS INTO A TABLE
	resultsFile = paste(resultDir, 'model_list.tsv', sep='/')

	# Test the output file before we begin 
	result = tryCatch({
		rez <- file(resultsFile, "w")
		writeLines("target\tdatarobot_project_id\tdatarobot_model_id\tmetric",con=rez,sep="\n")
	}, warning = function(w) {
    		message('Potential problem with writing your results file.')
		message(w)
		return(0)
	}, error = function(e) {
	        message('Problem with your results file. Please check the path')
                message(e)
                return(0)
	}, finally = {
    		# CLEAN UP
	})

	# Force data frame to be a data table
	dt	<- data.table(df)
        colnames	<- names(dt)
	featureList 	<- colnames[!colnames %in% targets] 

	# iterate over the keyset
	for(target in targets) { 
		# Subset the data and create the project for this key
		temp.data	<- dt
		projName 	<- paste(projectNamePrefix, target, sep='_')
		temp.proj	<- SetupProject( dataSource=temp.data, projectName=projName )
		SetTarget(project=temp.proj, target=target, mode = 'manual')
		
		F_id = CreateFeaturelist(temp.proj$projectId, 'featureList', featureList)
		StartNewAutoPilot(temp.proj, featurelistId = F_id)

		WaitForAutopilot(project = temp.proj)

		# Once Autopilot has finished we retrieve the best model ID
		all.models 	<- ListModels(temp.proj)
		model.frame 	<- as.data.frame(all.models)
		model.type 	<- model.frame$modelType

		best.model	<- all.models[[1]]
		modelId		<- best.model$modelId
		metric		<- best.model$metrics[[metric]]$validation		
		writeLines(paste(target, temp.proj$projectId, modelId, metric, sep='\t'), con=rez, sep="\n")		
	}

	# CLOSE THE RESULTS FILE 
	close(rez)
	return(1)
} 

