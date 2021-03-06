#### Approach EXAMPLE STARTS HERE ####

### Helper functions ###

# Helper function similar to the bindColums found in FuzzyAHP library, it binds FuzzyData
# objects together into a single FuzzyData object by the rows
bindRows <- function(data1, data2) {
  fnMin = rbind(data1@fnMin, data2@fnMin)
  fnModal = rbind(data1@fnModal, data2@fnModal)
  fnMax = rbind(data1@fnMax, data2@fnMax)
  
  return(new("FuzzyData", fnMin = fnMin, fnModal = fnModal, fnMax = fnMax))
}

# Helper function that converts a FuzzyWeights class to a FuzzyData class
convertFuzzyWeightsToFuzzyData <- function(fuzzyWeights) {
  
  for (fuzzyNumber in 1:length(fuzzyWeights@fnMin)){
    # Extracting fnMin, fnModal and fnMax from FuzzyWeights
    fnMinFuzzyWeights = matrix(fuzzyWeights@fnMin[c(fuzzyNumber)], nrow = 1, ncol = 1)
    fnModalFuzzyWeights = matrix(fuzzyWeights@fnModal[c(fuzzyNumber)], nrow = 1, ncol = 1)
    fnMaxFuzzyWeights = matrix(fuzzyWeights@fnMax[c(fuzzyNumber)], nrow = 1, ncol = 1)
    
    # Constructing the FuzzyData class
    tmpFuzzyData <- new("FuzzyData", fnMin=fnMinFuzzyWeights, fnModal=fnModalFuzzyWeights, fnMax=fnMaxFuzzyWeights)
    
    if(fuzzyNumber > 1){
      completeFuzzyData = bindRows(completeFuzzyData, tmpFuzzyData)
    }
    else {
      completeFuzzyData = tmpFuzzyData
    }
  }
  result <- completeFuzzyData
}

# Helper function that does the following:
# 1. Creates a matrix from the received values
# 2. Turns the matrix into a pairwise comparison matrix
# 3. Fuzzyfying the pairwise comparison matrix
# 4. Computing fuzzy weights for the fuzzy pairwise comparison matrix
computeFuzzyWeightsForValues <- function(alternativeMatrixValues, nrOfRowsAndCol) {
  # 1. Creates a matrix from the received values
  newMatrix = matrix(alternativeMatrixValues, nrow = nrOfRowsAndCol, ncol = nrOfRowsAndCol, byrow = TRUE)
  
  # 2. Turns the matrix into a pairwise comparison matrix
  newPairwiseComparisonMatrix = pairwiseComparisonMatrix(newMatrix)
  
  # Computing consistency ratio of the criteria pairwise comparison
  consistencyRatioValue = consistencyRatio(newPairwiseComparisonMatrix, print.report = TRUE)
  print(consistencyRatioValue)
  
  # 3. Fuzzyfying the pairwise comparison matrix
  fuzzyPairwiseComparisonMatrix = fuzzyPairwiseComparisonMatrix(newPairwiseComparisonMatrix)
  print(fuzzyPairwiseComparisonMatrix)
  
  # 4. Computing fuzzy weights for the fuzzy pairwise comparison matrix
  fuzzyWeights = calculateWeights(fuzzyPairwiseComparisonMatrix)
  print(fuzzyWeights)
  result <- fuzzyWeights
}

### Helper functions end here ###



### AHP structure ###
# Goal: Pick the best workflow configuration

# Criterias:
#   C1 = Execution time
#   C2 = Privacy
#   C3 = Cost
#   C4 = Network Bandwidth
#   C5 = Energy usage

# Alternatives:
#   Workflow 1: 
#   Workflow 2: 
#   Workflow 3: 
#   Workflow 4: 
#   Workflow 5: 
#   Workflow 6: 
#   Workflow 7: 
#   Workflow 8: 

### Initialization ###

citation("FuzzyAHP")
require(FuzzyAHP)

# Criteria pairwise comparison
criteriaMatrixValues = c("1",  "3",  "5",  "7",
                         "1/3","1",  "3",  "5",
                         "1/5","1/3","1",  "3", 
                         "1/7","1/5","1/3","1")

# Alternative pairwise comparison in respect to each criteria
executionTimeComparisonMatrixValues = c("1",  "1/6","1",  "1/7","2", "1/7","1/4","1/8", 
                                        "6",  "1",  "6",  "1",  "8", "1",  "2",  "1/2", 
                                        "1",  "1/6","1",  "1/6","3", "1/6","1/4","1/7", 
                                        "7",  "1",  "6",  "1",  "9", "1",  "3",  "1", 
                                        "1/2","1/8","1/3","1/9","1", "1/9","1/6","1/9", 
                                        "7",  "1",  "6",  "1",  "9", "1",  "3",  "1", 
                                        "4",  "1/2","4",  "1/3","6", "1/3","1",  "1/4", 
                                        "8",  "2",  "7",  "1",  "9", "1",  "4",  "1")

privacyComparisonMatrixValues = c("1",  "5","1",  "5","1/5","5","1/5","5", 
                                  "1/5","1","1/5","1","1/9","1","1/9","1", 
                                  "1",  "5","1",  "5","1/5","5","1/5","5", 
                                  "1/5","1","1/5","1","1/9","1","1/9","1", 
                                  "5",  "9","5",  "9","1",  "9","1",  "9", 
                                  "1/5","1","1/5","1","1/9","1","1/9","1", 
                                  "5",  "9","5",  "9","1",  "9","1",  "9", 
                                  "1/5","1","1/5","1","1/9","1","1/9","1")

costComparisonMatrixValues = c("1",  "3","1",  "2",  "1/3","4","1/6","4", 
                               "1/3","1","1/4","1",  "1/6","1","1/9","1", 
                               "1",  "4","1",  "3",  "1/2","5","1/5","5", 
                               "1/2","1","1/3","1",  "1/5","2","1/8","2", 
                               "3",  "6","2",  "5",  "1",  "7","1/3","7", 
                               "1/4","1","1/5","1/2","1/7","1","1/9","1", 
                               "6",  "9","5",  "8",  "3",  "9","1",  "9", 
                               "1/4","1","1/5","1/2","1/7","1","1/9","1")

networkBandwidthComparisonMatrixValues = c("1",  "5","1",  "5","2",  "5","1/5","1/4", 
                                           "1/5","1","1/5","1","1/3","1","1/9","1/9", 
                                           "1",  "5","1",  "5","2",  "5","1/5","1/4", 
                                           "1/5","1","1/5","1","1/3","1","1/9","1/9", 
                                           "1/2","3","1/2","3","1",  "3","1/7","1/6", 
                                           "1/5","1","1/5","1","1/3","1","1/9","1/9", 
                                           "5",  "9","5",  "9","7",  "9","1",  "1", 
                                           "4",  "9","4",  "9","6",  "9","1",  "1")


### Computing weights ###
# Computing criteria weights
fuzzyCriteriaWeights = computeFuzzyWeightsForValues(criteriaMatrixValues, 4)

# Computing alternative weights
fuzzyExecutionTimeWeights = computeFuzzyWeightsForValues(executionTimeComparisonMatrixValues, 8)
fuzzyPrivacyWeights = computeFuzzyWeightsForValues(privacyComparisonMatrixValues, 8)
fuzzyCostWeights = computeFuzzyWeightsForValues(costComparisonMatrixValues, 8)
fuzzyNetworkBandwidthWeights = computeFuzzyWeightsForValues(networkBandwidthComparisonMatrixValues, 8)

# Fuzzy weights are converted to Fuzzy data
fuzzyExecutionTimeData = convertFuzzyWeightsToFuzzyData(fuzzyExecutionTimeWeights)
fuzzyPrivacyData = convertFuzzyWeightsToFuzzyData(fuzzyPrivacyWeights)
fuzzyCostData = convertFuzzyWeightsToFuzzyData(fuzzyCostWeights)
fuzzyNetworkBandwidthData = convertFuzzyWeightsToFuzzyData(fuzzyNetworkBandwidthWeights)

# Merging the weights together before the final computations
data = bindColums(fuzzyExecutionTimeData, fuzzyPrivacyData)
data = bindColums(data, fuzzyCostData)
data = bindColums(data, fuzzyNetworkBandwidthData)

result = calculateAHP(fuzzyCriteriaWeights, data)
print(result)

# Defuzzyfy before ranking
defuzzified = defuzziffy(result, "Yager")
print(defuzzified)

rank = compareResults(defuzzified)
print(rank)

#### Approach EXAMPLE ENDS HERE ####





