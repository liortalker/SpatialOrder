%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Inlier rate estimation (with joint window estimation) using Kendall 
%   distance from the paper "Using Spatial Order to Boost the Elimination
%   of Incorrect Feature Matches" by Lior Talker, Yael Moses
%   and Ilan Shimshoni, published at CVPR 2016.
%
%   Input:
%   seq - the sequence of feature indexes, e.g., the indexes of the matches
%   from the first image when the features in the second image are sorted
%   by X axis and indexed as 1:N. ([firstSeq]->1:N)
%   resolution - [0,1] = the resolution of the windows sampling
%   (recommended settings 0.1)
%
%   Output:
%   inlierRate - domain: [0,1], the estimated fraction of inliers in the
%   matches
%   startNum1, endNum1 - the start and end of the window in the second
%   image
%   startNum2, endNum2 - the start and end of the window in the first
%   image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [inlierRate, startNum1, endNum1, startNum2, endNum2] = estimateKendallInlierRateJointlyWindows(seq,resolution)

    N = length(seq);
    resolutionVec = [(1:(round(resolution*N)):N) N];
    jumpsNum = length(resolutionVec);
    inlierRateMat = zeros(jumpsNum,jumpsNum,jumpsNum,jumpsNum);

    for i1 = 1:(jumpsNum-1)
        for j1 = (i1+1):jumpsNum
            curList = seq(seq >= resolutionVec(i1) & seq <= resolutionVec(j1));
            kendallDistMat = kendallDistNormalizedMergeSortFragmentedAlsoMiddle(curList, (resolutionVec(i1:j1)-resolutionVec(i1)+1), 1);
            curResolutionVec = resolutionVec(i1:j1);
            for i2 = 1:(j1-i1)
                for j2 = (i2+1):(j1-i1+1)
                    intervalLength = curResolutionVec(j2) - curResolutionVec(i2);
                    inlierRateMat(i1,j1,i2,j2) = estimateKendallInlierRateWithoutKendall(kendallDistMat(i2,j2-1),intervalLength)*intervalLength;
                end
            end
        end
    end
    
    [val, I] = max(inlierRateMat(:));
    [startNum1,endNum1,startNum2,endNum2] = ind2sub(size(inlierRateMat),I);
    inlierRate = val/N;
    endNum2 = resolutionVec(endNum2);
    startNum2 = resolutionVec(startNum2);
    endNum1 = resolutionVec(endNum1);
    startNum1 = resolutionVec(startNum1);
    
end


