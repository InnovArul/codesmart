function canvas = getCombinedImages(img1, img2, img3, H21, H23)

NumCanvasRows = 700;
NumCanvasColumns = 1500;
OffsetRow = 150;
OffsetColumn = 400;

canvas = zeros(NumCanvasRows,NumCanvasColumns);
for jj = 1:NumCanvasColumns
    for ii = 1:NumCanvasRows
        i = ii - OffsetRow;
        j = jj - OffsetColumn;
        tmp = H21 * [i;j;1];
        i1 = tmp(1) / tmp(3);
        j1 = tmp(2) / tmp(3);
        tmp = H23 * [i;j;1];
        i3 = tmp(1) / tmp(3);
        j3 = tmp(2) / tmp(3);
        
        values = [];
        
        [v1, isValid] = bilinearInterpolate( img1, i1, j1);
        if (isValid) values = [values; v1]; end
        
        [v2, isValid] = bilinearInterpolate( img2, i, j);
        if (isValid) values = [values; v2]; end
        
        [v3, isValid] = bilinearInterpolate( img3, i3, j3);
        if (isValid) values = [values; v3]; end
         
        canvas(ii,jj) = mean(values); %BlendValues(v1,v2,v3);
    end
end

end