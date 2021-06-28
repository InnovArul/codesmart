function [Wp, searchNeighborhood, replicatedFilter, pixelValue] = getNLMFilteredPixel(noisyImg, currentI, currentJ, Wsim, Wsearch, sigmaNLM)

% Obtain similarity neighbourhood around p
% Take the RGB patch Np around p of radius Wsim in the image g
% Vectorize the patch Np as a column vector Vp
patchNeighborhood = getNeighborhood(noisyImg, Wsim, currentI, currentJ);

% Form the filter wp at pixel p.
% It can be formed as a 1D vector and visualized as a 2D matrix.
% We form a single filter for all three colour components.
Wp = zeros(2*Wsearch + 1);

for searchI = -Wsearch : Wsearch
    for searchJ = -Wsearch : Wsearch
        % Obtain similarity neighbourhood around q
        % Take the RGB patch Nq around q of radius Wsim in the image g
        % Vectorize the patch Nq as a column vector Vq
        currentSearchNeighborhood = getNeighborhood(noisyImg, Wsim, currentI + searchI, currentJ + searchJ);
        patchDifference = patchNeighborhood - currentSearchNeighborhood;
        patchDifferenceSquare = sum((patchDifference(:)).^ 2);

        Wp(searchI + Wsearch + 1, searchJ + Wsearch + 1) = ...
                exp(-patchDifferenceSquare/(sigmaNLM^2));
    end
end

%Normalize w
sumWp = sum(Wp(:));
Wp = Wp ./ sumWp;

% Obtain search neighbourhood patch around p
% Take the RGB patches Np W(R), Np W(G), Np W(B) around p of radius W in
% the image g separately
searchNeighborhood = getNeighborhood(noisyImg, Wsearch, currentI, currentJ);

% Vectorize them as column vectors VW
% Vp W(R), Vp W(G), Vp W(B)
% Calculate the filtered output at pixel p
replicatedFilter = repmat(Wp, 1, 1, 3);

pixelValue = sum(sum(double(searchNeighborhood) .* replicatedFilter, 1), 2);;

end
