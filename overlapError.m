
function [outMeasure1, outMeasure2] = overlapError(gtO, oursO)

    numRuns = size(gtO,2);
    measureVec1 = zeros(1,numRuns);
    measureVec2 = zeros(1,numRuns);
    for i = 1:numRuns
        [measure1, measure2] = curOverlapError(gtO(:,i),oursO(:,i));
        measureVec1(i) = measure1;
        measureVec2(i) = measure2;
    end
    
    outMeasure1 = mean(measureVec1); outMeasure2 = mean(measureVec2);
end



function [measure1, measure2] = curOverlapError(gt,ours)

    inter1 = min(gt(2),ours(2)) - max(gt(1),ours(1));
    union1 = max(gt(2),ours(2)) - min(gt(1),ours(1));
    if (inter1 < 0)
        inter1 = 0;
    end
    
    inter2 = min(gt(4),ours(4)) - max(gt(3),ours(3));
    union2 = max(gt(4),ours(4)) - min(gt(3),ours(3));
    if (inter2 < 0)
        inter2 = 0;
    end

    measure1 = inter1/union1;
    measure2 = inter2/union2;


end



