#### Evaluation EXAMPLE STARTS HERE ####

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
  #consistencyRatioValue = consistencyRatio(newPairwiseComparisonMatrix, print.report = TRUE)
  #print(consistencyRatioValue)
  
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

# Alternatives:
# Workflow 1:  (f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)
# Workflow 2:  (f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)
# Workflow 3:  (f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)
# Workflow 4:  (f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)
# Workflow 5:  (f1 @ C) (f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)
# Workflow 6:  (f1 @ E) (f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)
# Workflow 7:  (f1 @ C) (f2 @ C) (f3 @ C | f4 @ C | f5 @ C)
# Workflow 8:  (f1 @ E) (f2 @ C) (f3 @ C | f4 @ C | f5 @ C)
# Workflow 9:  (f1 @ C) (f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)
# Workflow 10: (f1 @ E) (f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)
# Workflow 11: (f1 @ C) (f2 @ C | f3 @ C) (f4 @ C | f5 @ C)
# Workflow 12: (f1 @ E) (f2 @ C | f3 @ C) (f4 @ C | f5 @ C)
# Workflow 13: (f1 @ C) (f2 @ C | f3 @ C | f4 @ C) (f5 @ C)
# Workflow 14: (f1 @ E) (f2 @ C | f3 @ C | f4 @ C) (f5 @ C)
# Workflow 15: (f1 @ C) (f2 @ C | f3 @ C | f4 @ C | f5 @ C)
# Workflow 16: (f1 @ E) (f2 @ C | f3 @ C | f4 @ C | f5 @ C)
# Workflow 17: (f1 @ C | f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)
# Workflow 18: (f1 @ C | f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)
# Workflow 19: (f1 @ C | f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)
# Workflow 20: (f1 @ C | f2 @ C) (f3 @ C | f4 @ C | f5 @ C)
# Workflow 21: (f1 @ C | f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)
# Workflow 22: (f1 @ C | f2 @ C | f3 @ C) (f4 @ C | f5 @ C)
# Workflow 23: (f1 @ C | f2 @ C | f3 @ C | f4 @ C) (f5 @ C)
# Workflow 24: (f1 @ C | f2 @ C | f3 @ C | f4 @ C | f5 @ C)


### Initialization ###

citation("FuzzyAHP")
require(FuzzyAHP)


# Pairwise comparison for the three different scenarios
# Scenario 1: Focus on execution time
scenarioOneCriteriaMatrixValues = c("1",   "7", "7", "7",
                                    "1/7", "1", "1", "1",
                                    "1/7", "1", "1", "1", 
                                    "1/7", "1", "1", "1")

# Scenario 2: Focus on cost
scenarioTwoCriteriaMatrixValues = c("1", "1", "1/7", "1",
                                    "1", "1", "1/7", "1",
                                    "7", "7", "1",   "7", 
                                    "1", "1", "1/7", "1")

# Scenario 3: Focus on privacy
scenarioThreeCriteriaMatrixValues = c("1", "1/7", "1", "1",
                                      "7", "1", "7", "7",
                                      "1", "1/7", "1", "1", 
                                      "1", "1/7", "1", "1")

# Scenario 4: Focus on multiple criteria
scenarioFourCriteriaMatrixValues = c("1",   "1",   "1",   "1",
                                     "1",   "1",   "1",   "1",
                                     "1",   "1",   "1",   "1", 
                                     "1",   "1",   "1",   "1")

# Alternative pairwise comparison in respect to each criteria
executionTimeComparisonMatrixValues = c("1", "1/8", "2", "1/6", "2", "1/6", "2", "1/6", "2", "1/6", "2", "1/6", "2", "1/6", "2", "1/6", "1", "2", "2", "2", "2", "2", "2", "2", 
                                        "8", "1", "9", "2", "9", "2", "9", "2", "9", "2", "9", "2", "9", "2", "9", "2", "8", "9", "9", "9", "9", "9", "9", "9", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "6", "1/2", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "6", "8", "8", "8", "8", "8", "8", "8", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "6", "1/2", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "6", "8", "8", "8", "8", "8", "8", "8", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "6", "1/2", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "6", "8", "8", "8", "8", "8", "8", "8", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "6", "1/2", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "6", "8", "8", "8", "8", "8", "8", "8", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "6", "1/2", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "6", "8", "8", "8", "8", "8", "8", "8", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "6", "1/2", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "6", "8", "8", "8", "8", "8", "8", "8", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "6", "1/2", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "8", "1", "6", "8", "8", "8", "8", "8", "8", "8", 
                                        "1", "1/8", "2", "1/6", "2", "1/6", "2", "1/6", "2", "1/6", "2", "1/6", "2", "1/6", "2", "1/6", "1", "2", "2", "2", "2", "2", "2", "2", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1", 
                                        "1/2", "1/9", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1", "1/8", "1/2", "1", "1", "1", "1", "1", "1", "1")

privacyComparisonMatrixValues = c("1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "9", "9", "9", "9", "9", "9", "9", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "9", "9", "9", "9", "9", "9", "9", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "9", "9", "9", "9", "9", "9", "9", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "9", "9", "9", "9", "9", "9", "9", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "9", "9", "9", "9", "9", "9", "9", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "9", "9", "9", "9", "9", "9", "9", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "9", "9", "9", "9", "9", "9", "9", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "1", "9", "9", "9", "9", "9", "9", "9", "9", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1", 
                                  "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1/9", "1", "1", "1", "1", "1", "1", "1", "1")

costComparisonMatrixValues = c("1", "1/4", "1/2", "1/6", "1/2", "1/6", "1/4", "1/8", "1/2", "1/6", "1/4", "1/8", "1/4", "1/8", "1/6", "1/9", "1/2", "1/4", "1/4", "1/6", "1/4", "1/6", "1/6", "1/8", 
                               "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "2", "1", "1", "1/2", "1", "1/2", "1/2", "1/4", 
                               "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "1", "1/4", "1/2", "1/6", "1/2", "1/6", "1/4", "1/8", "1", "1/2", "1/2", "1/4", "1/2", "1/4", "1/4", "1/6", 
                               "6", "2", "4", "1", "4", "1", "2", "1/2", "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "4", "2", "2", "1", "2", "1", "1", "1/2", 
                               "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "1", "1/4", "1/2", "1/6", "1/2", "1/6", "1/4", "1/8", "1", "1/2", "1/2", "1/4", "1/2", "1/4", "1/4", "1/6", 
                               "6", "2", "4", "1", "4", "1", "2", "1/2", "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "4", "2", "2", "1", "2", "1", "1", "1/2", 
                               "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "2", "1", "1", "1/2", "1", "1/2", "1/2", "1/4", 
                               "8", "4", "6", "2", "6", "2", "4", "1", "6", "2", "4", "1", "4", "1", "2", "1/2", "6", "4", "4", "2", "4", "2", "2", "1", 
                               "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "1", "1/4", "1/2", "1/6", "1/2", "1/6", "1/4", "1/8", "1", "1/2", "1/2", "1/4", "1/2", "1/4", "1/4", "1/6", 
                               "6", "2", "4", "1", "4", "1", "2", "1/2", "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "4", "2", "2", "1", "2", "1", "1", "1/2", 
                               "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "2", "1", "1", "1/2", "1", "1/2", "1/2", "1/4", 
                               "8", "4", "6", "2", "6", "2", "4", "1", "6", "2", "4", "1", "4", "1", "2", "1/2", "6", "4", "4", "2", "4", "2", "2", "1", 
                               "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "2", "1", "1", "1/2", "1", "1/2", "1/2", "1/4", 
                               "8", "4", "6", "2", "6", "2", "4", "1", "6", "2", "4", "1", "4", "1", "2", "1/2", "6", "4", "4", "2", "4", "2", "2", "1", 
                               "6", "2", "4", "1", "4", "1", "2", "1/2", "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "4", "2", "2", "1", "2", "1", "1", "1/2", 
                               "9", "6", "8", "4", "8", "4", "6", "2", "8", "4", "6", "2", "6", "2", "4", "1", "8", "6", "6", "4", "6", "4", "4", "2", 
                               "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "1", "1/4", "1/2", "1/6", "1/2", "1/6", "1/4", "1/8", "1", "1/2", "1/2", "1/4", "1/2", "1/4", "1/4", "1/6", 
                               "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "2", "1", "1", "1/2", "1", "1/2", "1/2", "1/4", 
                               "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "2", "1", "1", "1/2", "1", "1/2", "1/2", "1/4", 
                               "6", "2", "4", "1", "4", "1", "2", "1/2", "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "4", "2", "2", "1", "2", "1", "1", "1/2", 
                               "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "2", "1/2", "1", "1/4", "1", "1/4", "1/2", "1/6", "2", "1", "1", "1/2", "1", "1/2", "1/2", "1/4", 
                               "6", "2", "4", "1", "4", "1", "2", "1/2", "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "4", "2", "2", "1", "2", "1", "1", "1/2", 
                               "6", "2", "4", "1", "4", "1", "2", "1/2", "4", "1", "2", "1/2", "2", "1/2", "1", "1/4", "4", "2", "2", "1", "2", "1", "1", "1/2", 
                               "8", "4", "6", "2", "6", "2", "4", "1", "6", "2", "4", "1", "4", "1", "2", "1/2", "6", "4", "4", "2", "4", "2", "2", "1")

networkBandwidthComparisonMatrixValues = c("1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
                                           "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1")


### Computing weights ###
# Computing criteria weights
scenarioOneFuzzyCriteriaWeights = computeFuzzyWeightsForValues(scenarioOneCriteriaMatrixValues, 4)
scenarioTwoFuzzyCriteriaWeights = computeFuzzyWeightsForValues(scenarioTwoCriteriaMatrixValues, 4)
scenarioThreeFuzzyCriteriaWeights = computeFuzzyWeightsForValues(scenarioThreeCriteriaMatrixValues, 4)
scenarioFourFuzzyCriteriaWeights = computeFuzzyWeightsForValues(scenarioFourCriteriaMatrixValues, 4)



# Computing alternative weights
fuzzyExecutionTimeWeights = computeFuzzyWeightsForValues(executionTimeComparisonMatrixValues, 24)
fuzzyPrivacyWeights = computeFuzzyWeightsForValues(privacyComparisonMatrixValues, 24)
fuzzyCostWeights = computeFuzzyWeightsForValues(costComparisonMatrixValues, 24)
fuzzyNetworkBandwidthWeights = computeFuzzyWeightsForValues(networkBandwidthComparisonMatrixValues, 24)

# Fuzzy weights are converted to Fuzzy data
fuzzyExecutionTimeData = convertFuzzyWeightsToFuzzyData(fuzzyExecutionTimeWeights)
fuzzyPrivacyData = convertFuzzyWeightsToFuzzyData(fuzzyPrivacyWeights)
fuzzyCostData = convertFuzzyWeightsToFuzzyData(fuzzyCostWeights)
fuzzyNetworkBandwidthData = convertFuzzyWeightsToFuzzyData(fuzzyNetworkBandwidthWeights)

# Merging the weights together before the final computations
data = bindColums(fuzzyExecutionTimeData, fuzzyPrivacyData)
data = bindColums(data, fuzzyCostData)
data = bindColums(data, fuzzyNetworkBandwidthData)

scenarioOneResult = calculateAHP(scenarioOneFuzzyCriteriaWeights, data)
scenarioTwoResult = calculateAHP(scenarioTwoFuzzyCriteriaWeights, data)
scenarioThreeResult = calculateAHP(scenarioThreeFuzzyCriteriaWeights, data)
scenarioFourResult = calculateAHP(scenarioFourFuzzyCriteriaWeights, data)

print(scenarioOneResult)
print(scenarioTwoResult)
print(scenarioThreeResult)
print(scenarioFourResult)

# Defuzzyfy before ranking
scenarioOneDefuzzified = defuzziffy(scenarioOneResult, "Yager")
scenarioTwoDefuzzified = defuzziffy(scenarioTwoResult, "Yager")
scenarioThreeDefuzzified = defuzziffy(scenarioThreeResult, "Yager")
scenarioFourDefuzzified = defuzziffy(scenarioFourResult, "Yager")

print(scenarioOneDefuzzified)
print(scenarioTwoDefuzzified)
print(scenarioThreeDefuzzified)
print(scenarioFourDefuzzified)

scenarioOneRank = compareResults(scenarioOneDefuzzified)
scenarioTwoRank = compareResults(scenarioTwoDefuzzified)
scenarioThreeRank = compareResults(scenarioThreeDefuzzified)
scenarioFourRank = compareResults(scenarioFourDefuzzified)

print(scenarioOneRank)
print(scenarioTwoRank)
print(scenarioThreeRank)
print(scenarioFourRank)

#### Evaluation EXAMPLE ENDS HERE ####
