
function err = inlierError(gt, ours)

    err = mean(abs(gt - ours));
end

