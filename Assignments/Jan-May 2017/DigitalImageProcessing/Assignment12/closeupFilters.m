
%Read the noisy image g and the latent image f in the intensity range [0; 1].
global outputFolder;
outputFolder = './output/';
noisyImagePath = './Lab12/krishna_noise.png';
latentImagePath = './Lab12/krishna_latent.png';
unpaddedNoisyImg = im2double(imread(noisyImagePath));
latentImg = im2double(imread(latentImagePath));

imgWidth = size(unpaddedNoisyImg, 1);
imgHeight = size(unpaddedNoisyImg, 2);

%NLM configuration
Wsearch = 5;
Wsim = 3;
sigmaNLM = 0.5;

%gaussian configuration
gaussSigma = 1.0;

% Create the gaussian filter with hsize = [5 5] and sigma = 2
G = fspecial('gaussian', [11 11], gaussSigma);
gaussFilteredImg = imfilter(unpaddedNoisyImg, G, 'same');  

X = [63 77];
Y = [93 118];

for index = 1 : length(X)
    % do NLM filter processing
    for i = -Wsearch : Wsearch
        for j = -Wsearch : Wsearch
            currentI = X(index) + i;
            currentJ = Y(index) + j;
            [Wp, searchNeighborhood, replicatedFilter, denoisedPatch(i + Wsearch + 1, j + Wsearch + 1, :)] = ...
                getNLMFilteredPixel(unpaddedNoisyImg, currentI, currentJ, Wsim, Wsearch, sigmaNLM);
            
            if(currentI == X(index) && currentJ == Y(index))
               %save the filter
               savePatch(replicatedFilter, 'NLM', 'filter', X(index), Y(index));
               
               %save the noisy patch
               savePatch(searchNeighborhood, 'NLM', 'noisypatch', X(index), Y(index));
            end
        end
    end
   
    savePatch(denoisedPatch, 'NLM', 'denoisedpatch', X(index), Y(index));
   
   % do Gaussian filtering save
   savePatch(G, 'Gaussian', 'filter', X(index), Y(index));
   
   %get the noisy patch
   noisyPatch = getNeighborhood(unpaddedNoisyImg, Wsearch, X(index), Y(index));
   savePatch(noisyPatch, 'Gaussian', 'noisypatch', X(index), Y(index));
   
   %get the denoised patch
   denoisedPatch = getNeighborhood(gaussFilteredImg, Wsearch, X(index), Y(index));
   savePatch(denoisedPatch, 'Gaussian', 'denoisedpatch', X(index), Y(index));   
end


