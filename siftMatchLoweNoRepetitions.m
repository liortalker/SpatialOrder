
function [matches, closestRatio] = siftMatchLoweNoRepetitions(des1, des2, distRatio)

    des1 = double(des1);
    des2 = double(des2);
    des1 = des1./repmat(sqrt(sum(des1.^2,2)),[1,128]);
    des2 = des2./repmat(sqrt(sum(des2.^2,2)),[1,128]);
    % For each descriptor in the first image, select its match to second image.
    % des2t = des2';  % Precompute matrix transpose
    closestRatio = zeros(1,size(des1,1));
    match = zeros(1,size(des1,1));
    for i = 1 : size(des1,1)
       dotprods = des1(i,:) * des2';        % Computes vector of dot products
       [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

       % Check if nearest neighbor has angle less than distRatio times 2nd.
       closestRatio(i) = vals(1)/vals(2);
       if (vals(1)*distRatio <  vals(2))
          match(i) = indx(1);
       end
    end
    
    
    a = find(match);
    b = match(find(match));
    [C,ia,ic] = unique(b);
    matches = [a(sort(ia)) ; b(sort(ia))];
    closestRatio = closestRatio(a(sort(ia)));

end