function [img] = getImageFromFrameNumbers(stackedFrames, indices)
    img = zeros(size(indices));
    for i = 1 : size(indices, 1)
        for j = 1 : size(indices, 2)
            img(i, j) = stackedFrames(i, j, indices(i, j));
        end
    end
end