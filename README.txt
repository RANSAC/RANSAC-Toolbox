RANSAC Toolbox by Marco Zuliani
email: marco.zuliani@gmail.com
-------------------------------

Introduction
------------

This is a research (and didactic) oriented toolbox to explore the
RANSAC algorithm. The functions are reasonably well documented and
there is a directory containing examples to estimate 2D lines, 3D
planes, RST transformations and homographies in presence of
outliers. However a previous exposure to the algorithm may be very
helpful in understanding the options available. A tutorial introducing
RANSAC with several examples using this toolbox can be found in the
documentation directory. If you add other examples (i.e. other
estimators) please contact me and we can try to improve the
package. Of course I also expect some feedback regarding the bugs that
might still be present...

How To Start
------------

CD to the root directory (i.e. whatever/RANSAC) and launch the
script SetLocalPath. Then you may start playing around. Give a look to
the folder whatever/RANSAC/Examples where you can find two examples
for the estimation of homographies and lines. Templates for the
estimation functions and the model fitting error functions can be
found in whatever/RANSAC/Models. Run the script RANSAC_update to check
if updates are available and to install them.

Extras
------

Contains the routines to fit lines, planes, rotation/scale/translation
transformations and an homography. Also contains a tutorial/manual
abut RANSAC.

Warning
-------

The examples clear the workspace. I noticed that this practice raised some
concerns by some users in this forum, however I believe that sometimes
(like in this case) it is an appropriate choice.

License
-------

This toolbox is distributed under the terms of the GNU LGPL. Please
refer to the files COPYING and COPYING.LESSER for more information.

Acknowledgments
---------------
I would like to thank the following people for their useful feedback:

Dong Li - pointed out some bug in the example files
Tamar Back - suggested to check the parameter sigma
Frederico Lopes  - raised the issue of repeated points in the  homography estimation 
Jayanth Nayak - pointed out a bug in the estimation of the lines
David Portabella Clotet  - pointed out two bugs
Chris Volpe - pointed out a bug in handling ind_tabu and random number seed
Zhe Zang - noted a ill conditioning related warning in the homography
estimation routines
Ali Kalihili - pointed out a typo in the tutorial document

If you plan to use this software package in and referenced published
material (e.g. conferences, journals, workshops...) an acknowledgment
will be greatly appreciated as well as a copy of your publication. Here are a couple
of templates for bibtex:

@misc{Zuliani08a,
    author={M. Zuliani},
    title={RANSAC toolbox for Matlab},
    howpublished={[web page] http://www.mathworks.com/matlabcentral/fileexchange/18555 },
    year={Nov. 2008},
    note={[Accessed on ## set the date ##]},
}

@techreport{Zuliani08b,
	author = "M. Zuliani",
	title = "RANSAC for Dummies",
	month = "Nov.",
	year = "2008"
}


Updates History (Discontinued: check the log on github)
-------------------------------------------------------

- Jul 2014: Added support for parameters structure to be passed to the 
  evalaution and estiamtion functions (see test_RANSAC_circles.m)

- Jan 2012: Migrating to github. From now on please check the update history 
  on github.

- Nov 2011: Fixed some bugs in the example scripts.

- August 2011: General fixes. Added affine model. 

- 18 October 2009: Fixed a bug in get_minimal_sample_set.m to handle
  the tabu indices. Improved RST estimation routines. Major improvement
  in the manual/tutorial

- ?? February 2009: Modified the get_consensus_set_cost. Added the 
  MLESAC mode. Updated the manual/tutorial

- 27 November 2008: Fixed a bug in the parameter check in the error
  estimation routines. Added options to validate the MSS, the
  parameter vector and to re-estimate the parameters. Added line
  estimation routines. Modified the get_minimal_sample_set
  function. Added manual/tutorial.

- 29 June 2008: Included the ind_tabu and seed_fix options. Modified
  the interface for the estimation routines and the fitting error
  routines. Improved the documentation. Some other general
  improvements.

- 10 July 2008: Included the routines for 3D plane estimation. Fixed a
  bug in the threshold selection for lines. Some other general
  improvements and fixes in the help of the functions.

- 25 July 2008: Added self update procedure: RANSAC_update.m

Thanks for your interest,
Marco Zuliani
