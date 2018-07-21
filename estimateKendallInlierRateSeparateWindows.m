%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Inlier rate estimation (with separate window estimation) using Kendall 
%   distance from the paper "Using Spatial Order to Boost the Elimination
%   of Incorrect Feature Matches" by Lior Talker, Yael Moses
%   and Ilan Shimshoni, published at CVPR 2016.
%   
%
%   Input:
%   firstSeq - the indexes of the matches from the first image when the
%   features in the second image are sorted by X axis and indexed as 1:N.
%   ([firstSeq]->1:N)
%   secondSeq - the indexes of the matches from the second image when the
%   features in the first image are sorted by X axis and indexed as 1:N.
%   (1:N->[secondSeq])
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
function [inlierRate, startNum1, endNum1, startNum2, endNum2] = estimateKendallInlierRateSeparateWindows(firstSeq,secondSeq,resolution)


    N = length(secondSeq);
    resolutionVec = [(1:(round(resolution*N)):N) N];
    
    % find the window that give the maxima of the number of inliers (absolute number, not inlier rate) in the first image  
    [tempInlierRate, startNum1, endNum1] = estimateKendallInlierRateSeparateWindowsInnerFunc(firstSeq,resolutionVec);
    % find the window that give the maxima of the number of inliers (absolute number, not inlier rate) in the second image  
    [tempInlierRate2, startNum2, endNum2] = estimateKendallInlierRateSeparateWindowsInnerFunc(secondSeq,resolutionVec);
    
    % get rid of the out-of-the-window parts
    tempList = firstSeq((startNum1):endNum1);
    tempList(tempList < startNum2 | tempList > endNum2) = [];

    % estimate the number of inliers only on the overlapping part 
    inlierRate = estimateKendallInlierRate(tempList)*length(tempList);
    % normalize by N to get the inlier rate
    inlierRate = inlierRate/N;

end

function [inlierRate, startNum, endNum] = estimateKendallInlierRateSeparateWindowsInnerFunc(seq,resolutionVec)

    timesKendall = length(resolutionVec);
    numInlierMat = zeros(timesKendall,timesKendall);

    % get the "pyramid" of kendall distances - this function is used for
    % efficiency
    kendallDistMat = kendallDistNormalizedMergeSortFragmentedAlsoMiddle(seq, resolutionVec, 0);
    
    % calculate the inlier number in the overlapping windows based on the pyramid
    for i = 1:(timesKendall-1)
        for j = (i+1):(timesKendall-1)
            intervalLength = resolutionVec(j)-resolutionVec(i);
            numInlierMat(i,j) = estimateKendallInlierRateWithoutKendall(kendallDistMat(i,j),intervalLength)*intervalLength;
        end
    end
    
    % get the maximum of the number of inliers - the window is the one that
    % corresponds to it
    [inlierRate,I] = max(numInlierMat(:));
    [I_row, I_col] = ind2sub(size(numInlierMat),I);
    startNum = resolutionVec(I_row);
    endNum = resolutionVec(I_col+1);

end







