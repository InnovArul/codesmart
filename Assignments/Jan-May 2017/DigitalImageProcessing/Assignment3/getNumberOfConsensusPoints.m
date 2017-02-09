function count = getNumberOfConsensusPoints(H, remainingPoints)

img1Points = remainingPoints{1};
img2Points = remainingPoints{2};
count = 0;

totalPoints = size(img1Points, 1);

for index = 1:totalPoints
   projectedPoint = H * [img1Points(index, :)'; 1]; 
   x = projectedPoint(1) / projectedPoint(3);
   y = projectedPoint(2) / projectedPoint(3);
   
   if(sum(([x y] - img2Points(index, :)).^2) < 10)
       count = count + 1;
   end
end

end