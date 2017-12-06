# Multiplex Immuno Panel FISH analysis
# HF van Essen
# 2017-12
##############
#
# sample '.xlsx' files can be read with 'readMPIFfile' function and data will be stored in 
# a dedicated S4 structure. 
#
# A threshold holding the thresholds for each probe can be given or a text file with the 
# same name as the sample '.xlsx' file may be placed next to the sample file. Data will be 
# read with the sample data and basic values will be calculated according to the thresholds.
#
# Thresholds can be updated manually (one probe at a time) with the function 'updateThresholds'.
# A plot can be generated immediately with 'plot = TRUE' to see the difference.
#
# A simple overview of the data structure can be requested with 'overview()'
#
# data can be plotted with 'plotCells()'
#
# Use 'writeMIPFdata()' to write experiment data to disk.
##


