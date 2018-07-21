
% load images
im1 = imread('im1.jpg');
im2 = imread('im2.jpg');

% parameters
resolution = 0.1;
matchesThresh = 1.2;

% run the inlier rate algorithm
[separateInlierRate, jointlyInlierRate, noWindowInlierRate, tSeparateKendall, tJointlyKendall, tNoWindowKendall, separateKendallWindow, jointlyKendallWindow] = runKendallInlierRateOnTwoImages(im1, im2, resolution, matchesThresh);

