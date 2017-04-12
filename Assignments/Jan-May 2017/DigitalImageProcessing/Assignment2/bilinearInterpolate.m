function [value, isValid] = bilinearInterpolate(img, x, y)
    % get the dimension of the image
    [height, width] = size(img);
    value = 0;
    
    if(x < 1 || x > height) isValid = 0; return; end
    if(y < 1 || y > width) isValid = 0; return; end
    isValid = 1; 

    modX = mod(x, 1);
    modY = mod(y, 1);

    if((modX == 0) && (modY == 0))
        value = img(x, y);
    else
        % bilinear interpolation
        % find four corners
        topLeft = img(floor(x), floor(y));
        topRight = img(floor(x), ceil(y));
        bottomLeft = img(ceil(x), floor(y));
        bottomRight = img(ceil(x), ceil(y));

        value = ((1 - modX) * (1 - modY) * topLeft) + ...
                ((1 - modX) * modY * topRight) + ...
                (modX * (1 - modY) * bottomLeft) + ...
                (modX * modY * bottomRight);
    end
end