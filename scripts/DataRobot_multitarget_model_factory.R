library(datarobot)
library(data.table)

# ####################################################################
# Generate a range of models from the specified data
# df            - (Dataframe) A dataframe containing all data
# targets       - (Array) The list of target columns to build independent models
# project_name  - (String) Prefix for project name in datarobot
# result_dir    - (String) Path to write the results
# metric        - (String) The metric to report on
# ####################################################################

# CHANGE THIS IF YOU ARE USING A LOCAL DATAROBOT INSTALL
base_url="https://app.datarobot.com/"

datarobot_multitarget_model_factory <- function(df, targets, project_name, result_dir, metric) {

	# WE WRITE OUT THE MODEL RESULTS INTO A TABLE
	resultsFile = paste(result_dir, 'model_list.tsv', sep='/')
	resultsPage = paste(result_dir, 'model_list.html', sep='/')

	# Write a header to the results files before we begin 
	result = tryCatch({
		rez <- file(resultsFile, "w")
		writeLines("target\tdatarobot_project_id\tdatarobot_model_id\tmetric",con=rez,sep="\n")

		page <- file(resultsPage, "w")
		writeLines( 
                   paste( "<html> <head> <title>DataRobot Models for", project_name, "<title> <link rel='stylesheet' href='style.css'></head> <body>", sep=""), 
                   con=page, sep="\n" 
                )
                header = paste("<div class='rTable'>
                 <div class='rTableRow'>
                 <div class='rTableHead'>Model</div>
                 <div class='rTableHead'>", metric, "</div>
                 <div class='rTableHead'></div>
                 </div>", sep="")
                writeLines( header, con=page, sep="\n")

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
	dt		<- data.table(df)
        colnames	<- names(dt)
	featureList 	<- colnames[!colnames %in% targets] 

	# iterate over the keyset
	for(target in targets) { 
		# Subset the data and create the project for this key
		temp.data	<- dt
		projName 	<- paste(project_name, target, sep='_')
		temp.proj	<- SetupProject( dataSource=temp.data, projectName=projName )
		SetTarget(project=temp.proj, target=target, mode = 'manual')
		
		Flist = CreateFeaturelist(temp.proj$projectId, 'featureList', featureList)
                F_id = Flist$featurelistId
                print("Featurelist Created")
		StartNewAutoPilot(temp.proj, featurelistId = F_id)
                print("Auto-Pilot Started... Halting until completion")
		WaitForAutopilot(project = temp.proj)

		# Once Autopilot has finished we retrieve the best model ID
		all.models 	<- ListModels(temp.proj)
		model.frame 	<- as.data.frame(all.models)
		model.type 	<- model.frame$modelType

		best.model	<- all.models[[1]]
		modelId		<- best.model$modelId
		metric		<- best.model$metrics[[metric]]$validation		
                url 		<- paste( base_url, "projects/", temp.proj$projectId, "/models/", modelId, "/lift-chart")
                entry		<- paste("<div class='rTableRow'>
                                          <div class='rTableCell'><a href='", url ,"'>", target, "</a></div>
                                          <div class='rTableCell'>", metric, "</div>
                                          <div class='rTableCell'></div>
                                          </div>", sep="")
		writeLines(paste(target, temp.proj$projectId, modelId, metric, sep='\t'), con=rez, sep="\n")		
                writeLines( entry, con=page, sep="\n")
	}
        # FINISH THE TABLE IN THE HTML OUTPUT

        footer = paste("</body></html>")
        writeLines( footer, con=page, sep="\n")
	# CLOSE THE RESULTS FILE 
	close(page)
	close(rez)
	return(1)
} 

