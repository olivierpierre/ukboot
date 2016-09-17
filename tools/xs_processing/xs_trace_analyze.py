#!/usr/bin/python

import numpy as np
import sys

trace=""

# Take as parameter a list of floats, return a dictionary containing:
# - key "total_val": total number of values
# - key "total_sum": sum of all the values in the list
# - key "avg": average value, 
# - key "med:" median
# - key "stdev:" st. deviation 
def process_list(l):
	res = {}
	tot_sum = 0
	
	res["total_val"] = len(l)
	res["total_sum"] = np.sum(l)
	res["avg"] = np.average(l)
	res["med"] = np.median(l)
	res["stdev"] = np.std(l)

	return res

if __name__ == "__main__":
	lines = ""
	samples = {}
	per_op_results = {}
	total_xs_time = 0.0

	if(len(sys.argv) != 2):
		print "Usage: " + sys.argv[0] + " <tracefile>"
		exit()

	trace = sys.argv[1]
	
	# Read the trace file
	with open(trace,'r') as f:
		lines = f.read().splitlines()
	
	# construct a dict with operation as keys, and a list of times
	# as values 
	for l in lines:
		sample = l.split(";")
		if sample[1] not in samples:
			samples[sample[1]] = []
		samples[sample[1]].append(float(sample[0])*1000000) # convert to us
	
	# iterate over the operation and construct one result dict for
	# each operation (see the process_list function)
	for op, latencies in samples.iteritems():
		if op not in per_op_results:
			per_op_results[op] = process_list(latencies)
			total_xs_time += per_op_results[op]["total_sum"]
		
	# Print results
	print "# Total time: " + str(total_xs_time)
	print "# Per operation time below"
	print "# Operation; %of total time; invocations; op. total time; "\
		"avg per op time; stdev per op time; median val"
	
	for op, res in sorted(per_op_results.iteritems()):
		# Fist compute the percentage of total time spent in this 
		# operation
		total_time_pct = (res["total_sum"] * 100) / total_xs_time
		# Print res
		print op + ";" + str(total_time_pct) + ";" + str(res["total_val"]) + \
			";" + str(res["total_sum"]) + ";" + str(res["avg"]) + ";" + \
			str(res["stdev"]) + ";" + str(res["med"])
		
