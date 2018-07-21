
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Transform the sequence to fully overlapped by removing features out of
%   the windows o1 and o2
%
%   Input:
%   seq - a sequence of feature indexes based on the matches
%   , e.g., the indexes of the matches from the second image when the
%   features in the first image are sorted by X axis and indexed
%   as 1:N. (1:N->[secondSeq]) 
%   
%   o1, o2 - domain NxN (pair of indexes - a window). The windows of
%   overlap, e.g., o1=[100, 300] when number of matches, N=500.
%
%   Output:
%   seq - the resulting fully overlapped sequence
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function seq = transformSequenceToFullyOverlapped(seq, o1, o2)

    seq = seq(o1(1):o1(2));
    seq = seq(seq >= o2(1) & seq <= o2(2));   
    uniqueVals = unique(seq);
    seq = changem(seq,1:length(seq),uniqueVals);

end



