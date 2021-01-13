function goodness = getLegendreGoodness(x, y, v, c, contour)

    % Normalize v
    v = v ./ max(max(v));

    % Get the query points
    [xq, yq] = legendreFunction(c);

    % Interp
    vq = interp2(x, y, v, xq, yq);

    goodness = sum((vq - contour).^2);

end