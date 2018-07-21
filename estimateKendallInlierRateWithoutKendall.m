%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Inlier rate estimation for fully overlapped sequence 
%   (without calculating the Kendall distance, which is given). For more info see
%   the paper "Using Spatial Order to Boost the Elimination of Incorrect
%   Feature Matches" by Lior Talker, Yael Moses and Ilan Shimshoni,
%   published at CVPR 2016.
%
%   Input:
%   KN - the Kendall distance
%   N - the number of matches
%
%   Output:
%   inlierRate - domain: [0,1], the estimated fraction of inliers in the
%   matches
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inlierRate = estimateKendallInlierRateWithoutKendall(KN,N)

    KI = 0;
    KO = 1/2;
    KIO = (1/3);
    pVec = [(KI+KO-2*KIO) (-KI-KO*(2*N-1)+2*N*KIO) (N*(N-1)*(KO-KN))];
    r = roots(pVec);
    if (~isempty(r))
        rMax = max(r);
        if (rMax < 0)
            rMax = 0;
        end
        inlierRate = rMax./N;
    else
        inlierRate = 0;
    end

end



