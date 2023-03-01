# Ordinal-LAD
Matlab codes for estimating the ordered response median regression model. Description of this model and its estimator can be found in the paper:

Chen, L. Y., Oparina, E., Powdthavee, N., and Srisuma, S. (2022). "Robust Ranking of Happiness Outcomes: A Median Regression Perspective".

The paper has been published at Journal of Economic Behavior and Organization. See https://www.sciencedirect.com/science/article/abs/pii/S0167268122002062. 
The latest working paper version of this work can be found in this repository. 

The matlab function ordered_response_LAD defind in ordered_response_LAD.m can be used to compute the LAD estimator for the ordered response median regression model. It can also be used to perform the estimation at other quantiles. Implementation of this function requires the Gurobi solver, which is freely available for academic purposes. See the readme pdf file for further details on the implementation of this estimator and replication of the empirical results of the paper. 

