# MasterThesisRepo
This repo contains all code logic related to my master thesis project

Environment Setup and Installation 

The proposed approach takes in different optimization criteria (execution time, cost, privacy and bandwidth), a workflow, and profiling data as an input. With this data, the proposed approach figures out what is the most efficient workflow configuration when considering both edge and cloud platforms. 
The environment was set up using the Amazon Web Services (AWS) platform. The cloud environment consists of small modular Lambda functions, created using the AWS Lambda solution, that form an event-driven serverless workflow created using the AWS Step Functions solution. The step function workflows then run on AWS Servers in a data center that forms the AWS cloud. The AWS Cloud Watch solution was then used for collecting profiling data about the functions running on both the edge and the cloud. The Cloud Trail solution was then used to trigger the cloud part of the workflow to run after the edge part of the workflow had finished running

Hardware Requirements

Raspberry Pi 3 Model B+ 
•	64-bit quad-core processor 
•	1 GB RAM

Environment Setup

First: Setup the edge device by following the below tutorials from AWS (click on each link and follow the steps)

1.	Setup Raspberry Pi
https://docs.aws.amazon.com/greengrass/v1/developerguide/setup-filter.rpi.html

2.	Configure AWS IoT Greengrass on AWS IoT
https://docs.aws.amazon.com/greengrass/v1/developerguide/gg-config.html

3.	Start AWS IoT Greengrass on the core device
https://docs.aws.amazon.com/greengrass/v1/developerguide/gg-device-start.html

4.	Create and package a Lambda function
https://docs.aws.amazon.com/greengrass/v1/developerguide/create-lambda.html

5.	Configure the Lambda function for AWS IoT Greengrass
https://docs.aws.amazon.com/greengrass/v1/developerguide/config-lambda.html

6.	Deploy cloud configurations to a Greengrass core device
https://docs.aws.amazon.com/greengrass/v1/developerguide/configs-core.html 

7.	Verify the Lambda function is running on the core device
https://docs.aws.amazon.com/greengrass/v1/developerguide/lambda-check.html


Second: Set up the workflows on the AWS platform using the Lambda and Step functions services

1.	To generate the list of workflow configurations:
a.	The default “starting_configuration” is set to an example of a workflow with 3 functions “['f1', 'f2', 'f3']”
For the image processing part of WildRydes application, the “starting_configuration” should be changed to “['f1', 'f2', 'f3', 'f4', 'f5']”
b.	Run the file “list_workflow_configurations.py” to get the list of combinations of fused functions and the list of workflow configurations

2.	Use the list of combinations of fused functions extracted in the previous step to manually create all different combinations of fused functions as Lambda functions
The two versions (edge and cloud) of the first function (face detection) can be found in 
“WildRydesModifications” folder in this repository
The rest of the functions (f2: face-search, f3: thumbnail, f4: index-face, f5: persist-metadata) can be found in 
https://github.com/aws-samples/aws-serverless-workshops/tree/master/ImageProcessing/src/lambda-functions 

    For information on how to create Lambda functions follow the tutorial provided by AWS
    https://docs.aws.amazon.com/toolkit-for-eclipse/v1/user-guide/lambda-tutorial.html

3.	Use Step function service to create out workflows based on the output list of workflow configurations from step 1 and the previously created Lambda functions 
For information on how to use step functions follow the tutorial provided by AWS https://docs.aws.amazon.com/step-functions/latest/dg/tutorial-creating-lambda-state-machine.html#create-lambda-state-machine-step-4

4.	The AWS Cloud Watch service is used for collecting profiling data about the functions running on both the edge and the cloud using the two below workflows. These profiling data will be used in the next step (Third section) to estimate the execution time, cost, privacy and network bandwidth for each workflow configuration.

    •	(f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)

    •	(f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)

    In addition, the profiling data of all different combinations of fused functions -which were implemented in aws step functions- in the workflows are also collected to      compare   the estimates with actual measured outcome.
    For information on how to use AWS Cloud Watch service follow the tutorial provided by AWS
    https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
   https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html


Third: Generating the rank of the workflow configurations using fuzzy computations 

1.	For each of the workflow configurations generated in step 1 in the second sections above, the execution time, cost, privacy and network bandwidth are calculated using predefined models and the profiling data collected earlier.

2.	The output of step 1 is then used as an input to “pairwise_comparing.py” in the “SMCOScripts” folder to produce the Comparison Matrices.

3.	The produced Comparison Matrices of step 2 are then used as an input for the “FuzzyComputations” in the “SMCOScripts” folder to generate the final ranks of the workflow configurations regarding the defined optimization criteria. 
There are three files in “FuzzyComputations” folder where each represent a particular case:
a)	ApproachExample: the approach is applied on a simple example of a workflow consisting of 3 functions running in sequence.
b)	CostlessComparison: a comparison with the work presented in Costless [1]. In this case, only the execution time and cost are considered. 
c)	EvaluationExample: This considers the optimization of the image processing part of WildRydes application. Four scenarios with different optimization requirements are considered here as follows: 
	Focus on execution time
	Focus on cost
	Focus on privacy
	Focus equally on the 4 different criteria (execution time, cost, privacy and network bandwidth)


References:
[1] Elgamal, T. (2018, October). Costless: Optimizing cost of serverless computing through function fusion and placement. In 2018 IEEE/ACM Symposium on Edge Computing (SEC) (pp. 300-312). IEEE.
