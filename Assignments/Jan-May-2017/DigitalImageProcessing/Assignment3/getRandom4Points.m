function [corresp, remainingPoints] = getRandom4Points(corresp1, corresp2)

randomcorresp1 = [];
randomcorresp2 = [];
remainingPoints1 = [];
remainingPoints2 = [];

totalPoints = size(corresp1, 1);
randomIndices = randperm(totalPoints);
randomIndices = randomIndices(1:4);

% select 4 random points
for index = 1:totalPoints
    if(find(randomIndices == index))
        randomcorresp1 = [randomcorresp1; corresp1(index, :)];
        randomcorresp2 = [randomcorresp2; corresp2(index, :)];
    else
        remainingPoints1 = [remainingPoints1; corresp1(index, :)];
        remainingPoints2 = [remainingPoints2; corresp2(index, :)];
    end
end

corresp = {randomcorresp1, randomcorresp2};
remainingPoints = {remainingPoints1, remainingPoints2};
end