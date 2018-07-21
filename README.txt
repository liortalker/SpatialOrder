This is code provides a minimal working (MWE) example of the paper 
"Using Spatial Order to Boost the Elimination of Incorrect Feature Matches" 
by Lior Talker, Yael Moses and Ilan Shimshoni, presented at CVPR 2016.
For questions or information about the paper or code please 
contact Lior Talker (liortalker@gmail.com or http://liortalker.wix.com/liortalker)
Only for academic or other non-commercial purposes (under GPL terms).

Running the algorithm:

For the synthetic experiments run SyntheticExp1.m or SyntheticExp2.m
(Provide only the number of matches and (for Exp1 the number of inliers)

For a real experiments run either runKendallInlierRate.m
(no parameters - loads im1.jpg and im2.jpg), or runKendallInlierRateOnTwoImages.m
for which the input is two images and parameters, or 
estimateKendallInlierRateSeparateWindows.m (or estimateKendallInlierRateJointlyWindows.m)
for which the input is two sequences and a resolution parameter usually = 0.1)