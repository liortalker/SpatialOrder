
function [x,dist] = mergesorti(x,ll,uu,kk,dist)
% Sort x(ll:uu) via merge sort 

% Compute center index
mm = floor((ll + uu) / 2);

% Divide...
if ((mm + 1 - ll) <= kk)
    % Sort x(ll:mm) via insertion sort
    [x,dist] = insertionsorti(x,ll,mm,dist);
else
    % Sort x(ll:mm) via insertion sort
    [x,dist] = mergesorti(x,ll,mm,kk,dist);
end
if ((uu - mm) <= kk)
    % Sort x((mm + 1):uu) via insertion sort
    [x,dist] = insertionsorti(x,mm + 1,uu,dist);
else
    % Sort x((mm + 1):uu) via merge sort
    [x,dist] = mergesorti(x,mm + 1,uu,kk,dist);
end

% ... and conquer
% Combine sorted arrays x(ll:mm) and x((mm + 1):uu)
[x,dist] = merge(x,ll,mm,uu,dist);

end