
function [x, dist] = kendallDistNormalizedMergeSort(x)
    [x, dist] = kendallDistMergeSort(x);
    N = length(x);
    if (N > 1)
        dist = dist./(N*(N-1)/2);
    else
        dist = 0;
    end
end

