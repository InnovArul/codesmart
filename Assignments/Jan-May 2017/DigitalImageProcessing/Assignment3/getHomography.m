function H = getHomography(corresp)

sourcePoints = corresp{1};
targetPoints = corresp{2};
A = [];

totalPoints = size(sourcePoints, 1);

for index = 1:totalPoints
    x1 = sourcePoints(index, 1);
    y1 = sourcePoints(index, 2);
    x2 = targetPoints(index, 1);
    y2 = targetPoints(index, 2);
    A = [A; [x1, y1, 1, 0, 0, 0, -x2 * x1, -x2 * y1, -x2]];
    A = [A; [0, 0, 0, x1, y1, 1, -y2 * x1, -y2 * y1, -y2]];
end

[U, W, V] = svd(A);
H = reshape(V(:, 9), 3, 3)';

end