
function [x,dist] = merge(x,ll,mm,uu,dist)
% Combine sorted arrays x(ll:mm) and x((mm + 1):uu)

L = x(ll:mm);

% Combine sorted arrays
i = 1;
j = mm + 1;
k = ll;
while ((k < j) && (j <= uu))
    if (L(i) <= x(j))
        x(k) = L(i);
        i = i + 1;
    else
        x(k) = x(j);
        j = j + 1;
        dist = dist + (mm-ll-i+2);
    end
    k = k + 1;
end

x(k:(j - 1)) = L(i:(i + j - k - 1));

end
