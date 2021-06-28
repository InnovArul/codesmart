function [  ] = doallVIDEO(  )
%DOALLVIDEO Summary of this function goes here
%   Detailed explanation goes here

classes = {'data/handclapping_vids', 'data/running_vids', 'data/walking_vids'};
numClasses = size(classes, 2);

for classIndex = 1:numClasses
    filenames = getAllFiles(classes{classIndex});
    
    for fileIndex = 1:size(filenames, 1)
        filename = filenames{fileIndex};

        readerobj = VideoReader(filename);

        % Read in all video frames.
        vidFrames = read(readerobj);

        % Get the number of frames.
        numFrames = get(readerobj, 'NumberOfFrames');

        %imshow(img);
        totalPairs = uint16(numFrames/6);

        %size(vidFrames)
        [directory, file, ext] = fileparts(filename);
        resutlFileName = strcat(directory(1:length(directory)-5), '/', file, ext, '.txt');
        dataset = [];

        %extract affine flows for each pair sequences of images in the
        %video
       
        for index = 1:totalPairs
            firstFrame = (index-1) * 6 + 1;
            secondFrame = (index-1) * 6 + 2;
            
            if(firstFrame <= numFrames && secondFrame <= numFrames)
                im1 = vidFrames(:, :, :, firstFrame);  im1 = im2double(rgb2gray(im1));
                im2 = vidFrames(:, :, :, secondFrame); im2 = im2double(rgb2gray(im2));
       
                af = affine_flow('image1', im1, 'image2', im2, ...
                    'sampleMethod', 'logpolar', 'sigmaXY', 10, 'sampleStep', 10);

                %find the optical flow
                af = af.findFlow;
                flow = af.flowStruct;
                
                affine_flowedgedisplay(flow, im1, im2);
                pause;

                %get all the fields from struct and fill the dataset array
                dataset(index, :) = getAllValsFromStruct(flow);

            end

        end
        
        % write the data into file
        fileID = fopen(resutlFileName, 'w');
        for row = 1:size(dataset, 1)
            fprintf(fileID, '%f ', dataset(row, :));
            fprintf(fileID, '\n');
        end
        fclose(fileID);
    end
end

disp('data processing completed');

end

