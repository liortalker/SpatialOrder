
function [KError, K2DError, K1DError, KGTError, meanTimeKendallPyramid, meanTimeKendallPyramidOneDim, meanTimeKendall, meanTimeKendallGTOneDim] = SyntheticExp1(N,NG)

    resolution = 0.1;
    numRuns = 500;

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
        OVec = randomlySelectA1A2B1B2GivenInlierRate(N,NG);
        [p, gtInlierVec] = generateRandomPermutationWithA1A2B1B2(N, NG, OVec(1), OVec(2), OVec(3), OVec(4));
        inlierRateGT(i) = NG/N;
        OGT(:,i) = OVec;
        
        tic;
        [kendallPyramidInlierRate, startNum1, endNum1, startNum2, endNum2] = estimateKendallInlierRateJointlyWindows(p,resolution);
        tKendallPyramid = toc;
        inlierRateKendallPyramidVec(i) = kendallPyramidInlierRate;
        timeKendallPyramidVec(i) = tKendallPyramid;
        OKendallPyramid(:,i) = [startNum1 ; endNum1 ; startNum2 ; endNum2];

        [val, p2] = sort(p);
        tic;
        [kendallPyramidInlierRateOneDim, startNum1, endNum1, startNum2, endNum2] = estimateKendallInlierRateSeparateWindows(p2,p,resolution);
        tKendallPyramidOneDim = toc;
        inlierRateKendallPyramidOneDimVec(i) = kendallPyramidInlierRateOneDim;
        timeKendallPyramidOneDimVec(i) = tKendallPyramidOneDim;
        OKendallPyramidOneDim(:,i) = [startNum1 ; endNum1 ; startNum2 ; endNum2];
        
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
        
        tic;
        kendallGtInlierRate = estimateKendallGivenO1O2(p, [OVec(3) OVec(4)],[OVec(1) OVec(2)]);
        kendallGtTime = toc;
        inlierRateKendallGTVec(i) = kendallGtInlierRate;
        timeKendallGTVec(i) = kendallGtTime;
        
        
    end

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
