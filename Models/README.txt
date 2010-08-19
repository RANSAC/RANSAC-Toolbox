The Templates
-------------

	The functions error_foo.m and estimate_foo.m are templates to help the user designing the functions that will be plugged inside the RANSAC function. 

	The function error_foo returns the fitness of the data given a model instantiated with a given parameter vector. The fitness is usually expressed as the squared projection error between a datum and its projection on the model manifold. 

	The function estimate_foo estimates the parameter vector of a given model starting from a set of data.

Notation
--------
Theta	- parameter vector
X	- data
k	- cardinality of the minimal sample set (i.e. the minimum number of 	  elements to estimate the parameters of a model)
sigma   - standard deviation of the Gaussian noise affecting the data 