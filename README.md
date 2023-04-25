# SGPiezometry
Optimised scripts for processing data for the Goddard et al. (2020) subgrain piezometry paper, forked from Rellie Goddard's repository

Changes to this code:
1) This includes a version of MTEX that has adapted some codes. Chiefly, these codes are, when searching for points along the intercept, replacing the EBSD.findByLocation scripts with EBSD.findBy[X/Y]Location.
Currently, to ensure that you use this sped-up version, ensure that the 'dev' flag in all the scripts is set to one, and the included version of mtex is added to your path. This can be done with the prep_mtex script.

2) To speed up processing, it is not necessarily necessary to plot the output of every iteration of the sensitivity tests, which, especially with large data sets, can be very slow. Therefore new plotting flags are included to reduce the plot outputs as needed.

References:
Goddard, R.M., Hansen, L.N., Wallis, D., Stipp, M., Holyoke III, C.W., Kumamoto, K.M. and Kohlstedt, D.L., 2020. A subgrain‐size piezometer calibrated for EBSD. Geophysical Research Letters, 47(23), p.e2020GL090056.
https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2020GL090056
