function H = getHomographyMatrixForInplaneRotAndTrans(img1Points, img2Points)
    A = [];
    b = [];
    
    for index = 1: size(img1Points, 1)
       x1 = img1Points(index, 1);
       y1 = img1Points(index, 2);
       x2 = img2Points(index, 1);
       y2 = img2Points(index, 2);
       A = [A; x1, -y1, 1, 0];
       A = [A; y1, x1, 0, 1];
       b = [b; x2];
       b = [b; y2];
    end
    
    solution = pinv(A) * b;
    h0 = solution(1); h1 = solution(2); h2 = solution(3); h3 = solution(4);
    H = [h0, -h1, h2; h1, h0, h3; 0, 0, 1.0]
end
