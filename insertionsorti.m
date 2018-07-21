
function [x,dist] = insertionsorti(x,ll,uu,dist)
% Sort x(ll:uu) via insertion sort 

for j = (ll + 1):uu
    pivot = x(j);
    i = j;
    while ((i > ll) && (x(i - 1) > pivot))
        x(i) = x(i - 1);
        i = i - 1;
        dist = dist + 1;
    end
    x(i) = pivot;
end

end