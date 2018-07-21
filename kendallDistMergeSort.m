
function [x, dist] = kendallDistMergeSort(x)
kk = 15;
% Mergesort
n = length(x);
dist = 0;
[x,dist] = mergesorti(x,1,n,kk,dist);
end


