function stats = get_stats(theta, parT)

bias = mean(theta, 2) - parT;
sdev = sqrt(var(theta, 0, 2));
rmse = sqrt(bias .^ 2 + sdev .^ 2);
perc = prctile(theta, [10, 25, 50, 75, 90], 2);

stats = [bias, sdev, rmse, perc];

end
