function newimg = getHomographedSourceImage(img, H, dimensions)
    height = dimensions(1);
    width = dimensions(2);
    
    newimg = zeros(height, width);
    
    Hinv = pinv(H);
    
    for i = 1 : height
        for j = 1 : width
            iSourceCoord = Hinv * [j; i; 1];
            iSourceX = (iSourceCoord(1) / iSourceCoord(3));
            iSourceY = (iSourceCoord(2) / iSourceCoord(3));      
            
            % if the resultant coordinates are float, then get bilinear interpolate the pixels
            % bilinearInterpolate considers 2nd input as along height and 3rd input as along width
            newimg(i, j) = bilinearInterpolate(img, iSourceY, iSourceX);            
        end
    end
end