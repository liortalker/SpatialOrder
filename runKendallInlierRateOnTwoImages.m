
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Run the inlier rate estimation (with separate window estimation) using 
%   Kendall distance on two images. 
%   The algorithm is an implementation of the paper 
%   "Using Spatial Order to Boost the Elimination
%   of Incorrect Feature Matches" by Lior Talker, Yael Moses
%   and Ilan Shimshoni, published at CVPR 2016.
%   
%
%   Input:
%   im1, im2 - the images to be matched
%   resolution - [0,1] = the resolution of the windows sampling
%   (recommended settings 0.1)
%   matchesThresh - the "Lowe" ratio for matches. The ratio between the
%   nearest neighbor and second nearest neighbor match (recommended value:
%   1.2)
%
%   Output:
%   separateInlierRate, jointlyInlierRate, noWindowInlierRate -
%   domain: [0,1], the estimated fraction of inliers in the matches. 
%   The first is Kendall with separate optimization of the windows, the second
%   Kendall in simoultaneous optimization of the windows and last Kendall without
%   windows computation.
%
%   tSeparateKendall, tJointlyKendall, tNoWindowKendall - time in seconds
%   for the methods: Kendall with separate optimization of the windows, 
%   Kendall in simoultaneous optimization of the windows 
%   and Kendall without windows computation, respectively.
%
%   separateKendallWindow, jointlyKendallWindow - The intervals for the
%   windows of overlap for the the methods: Kendall with separate
%   optimization of the windows and Kendall in simoultaneous optimization
%   of the windows, respectively.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [separateInlierRate, jointlyInlierRate, noWindowInlierRate, tSeparateKendall, tJointlyKendall, tNoWindowKendall, separateKendallWindow, jointlyKendallWindow] = runKendallInlierRateOnTwoImages(im1, im2, resolution, matchesThresh)

    % init
    addpath(genpath('vlfeat'));
    cd vlfeat\toolbox\
    vl_setup;
    cd ..
    cd ..

    % extract SIFT features
    [f1,d1] = vl_sift(single(rgb2gray(im1)));
    [f2,d2] = vl_sift(single(rgb2gray(im2)));
    
    [f1XSorted, f1Idx] = sort(f1(1,:));
    [f2XSorted, f2Idx] = sort(f2(1,:));
   
    d1Sorted = d1(:,f1Idx);
    d2Sorted = d2(:,f2Idx);
    
    % get matches
    [matchesX, closestRatioX] = siftMatchLoweNoRepetitions(d1Sorted', d2Sorted', matchesThresh);
   
    NX = size(matchesX,2);
    uniqueX = unique(matchesX(2,:));
    secondSeq = changem(matchesX(2,:),1:NX,uniqueX);
    
    % run the inlier rate estimations
    tic;
    [jointlyInlierRate, startNum1, endNum1, startNum2, endNum2] = estimateKendallInlierRateJointlyWindows(secondSeq,resolution);
    tJointlyKendall = toc;
    jointlyKendallWindow = [startNum1 ; endNum1 ; startNum2 ; endNum2];

    [val, firstSeq] = sort(secondSeq);
    tic;
    [separateInlierRate, startNum1, endNum1, startNum2, endNum2] = estimateKendallInlierRateSeparateWindows(firstSeq,secondSeq,resolution);
    tSeparateKendall = toc;
    separateKendallWindow = [startNum1 ; endNum1 ; startNum2 ; endNum2];

    tic;
    noWindowInlierRate = estimateKendallInlierRate(secondSeq);
    if (noWindowInlierRate > 1)
        noWindowInlierRate = 1;
    end
    if (noWindowInlierRate < 0)
        noWindowInlierRate = 0;
    end
    tNoWindowKendall = toc;
    
end

