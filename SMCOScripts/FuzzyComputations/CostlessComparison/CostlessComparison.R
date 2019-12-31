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
#   C2 = Cost


# Alternatives:
#   Workflow 1:  (f1 @ C) (f2 @ C) (f3 @ C | f4 @ C | f5 @ C)
#   Workflow 2:  (f1 @ C) (f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)
#   Workflow 3:  (f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)
#   Workflow 4:  (f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)
#   Workflow 5:  (f1 @ C) (f2 @ C | f3 @ C | f4 @ C) (f5 @ C)
#   Workflow 6:  (f1 @ C) (f2 @ C | f3 @ C | f4 @ C | f5 @ C)
#   Workflow 7:  (f1 @ C) (f2 @ C | f3 @ C) (f4 @ C | f5 @ C)
#   Workflow 8:  (f1 @ C) (f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)
#   Workflow 9:  (f1 @ E) (f2 @ C) (f3 @ C | f4 @ C | f5 @ C)
#   Workflow 10: (f1 @ E) (f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)
#   Workflow 11: (f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)
#   Workflow 12: (f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)
#   Workflow 13: (f1 @ E) (f2 @ C | f3 @ C | f4 @ C) (f5 @ C)
#   Workflow 14: (f1 @ E) (f2 @ C | f3 @ C | f4 @ C | f5 @ C)
#   Workflow 15: (f1 @ E) (f2 @ C | f3 @ C) (f4 @ C | f5 @ C)
#   Workflow 16: (f1 @ E) (f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)



### Initialization ###

citation("FuzzyAHP")
require(FuzzyAHP)

# Pairwise comparison for criteria
criteriaMatrixValues1 = c("1", "4",
                         "1/4", "1")
criteriaMatrixValues2 = c("1", "3",
                         "1/3", "1")
criteriaMatrixValues3 = c("1", "2",
                         "1/2", "1")
criteriaMatrixValues4 = c("1", "1",
                         "1", "1")
criteriaMatrixValues5 = c("1", "1/2",
                         "2", "1")
criteriaMatrixValues6 = c("1", "1/3",
                         "3", "1")
criteriaMatrixValues7 = c("1", "1/4",
                         "4", "1")

# Alternative pairwise comparison in respect to each criteria
executionTimeComparisonMatrixValues = c("1", "1", "1", "1/5", "1", "1", "1", "1", "5", "5", "5", "1", "5", "5", "5", "5", 
                                        "1", "1", "1", "1/5", "1", "1", "1", "1", "5", "5", "5", "1", "5", "5", "5", "5", 
                                        "1", "1", "1", "1/5", "1", "1", "1", "1", "5", "5", "5", "1", "5", "5", "5", "5", 
                                        "5", "5", "5", "1", "5", "5", "5", "5", "9", "9", "9", "5", "9", "9", "9", "9", 
                                        "1", "1", "1", "1/5", "1", "1", "1", "1", "5", "5", "5", "1", "5", "5", "5", "5", 
                                        "1", "1", "1", "1/5", "1", "1", "1", "1", "5", "5", "5", "1", "5", "5", "5", "5", 
                                        "1", "1", "1", "1/5", "1", "1", "1", "1", "5", "5", "5", "1", "5", "5", "5", "5", 
                                        "1", "1", "1", "1/5", "1", "1", "1", "1", "5", "5", "5", "1", "5", "5", "5", "5", 
                                        "1/5", "1/5", "1/5", "1/9", "1/5", "1/5", "1/5", "1/5", "1", "1", "1", "1/5", "1", "1", "1", "1", 
                                        "1/5", "1/5", "1/5", "1/9", "1/5", "1/5", "1/5", "1/5", "1", "1", "1", "1/5", "1", "1", "1", "1", 
                                        "1/5", "1/5", "1/5", "1/9", "1/5", "1/5", "1/5", "1/5", "1", "1", "1", "1/5", "1", "1", "1", "1", 
                                        "1", "1", "1", "1/5", "1", "1", "1", "1", "5", "5", "5", "1", "5", "5", "5", "5", 
                                        "1/5", "1/5", "1/5", "1/9", "1/5", "1/5", "1/5", "1/5", "1", "1", "1", "1/5", "1", "1", "1", "1", 
                                        "1/5", "1/5", "1/5", "1/9", "1/5", "1/5", "1/5", "1/5", "1", "1", "1", "1/5", "1", "1", "1", "1", 
                                        "1/5", "1/5", "1/5", "1/9", "1/5", "1/5", "1/5", "1/5", "1", "1", "1", "1/5", "1", "1", "1", "1", 
                                        "1/5", "1/5", "1/5", "1/9", "1/5", "1/5", "1/5", "1/5", "1", "1", "1", "1/5", "1", "1", "1", "1")


costComparisonMatrixValues = c("1", "2", "2", "5", "1", "1/2", "1", "2", "1/3", "1", "1", "2", "1/3", "1/5", "1/3", "1", 
                               "1/2", "1", "1", "2", "1/2", "1/5", "1/2", "1", "1/5", "1/3", "1/3", "1", "1/5", "1/8", "1/5", "1/3", 
                               "1/2", "1", "1", "2", "1/2", "1/5", "1/2", "1", "1/5", "1/3", "1/3", "1", "1/5", "1/8", "1/5", "1/3", 
                               "1/5", "1/2", "1/2", "1", "1/5", "1/7", "1/5", "1/2", "1/8", "1/5", "1/5", "1/3", "1/8", "1/9", "1/8", "1/5", 
                               "1", "2", "2", "5", "1", "1/2", "1", "2", "1/3", "1", "1", "2", "1/3", "1/5", "1/3", "1", 
                               "2", "5", "5", "7", "2", "1", "2", "5", "1", "2", "2", "5", "1", "1/3", "1", "2", 
                               "1", "2", "2", "5", "1", "1/2", "1", "2", "1/3", "1", "1", "2", "1/3", "1/5", "1/3", "1", 
                               "1/2", "1", "1", "2", "1/2", "1/5", "1/2", "1", "1/5", "1/3", "1/3", "1", "1/5", "1/8", "1/5", "1/3", 
                               "3", "5", "5", "8", "3", "1", "3", "5", "1", "2", "2", "5", "1", "1/2", "1", "2", 
                               "1", "3", "3", "5", "1", "1/2", "1", "3", "1/2", "1", "1", "2", "1/2", "1/5", "1/2", "1", 
                               "1", "3", "3", "5", "1", "1/2", "1", "3", "1/2", "1", "1", "2", "1/2", "1/5", "1/2", "1", 
                               "1/2", "1", "1", "3", "1/2", "1/5", "1/2", "1", "1/5", "1/2", "1/2", "1", "1/5", "1/7", "1/5", "1/2", 
                               "3", "5", "5", "8", "3", "1", "3", "5", "1", "2", "2", "5", "1", "1/2", "1", "2", 
                               "5", "8", "8", "9", "5", "3", "5", "8", "2", "5", "5", "7", "2", "1", "2", "5", 
                               "3", "5", "5", "8", "3", "1", "3", "5", "1", "2", "2", "5", "1", "1/2", "1", "2", 
                               "1", "3", "3", "5", "1", "1/2", "1", "3", "1/2", "1", "1", "2", "1/2", "1/5", "1/2", "1")




### Computing weights ###
# Computing criteria weights
fuzzyCriteriaWeights1 = computeFuzzyWeightsForValues(criteriaMatrixValues1, 2)
fuzzyCriteriaWeights2 = computeFuzzyWeightsForValues(criteriaMatrixValues2, 2)
fuzzyCriteriaWeights3 = computeFuzzyWeightsForValues(criteriaMatrixValues3, 2)
fuzzyCriteriaWeights4 = computeFuzzyWeightsForValues(criteriaMatrixValues4, 2)
fuzzyCriteriaWeights5 = computeFuzzyWeightsForValues(criteriaMatrixValues5, 2)
fuzzyCriteriaWeights6 = computeFuzzyWeightsForValues(criteriaMatrixValues6, 2)
fuzzyCriteriaWeights7 = computeFuzzyWeightsForValues(criteriaMatrixValues7, 2)

# Computing alternative weights
fuzzyExecutionTimeWeights = computeFuzzyWeightsForValues(executionTimeComparisonMatrixValues, 16)
fuzzyCostWeights = computeFuzzyWeightsForValues(costComparisonMatrixValues, 16)

# Fuzzy weights are converted to Fuzzy data
fuzzyExecutionTimeData = convertFuzzyWeightsToFuzzyData(fuzzyExecutionTimeWeights)
fuzzyCostData = convertFuzzyWeightsToFuzzyData(fuzzyCostWeights)

# Merging the weights together before the final computations
data = bindColums(fuzzyExecutionTimeData, fuzzyCostData)

result1 = calculateAHP(fuzzyCriteriaWeights1, data)
result2 = calculateAHP(fuzzyCriteriaWeights2, data)
result3 = calculateAHP(fuzzyCriteriaWeights3, data)
result4 = calculateAHP(fuzzyCriteriaWeights4, data)
result5 = calculateAHP(fuzzyCriteriaWeights5, data)
result6 = calculateAHP(fuzzyCriteriaWeights6, data)
result7 = calculateAHP(fuzzyCriteriaWeights7, data)

# Defuzzyfy before ranking
defuzzified1 = defuzziffy(result1, "Yager")
defuzzified2 = defuzziffy(result2, "Yager")
defuzzified3 = defuzziffy(result3, "Yager")
defuzzified4 = defuzziffy(result4, "Yager")
defuzzified5 = defuzziffy(result5, "Yager")
defuzzified6 = defuzziffy(result6, "Yager")
defuzzified7 = defuzziffy(result7, "Yager")

rank1 = compareResults(defuzzified1)
rank2 = compareResults(defuzzified2)
rank3 = compareResults(defuzzified3)
rank4 = compareResults(defuzzified4)
rank5 = compareResults(defuzzified5)
rank6 = compareResults(defuzzified6)
rank7 = compareResults(defuzzified7)

print(rank1)
print(rank2)
print(rank3)
print(rank4)
print(rank5)
print(rank6)
print(rank7)

#### Evaluation EXAMPLE ENDS HERE ####

