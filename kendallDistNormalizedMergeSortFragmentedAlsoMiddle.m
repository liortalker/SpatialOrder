%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Calculate Kendall distance for fragments of windows
%   
%   Input:
%   seq - the sequence of feature indexes, e.g., the indexes of the matches
%   from the first image when the features in the second image are sorted
%   by X axis and indexed as 1:N. ([firstSeq]->1:N)
%   timesVec - a vector of resolutions, e.g., [(1:(round(resolution*N)):N)
%   N] where resolution = 0.1 and N = 1000 for example. 
%
%   Output:
%   kendallDistMat - an upper triangle matrix with kendall distance for the
%   appropriate windows
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function kendallDistMat = kendallDistNormalizedMergeSortFragmentedAlsoMiddle(seq, timesVec, restrictWindowSize)

    timesKendall = length(timesVec);
    kendallDistVec = zeros(1,timesKendall-1);
    sortedListCellArr = cell(1,timesKendall-1);
    projDistMat = cell(1,timesKendall-1);
    projKendallDistVec = zeros(1,timesKendall-1);
    kendallDistMat = zeros(timesKendall-1,timesKendall-1);
    
    % calculate kendall distance for every small fraction of window -
    % for example (O is for the window an X for outside the window) -
    % [OOOOOXXXXXXXXXXXXXXXXXXXXX] is one window and
    % [XXXXXXXXXXXXXXXXOOOOOXXXXX] is another
    for i = 1:(timesKendall-1)
        [curSortedList, curDist] = kendallDistMergeSort(seq(timesVec(i):(timesVec(i+1)-1)));
        kendallDistVec(i) = curDist;
        sortedListCellArr{i} = curSortedList;
        projKendallDistVec(i) = curDist;
        projDistMat{i} = curSortedList;
    end
    
    % using the small fractions of windows, calculate all the possible
    % windows
    % for example, calculate [OOOOOOOOOOXXXXXXXXXXXXXXXX] from
    % [OOOOOXXXXXXXXXXXXXXXXXXXXX] and [XXXXXOOOOOXXXXXXXXXXXXXXXX]
    for i = 1:(timesKendall-1)
        curLengthLeft = length(sortedListCellArr{i});
        if (restrictWindowSize)
            if (curLengthLeft > 1)
                kendallDistMat(i,i) = kendallDistVec(i)/((curLengthLeft)*(curLengthLeft-1)/2);
            end
        else
            kendallDistMat(i,i) = kendallDistVec(i)/((curLengthLeft)*(curLengthLeft-1)/2);
        end
        for j = (i+1):(timesKendall-1)
            projDistMat{i} = [projDistMat{i} sortedListCellArr{j}];
            curAllLengthLeft = length(projDistMat{i});
            curLengthLeft = length(sortedListCellArr{j});
            projKendallDistVec(i) = projKendallDistVec(i) + kendallDistVec(j);
            [curListLeft,curDistLeft] = merge(projDistMat{i},1,curAllLengthLeft-curLengthLeft,curAllLengthLeft,projKendallDistVec(i));
            projDistMat{i} = curListLeft;
            projKendallDistVec(i) = curDistLeft;
            kendallDistMat(i,j) = curDistLeft/((curAllLengthLeft)*(curAllLengthLeft-1)/2);
            
        end
    end
   
    
end




