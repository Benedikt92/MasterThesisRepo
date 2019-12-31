def function_fusion_configurations(list_of_functions, starting_nr_of_functions, index, result):
	results = []
	if starting_nr_of_functions == index:
		results.append(result)
		return results

	results = []
	for j in range(index, (starting_nr_of_functions)):
		sublist_one = list_of_functions[:j-index+1]
		sublist_two = list_of_functions[j-index+1:]
		if len(sublist_one) > 0:
			fused = ' | '.join(sublist_one)
			sublist_one = []
			sublist_one.append(fused)
		else: 
			sublist_one = []
		results += function_fusion_configurations(sublist_two, starting_nr_of_functions, j+1, result + sublist_one)		

	return results


def placement_configurations_for_list_of_functions(list_of_functions):
	if len(list_of_functions) == 1:
		function = list_of_functions[0]
		cloud_function = function + ' @ C'
		edge_function = function + ' @ E'
		return [[cloud_function], [edge_function]]

	function = list_of_functions[0]
	cloud_function = function + ' @ C'
	edge_function = function + ' @ E'

	lis = []
	res = placement_configurations_for_list_of_functions(list_of_functions[1:])
	for elem in res:
		lis.append([cloud_function] + elem)
		lis.append([edge_function] + elem)

	return lis


def function_placement_configurations(list_of_configurations):
	placement_configurations = []
	for configuration in list_of_configurations:
		res = placement_configurations_for_list_of_functions(configuration)
		for r in res:
			placement_configurations.append(r)
	return placement_configurations


def prune_configurations(list_of_configurations):
	ignore_first_function = True
	pruned_configurations = []
	
	for configuration in list_of_configurations:
		valid_configuration = True
		for function in configuration:
			if ignore_first_function:
				ignore_first_function = False
			else: 
				if 'E' in function:
					valid_configuration = False
		
		if valid_configuration:
			pruned_configurations.append(configuration)
		ignore_first_function = True
	return pruned_configurations


starting_configuration = ['f1', 'f2', 'f3']

# List up configurations considering function fusion
fused_configurations = function_fusion_configurations(starting_configuration, len(starting_configuration), 0, [])
# List up configurations considering function placement
placement_configurations = function_placement_configurations(fused_configurations)
# Prune the results
pruned_configurations = prune_configurations(placement_configurations)

# Print results
print('Configurations: ')
for configuration in pruned_configurations:
	print(configuration)






