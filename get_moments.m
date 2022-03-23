function m = get_moments(data, b)

y = data(:, 1);
x = data(:, 2);

m = x .* (y - b * x);

end
