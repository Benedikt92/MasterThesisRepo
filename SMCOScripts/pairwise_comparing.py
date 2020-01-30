def normalize_values(input_list):
	largest_value = max(input_list)
	smallest_value = min(input_list)
	normalized_values = []
	for value in input_list:
		if largest_value - smallest_value != 0:
			normalized_value = (value - smallest_value) / (largest_value - smallest_value)
		else:
			normalized_value = 0
		normalized_values.append(normalized_value)
	return normalized_values
	

def pairwise_compare_two_values_and_map_to_fuzzy_scale(normalized_value1, normalized_value2, estimates_mapping, estimates_mapping_inverse, objective_is_to_minimize):
	difference = normalized_value1 - normalized_value2
	absolute_difference = abs(difference)
	rounded_difference = round(absolute_difference, 1)

	if difference == 0: # Same values
		return estimates_mapping[rounded_difference]
	elif difference > 0: # Value 1 is larger
		if objective_is_to_minimize:
			return estimates_mapping_inverse[rounded_difference]
		else:
			return estimates_mapping[rounded_difference]
	else: # Value 2 is larger
		if objective_is_to_minimize:
			return estimates_mapping[rounded_difference]
		else:
			return estimates_mapping_inverse[rounded_difference]


def pairwise_compare_list_of_values(normalized_list_of_values, estimates_mapping, estimates_mapping_inverse, objective_is_to_minimize):
	rows = []
	for value1 in normalized_list_of_values:
		columns = []
		for value2 in normalized_list_of_values:
			columns.append(pairwise_compare_two_values_and_map_to_fuzzy_scale(value1, value2, estimates_mapping, estimates_mapping_inverse, objective_is_to_minimize))
		rows.append(columns)
	return rows

def prepare_pairwise_comparison_for_script(pairwise_comparison_matrix):
	script_input = 'c('
	
	for row in pairwise_comparison_matrix:
		for column in row:
			script_input += '"' + column + '", '
		script_input += '\n'

	# cuttin off the last comma and new line and adding a parenthesis	
	return script_input[:-3] + ')'



### functions used to generate the latex table###
def pairwise_compare_two_values_and_map_to_latex_fuzzy_scale(normalized_value1, normalized_value2, estimates_mapping, estimates_mapping_inverse, objective_is_to_minimize):
	difference = normalized_value1 - normalized_value2
	absolute_difference = abs(difference)
	rounded_difference = round(absolute_difference, 1)

	if difference == 0: # Same values
		return estimates_mapping[rounded_difference]
	elif difference > 0: # Value 1 is larger
		if objective_is_to_minimize:
			return estimates_mapping_inverse[rounded_difference]
		else:
			return estimates_mapping[rounded_difference]
	else: # Value 2 is larger
		if objective_is_to_minimize:
			return estimates_mapping[rounded_difference]
		else:
			return estimates_mapping_inverse[rounded_difference]

def prepare_pairwise_comparison_for_latex(workflow_configurations, normalized_list_of_values, latex_map, latex_map_inverse, objective_is_to_minimize):
	rows = []
	for value1 in normalized_list_of_values:
		columns = []
		for value2 in normalized_list_of_values:
			columns.append(pairwise_compare_two_values_and_map_to_latex_fuzzy_scale(value1, value2, latex_map, latex_map_inverse, objective_is_to_minimize))
		rows.append(columns)
	
	latex_table = ''
	for x in range(len(rows)):
		row = rows[x]
		workflow_configuration = workflow_configurations[x]

		latex_table += '\\tiny ' + workflow_configuration + ' & '
		for column in row:
			latex_table += column + ' & '
		latex_table = latex_table[:-3] + ' \\\\\n\\hline\n'

	return latex_table



print('pairwise comparing\n==============================')

# Input for Approach example
#workflow_configurations = ['(f1 @ E) (f2 @ C) (f3 @ C)', '(f1 @ C) (f2 @ C) (f3 @ C)', '(f1 @ E) (f2 @ C | f3 @ C)', '(f1 @ C) (f2 @ C | f3 @ C)', '(f1 @ E | f2 @ E) (f3 @ C)', '(f1 @ C | f2 @ C) (f3 @ C)', '(f1 @ E | f2 @ E | f3 @ E)', '(f1 @ C | f2 @ C | f3 @ C)']
#execution_time = [20.7, 18.3, 20.4, 18, 21.4, 18, 19, 17.6]
#cost = [151.74682, 226.74692, 126.74682, 201.74692, 76.74672, 251.74702, 0.18, 260.08042]
#privacy = [2, 3, 2, 3, 1, 3, 1, 3]
#network_bandwidth = [5, 10, 5, 10, 7, 10, 0, 1]

# Input for Evaluation example
workflow_configurations =  ['(f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ C) (f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ E) (f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ C) (f2 @ C) (f3 @ C | f4 @ C | f5 @ C)', '(f1 @ E) (f2 @ C) (f3 @ C | f4 @ C | f5 @ C)', '(f1 @ C) (f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ E) (f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ C) (f2 @ C | f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ E) (f2 @ C | f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ C) (f2 @ C | f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ E) (f2 @ C | f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ C) (f2 @ C | f3 @ C | f4 @ C | f5 @ C)', '(f1 @ E) (f2 @ C | f3 @ C | f4 @ C | f5 @ C)', '(f1 @ C | f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ C | f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ C | f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ C | f2 @ C) (f3 @ C | f4 @ C | f5 @ C)', '(f1 @ C | f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ C | f2 @ C | f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ C | f2 @ C | f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ C | f2 @ C | f3 @ C | f4 @ C | f5 @ C)']
execution_time = [18.49835, 14.900546, 19.31992, 15.722116, 19.31512, 15.717316, 19.30332, 15.705516, 19.32112, 15.723316, 19.30932, 15.711516, 19.30452, 15.706716, 19.29272, 15.694916, 18.48775, 19.30932, 19.30452, 19.29272, 19.30452, 19.29272, 19.28612, 19.27432]
cost = [179.1217248, 131.1216788, 154.1217248, 106.1216788, 154.1217248, 106.1216788, 129.1217248, 81.12167875, 154.1217248, 106.1216788, 129.1217248, 81.12167875, 129.1217248, 81.12167875, 104.1217248, 56.12167875, 154.1217248, 129.1217248, 129.1217248, 104.1217248, 129.1217248, 104.1217248, 104.1217248, 79.12172475]
privacy = [5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 5, 5, 5, 5, 5, 5, 5]
network_bandwidth = [743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743, 743]

# Input for Costless comparison example
#workflow_configurations =  ['(f1 @ C) (f2 @ C) (f3 @ C | f4 @ C | f5 @ C)', '(f1 @ C) (f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ C) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ C) (f2 @ C | f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ C) (f2 @ C | f3 @ C | f4 @ C | f5 @ C)', '(f1 @ C) (f2 @ C | f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ C) (f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ E) (f2 @ C) (f3 @ C | f4 @ C | f5 @ C)', '(f1 @ E) (f2 @ C) (f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ E) (f2 @ C) (f3 @ C) (f4 @ C) (f5 @ C)', '(f1 @ E) (f2 @ C | f3 @ C | f4 @ C) (f5 @ C)', '(f1 @ E) (f2 @ C | f3 @ C | f4 @ C | f5 @ C)', '(f1 @ E) (f2 @ C | f3 @ C) (f4 @ C | f5 @ C)', '(f1 @ E) (f2 @ C | f3 @ C) (f4 @ C) (f5 @ C)']
#execution_time = [6.338, 6.405, 6.491, 5.561, 6.353, 6.286, 6.439, 6.506, 7.254, 7.321, 7.407, 6.477, 7.269, 7.202, 7.355, 7.422]
#cost = [110.7959088, 135.7959088, 135.7959088, 160.7959088, 110.7959088, 85.79590875, 110.7959088, 135.7959088, 83.8059275, 108.8059275, 108.8059275, 133.8059275, 83.8059275, 58.8059275, 83.8059275, 108.8059275]
#privacy = []
#network_bandwidth = []

estimates_mapping = {0.0: "1", 0.1: "1", 0.2: "2", 0.3: "3", 0.4: "4", 0.5: "5", 0.6: "6", 0.7: "7", 0.8: "8", 0.9: "9", 1.0: "9"}
estimates_mapping_inverse = {0.0: "1", 0.1: "1", 0.2: "1/2", 0.3: "1/3", 0.4: "1/4", 0.5: "1/5", 0.6: "1/6", 0.7: "1/7", 0.8: "1/8", 0.9: "1/9", 1.0: "1/9"}
latex_map = {0.0: "(1,1,1)", 0.1: "($(\\frac{{1}}{{2}}$,1,2)", 0.2: "(1,2,3)", 0.3: "(2,3,4)", 0.4: "(3,4,5)", 0.5: "(4,5,6)", 0.6: "(5,6,7)", 0.7: "(6,7,8)", 0.8: "(7,8,9)", 0.9: "(8,9,9)", 1.0: "(8,9,9)"}
latex_map_inverse = {0.0: "(1,1,1)", 0.1: "($\\frac{{1}}{{2}}$,1,2)", 0.2: "$(\\frac{{1}}{{3}}, \\frac{{1}}{{2}}, 1)$", 0.3: "$(\\frac{{1}}{{4}}, \\frac{{1}}{{3}}, \\frac{{1}}{{2}})$", 0.4: "$(\\frac{{1}}{{5}}, \\frac{{1}}{{4}}, \\frac{{1}}{{3}})$", 0.5: "$(\\frac{{1}}{{6}}, \\frac{{1}}{{5}}, \\frac{{1}}{{4}})$", 0.6: "$(\\frac{{1}}{{7}}, \\frac{{1}}{{6}}, \\frac{{1}}{{5}})$", 0.7: "$(\\frac{{1}}{{8}}, \\frac{{1}}{{7}}, \\frac{{1}}{{6}})$", 0.8: "$(\\frac{{1}}{{9}}, \\frac{{1}}{{8}}, \\frac{{1}}{{7}})$", 0.9: "$(\\frac{{1}}{{9}}, \\frac{{1}}{{9}}, \\frac{{1}}{{8}})$", 1.0: "$(\\frac{{1}}{{9}}, \\frac{{1}}{{9}}, \\frac{{1}}{{8}})$"}

print('Execution time\n--------------')
print('execution time input: ', execution_time)
normalized_list = normalize_values(execution_time)
print('execution time normalized values: ', normalized_list)
comparison_matrix = pairwise_compare_list_of_values(normalized_list, estimates_mapping, estimates_mapping_inverse, True)
print('\nexecution time r script input:')
print(prepare_pairwise_comparison_for_script(comparison_matrix))
print('\nexecution time latex input')
print(prepare_pairwise_comparison_for_latex(workflow_configurations, normalized_list, latex_map, latex_map_inverse, True))



print('Cost\n--------------')
print('cost input: ', cost)
normalized_list = normalize_values(cost)
print('cost normalized values: ', normalized_list)
comparison_matrix = pairwise_compare_list_of_values(normalized_list, estimates_mapping, estimates_mapping_inverse, True)
print('\ncost r script input:')
print(prepare_pairwise_comparison_for_script(comparison_matrix))
print('\ncost latex input')
print(prepare_pairwise_comparison_for_latex(workflow_configurations, normalized_list, latex_map, latex_map_inverse, True))



if len(network_bandwidth) > 0:
	print('Network bandwidth\n--------------')
	print('network bandwidth input: ', network_bandwidth)
	normalized_list = normalize_values(network_bandwidth)
	print('network bandwidth normalized values: ', normalized_list)
	comparison_matrix = pairwise_compare_list_of_values(normalized_list, estimates_mapping, estimates_mapping_inverse, True)
	print('\nnetwork bandwidth r script input:')
	print(prepare_pairwise_comparison_for_script(comparison_matrix))
	print('\nnetwork bandwidth latex input')
	print(prepare_pairwise_comparison_for_latex(workflow_configurations, normalized_list, latex_map, latex_map_inverse, True))


if len(privacy) > 0:
	print('Privacy \n--------------')
	print('privacy input: ', privacy)
	normalized_list = normalize_values(privacy)
	print('privacy normalized values: ', normalized_list)
	comparison_matrix = pairwise_compare_list_of_values(normalized_list, estimates_mapping, estimates_mapping_inverse, True)
	print('\nprivacy r script input:')
	print(prepare_pairwise_comparison_for_script(comparison_matrix))
	print('\nprivacy latex input')
	print(prepare_pairwise_comparison_for_latex(workflow_configurations, normalized_list, latex_map, latex_map_inverse, True))



















