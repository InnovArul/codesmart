function shapeFromFocus()
    addpath('./exportFig/');
    % load the stacked images
    stackData = load('./Lab5/stack.mat');

    % for all the 100 images, do the Sum Modified Laplacian (SML)
    SMLfilterOutputs = {};
    stackedFrames = zeros([115, 115, 100]);
    for i = 1 : 100
        frameName = strcat('frame', sprintf('%03d', i));
        frame = double(getfield(stackData, frameName));
        stackedFrames(:, :, i) = frame;
        SMLfilterOutputs{i} = getSMLOperatorOutputOnAxes(frame);
    end
    
    % for each neighborhood of [0, 1, 2], get the SML output
    neighborhood = [0, 1, 2, 3, 4, 5];
    for i = neighborhood
        % buffer to hold SML output based on neighborhood
        SMLOutput = zeros([size(frame), 100]);
        for frameIndex = 1 : 100
            SMLOutput(:, :, frameIndex) = getSMLOperatorOutputWithNeighborhood(SMLfilterOutputs{frameIndex}, i);
        end
        
        % determine where the maximum values occur along the stack of images
        [maxValues, indices] = max(SMLOutput, [], 3);        
        
        % get the image
        gaussIndices = doGaussianEstimation(SMLOutput, indices);
        img = getImageFromFrameNumbers(stackedFrames, indices);  
        
        % write the image
        imwrite(img, strcat('./output/image-N=', int2str(i), '.png'));
        
        % save the surf plot
        surf(gaussIndices * 50.5);
        set(gca,'Visible','off')
        export_fig(strcat('./output/surf-N=', int2str(i), '.fig'));
        close all;
    end
    

end