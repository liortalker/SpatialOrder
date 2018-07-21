

function [p, gtInlierVec] = generateRandomPermutationWithA1A2B1B2(N, NG, A1, A2, B1, B2)

    p = randperm(N);
    p2 = randperm(N);
    % inliers are spaced all over p
    p2WithoutA = p2(p2 >= B1 & p2 <= B2);
    p2WithoutA = p2WithoutA(p(p2WithoutA) >= A1 & p(p2WithoutA) <= A2);
    gtInlierVec = sort(p2WithoutA(1:NG));
    % inserting the inliers to p by sorting them
    p(gtInlierVec) = sort(p(gtInlierVec));    
    
end


