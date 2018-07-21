%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Inlier rate estimation for fully overlapped sequence. For more info see
%   the paper "Using Spatial Order to Boost the Elimination of Incorrect
%   Feature Matches" by Lior Talker, Yael Moses and Ilan Shimshoni,
%   published at CVPR 2016.
%
%   Input:
%   seq - the sequence of feature indexes, e.g., the indexes of the matches
%   from the first image when the features in the second image are sorted
%   by X axis and indexed as 1:N. ([firstSeq]->1:N)
%
%   Output:
%   inlierRate - domain: [0,1], the estimated fraction of inliers in the
%   matches
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inlierRate = estimateKendallInlierRate(seq)

    KI = 0;
    KO = 1/2;
    KIO = (1/3);
    N = length(seq);
    [x, KN] = kendallDistNormalizedMergeSort(seq);
    pVec = [(KI+KO-2*KIO) (-KI-KO*(2*N-1)+2*N*KIO) (N*(N-1)*(KO-KN))];
    r = roots(pVec);
    if (~isempty(r) && isreal(r))
        rMax = max(r);
        if (rMax < 0)
            rMax = 0;
        end
        inlierRate = rMax./N;
        if (inlierRate < 0)
            inlierRate = 0;
        end
    else
        inlierRate = 0;
    end

end



