
function inlierRate = estimateKendallGivenO1O2(secondSeq,O1,O2)

    N = length(secondSeq);
    seq = transformSequenceToFullyOverlapped(secondSeq, O1, O2);
    inlierRate = (estimateKendallInlierRate(seq)*length(seq))/N;

end









