%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Synthetic experiment with changing inlier rate
%   Input:
%
%   N - number of matches
%   Output:
%
%   KError, K2DError, K1DError, KGTError - absolute error between computed
%   inlier rate and the ground truth inlier rate for Kendall without
%   windows computation, Kendall in simoultaneous optimization of the windows,
%   Kendall with separate optimization of the windows and Kendall with
%   ground truth windows, respectively.
%
%   meanTimeKendallPyramid, meanTimeKendallPyramidOneDim, meanTimeKendall,
%   meanTimeKendallGTOneDim - mean running times for Kendall without
%   windows computation, Kendall in simoultaneous optimization of the windows,
%   Kendall with separate optimization of the windows and Kendall with
%   ground truth windows, respectively.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [KError, K2DError, K1DError, KGTError, meanTimeKendallPyramid, meanTimeKendallPyramidOneDim, meanTimeKendall, meanTimeKendallGTOneDim] = SyntheticExp2(N)

    resolution = 0.1;
    numRuns = 500;
    NGVec = zeros(1,numRuns);
    jump = round(N/numRuns);
    % create the ground truth inlier rate (linear in the number of
    % iterations)
    for i = 1:numRuns
        NGVec(i) = (i-1)*jump;
    end
    inlierRateKendallPyramidVec = zeros(1,numRuns);
    timeKendallPyramidVec = zeros(1,numRuns);
    OKendallPyramid = zeros(4,numRuns);
    inlierRateKendallPyramidOneDimVec = zeros(1,numRuns);
    timeKendallPyramidOneDimVec = zeros(1,numRuns);
    OKendallPyramidOneDim = zeros(4,numRuns);
    inlierRateKendallVec = zeros(1,numRuns);
    timeKendallVec = zeros(1,numRuns);
    inlierRateKendallGTVec = zeros(1,numRuns);
    timeKendallGTVec = zeros(1,numRuns);
    inlierRateGT = zeros(1,numRuns);
    OGT = zeros(4,numRuns);

    for i = 1:numRuns
        i
        NG = NGVec(i);
        % generate the margins randomly (the outliers in the edges of the
        % image)
        OVec = randomlySelectA1A2B1B2GivenInlierRate(N,NG);
        % given the margins, generate a random permutation with NG number
        % of inliers
        [p, gtInlierVec] = generateRandomPermutationWithA1A2B1B2(N, NG, OVec(1), OVec(2), OVec(3), OVec(4));
        inlierRateGT(i) = NG/N;
        OGT(:,i) = OVec;
        
        % computation of Kendall inlier rate in simoultaneous optimization of the windows
        tic;
        [kendallPyramidInlierRate, startNum1, endNum1, startNum2, endNum2] = estimateKendallInlierRateJointlyWindows(p,resolution);
        tKendallPyramid = toc;
        inlierRateKendallPyramidVec(i) = kendallPyramidInlierRate;
        timeKendallPyramidVec(i) = tKendallPyramid;
        OKendallPyramid(:,i) = [startNum1 ; endNum1 ; startNum2 ; endNum2];

        % computation of Kendall inlier rate with separate optimization of the windows
        [val, p2] = sort(p);
        tic;
        [kendallPyramidInlierRateOneDim, startNum1, endNum1, startNum2, endNum2] = estimateKendallInlierRateSeparateWindows(p2,p,resolution);
        tKendallPyramidOneDim = toc;
        inlierRateKendallPyramidOneDimVec(i) = kendallPyramidInlierRateOneDim;
        timeKendallPyramidOneDimVec(i) = tKendallPyramidOneDim;
        OKendallPyramidOneDim(:,i) = [startNum1 ; endNum1 ; startNum2 ; endNum2];
        
        % computation of Kendall inlier rate without windows computation
        tic;
        kendallInlierRate = estimateKendallInlierRate(p);
        if (kendallInlierRate > 1)
            kendallInlierRate = 1;
        end
        if (kendallInlierRate < 0)
            kendallInlierRate = 0;
        end
        tKendall = toc;
        inlierRateKendallVec(i) = kendallInlierRate;
        timeKendallVec(i) = tKendall; 
        
        % computation of Kendall inlier rate based on ground truth windows
        tic;
        kendallGtInlierRate = estimateKendallGivenO1O2(p, [OVec(3) OVec(4)],[OVec(1) OVec(2)]);
        kendallGtTime = toc;
        inlierRateKendallGTVec(i) = kendallGtInlierRate;
        timeKendallGTVec(i) = kendallGtTime;
        
        
    end
    
    methodNamesCellArr = {'K', 'K2D', 'K1D', 'KGT'};
    inlierRateCellArr1={inlierRateKendallVec, inlierRateKendallPyramidVec, inlierRateKendallPyramidOneDimVec, inlierRateKendallGTVec};
    inlierRateCellArr2 = {inlierRateGT, inlierRateGT, inlierRateGT, inlierRateGT};
    plotScatterGraphForMultipleMethods(inlierRateCellArr1, inlierRateCellArr2, 'Ours (N_G/N)', 'GT (N_G/N)', methodNamesCellArr);
    
    KError = inlierError(inlierRateGT, inlierRateKendallVec);
    K2DError = inlierError(inlierRateGT, inlierRateKendallPyramidVec);
    K1DError = inlierError(inlierRateGT, inlierRateKendallPyramidOneDimVec);
    KGTError = inlierError(inlierRateGT, inlierRateKendallGTVec);
    
    [measure1Pyramid, measure2Pyramid] = overlapError(OGT, OKendallPyramid);
    measurePyramid = mean([measure1Pyramid measure2Pyramid]);
    [measure1PyramidOneDim, measure2PyramidOneDim] = overlapError(OGT, OKendallPyramidOneDim);
    measurePyramidOneDim = mean([measure1PyramidOneDim measure2PyramidOneDim]);
    
    meanTimeKendallPyramid = mean(timeKendallPyramidVec);
    meanTimeKendallPyramidOneDim = mean(timeKendallPyramidOneDimVec);
    meanTimeKendall = mean(timeKendallVec);
    meanTimeKendallGTOneDim = mean(timeKendallGTVec);
    
    
end
