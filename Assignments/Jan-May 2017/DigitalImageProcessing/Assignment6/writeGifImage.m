function writeGifImage(img, filename)
    for idx = 1:size(img, 1)
        A = reshape(img(idx, :, :), size(img, 2), size(img, 3));
        if idx == 1
            imwrite(uint8(A), filename,'gif','LoopCount',Inf,'DelayTime',0.1);
        else
            imwrite(uint8(A), filename,'gif','WriteMode','append','DelayTime',0.1);
        end
    end
end