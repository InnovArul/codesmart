function [ output_args ] = doall( input_args )
%DOALL Summary of this function goes here
%   Detailed explanation goes here

WsimArray = [3 3];
WsearchArray = [5 10];
sigmaArray = 0.1:0.1:1

%Read the noisy image g and the latent image f in the intensity range [0; 1].
outputFolder = './output/';
noisyImagePath = './Lab12/krishna_noise.png';
latentImagePath = './Lab12/krishna_latent.png';
unpaddedNoisyImg = im2double(imread(noisyImagePath));
latentImg = im2double(imread(latentImagePath));

imgWidth = size(unpaddedNoisyImg, 1);
imgHeight = size(unpaddedNoisyImg, 2);

totalVariationInW = length(WsimArray);
filteringMethod = 'NLM'; % 'gaussian' , 'NLM'

if(strcmp(filteringMethod, 'gaussian') == 1)
    for sigmaIndex = 1:10
        sigma = sigmaArray(sigmaIndex);
        
        % Create the gaussian filter with hsize = [5 5] and sigma = 2
        G = fspecial('gaussian', [11 11], sigma);
        
        %# Filter it
        filteredImg = imfilter(unpaddedNoisyImg, G, 'same');  
        
        PSNRs(sigmaIndex) = getPSNR(filteredImg, latentImg);
    end
    
    % load the plot from NLM
    PSNRnlm = load('PSNRs.mat');
    PSNRnlm = PSNRnlm.PSNRs;
    figure;
    plot(PSNRnlm(:, 1), '-or', 'Linewidth', 2);
    hold on;
    plot(PSNRnlm(:, 2), '-*g', 'Linewidth', 2);
    hold on;
    plot(PSNRs, '-db', 'Linewidth', 2);
    xlabel('sigma')
    ylabel('PSNR')
    title('PSNR vs. Sigma')
    legend({'Wsim = 3, Wsearch = 5', 'Wsim = 3, Wsearch = 10', 'Gaussian filter'})
else
    for wIndex = 1 : totalVariationInW
        Wsim = WsimArray(wIndex);
        Wsearch = WsearchArray(wIndex);

        for sigmaIndex = 1:10
            sigmaNLM = sigmaArray(sigmaIndex);

            % pad the noisy image
            noisyImg = padarray(unpaddedNoisyImg, [Wsim + Wsearch, Wsim + Wsearch]);
            filteredImg = zeros(size(latentImg));

            %for every pixel position p do
            for i = 1 : imgWidth
                disp(i)
                tic
                for j = 1 : imgHeight
                    currentI = i + (Wsim + Wsearch);
                    currentJ = j + (Wsim + Wsearch);
                    
                    [~, ~, ~, filteredImg(i, j, :)] = getNLMFilteredPixel(noisyImg, currentI, currentJ, Wsim, Wsearch, sigmaNLM);
                    
                end
                toc
            end

            % Calculate the PSNR
            % MSE : Mean Squared Error
            % PSNR : Peak Signal-to-Noise Ratio
            % The operation here assumes f and b f are column vectors.
            imwrite(filteredImg, fullfile(outputFolder, strcat('Wsim-', num2str(Wsim), ...
                                                                '-Wsearch-', num2str(Wsearch), '-sigmaNLM-', num2str(sigmaNLM), '.png')));
            PSNRs(sigmaIndex, wIndex) = getPSNR(filteredImg, LatentImg);
        end
    end 
end

end

