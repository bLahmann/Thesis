function plotTally

    %close all;
    M = 12;
    
    figure; hold on
    data = dlmread('temp.dat');
    x = 10000 * data(2:end, 1) ./ M;
    y = 10000 * data(1, 2:end) ./ M;
    data = data(2:end, 2:end);
    
    image(x, y, 64*data./max(max(data)))
    %contour(x, y, data ./ max(max(data)), 'LevelList', [0.17], ...
    %    'Color', 'w')
    view([0, 90])
    colormap jet;
    
    %% Legendre Fit
    
    cFit = fminsearchbnd(@(c) getLegendreGoodness(x, y, data, c, 0.17), ...
        [100.0  0.0 ], ...
        [0.0   -1.0 ], ...
        [200.0  1.0 ])
    
    [xFit, yFit] = legendreFunction(cFit);
    plot(xFit, yFit, 'w', 'LineWidth', 3)
    
    function [xFit, yFit] = legendreFunction(c)
        
        theta = linspace(0, 2*pi, 1000);
        r  = c(1);
        
        for i = 2:length(c)
            
            l = 2*i - 2;
            r = r - c(i) * c(1) * sqrt((2*l+1)/(4*pi)) * ...
                legendreP(l, cos(theta));
            
        end
        
        xFit = r .* cos(theta);
        yFit = r .* sin(theta);
        
    end

    function goodness = getLegendreGoodness(x, y, v, c, contour)
        
        % Normalize v
        v = v ./ max(max(v));
        
        % Get the query points
        [xq, yq] = legendreFunction(c);
        
        % Interp
        vq = interp2(x, y, v, xq, yq);
        
        goodness = sum((vq - contour).^2);
        
    end

end