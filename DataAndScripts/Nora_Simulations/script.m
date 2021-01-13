function script

    
    bins = dlmread('DD_symcap_neutron_bins.txt', ' ', 1, 0);
    dE = diff(bins);
    nodes = (bins(1:end-1) + bins(2:end)) / 2;

    data = dlmread('DD_symcap_neutron_tally_npole.txt', ' ', 1, 0);
    data = data(:, 2:end-1);

    N_runs   = size(data,1);
    N_nodes  = size(data,2);
    
    DD_index = logical( (nodes >= 2.2) .* (nodes <= 3.0));
    DT_index = logical( (nodes >= 11.0) .* (nodes <= 18.0));
    
    close all
    figure; 
    for i = (3:5:25) + 100
        
        f = fit(nodes(DD_index), data(i,DD_index)', 'gauss1');
        
        
        hold on; box on;
        title(sprintf('Run %d', i));
        plot(nodes, smooth(data(i,:), 50), 'LineWidth', 2)
        %plot(nodes, f(nodes) , '--r')
        set(gca, 'YScale', 'lin')
        xlim([11 18]);
        ylim([0 7e8]);
        
        title('Polar NTOF')
        ylabel('Neutrons per Bin')
        xlabel('Energy (MeV)')
        
        Y_DD = sum(data(i,DD_index));
        Y_DT = sum(data(i,DT_index));
        Tion = (1000 * f.c1)^2 / 1226.25 / 2;
        
        fprintf('%d %.4e %.4e %.4e\n', i, Y_DD, Y_DT, Tion)
        
    end
    

    %% IMAGE FIT STUFF
    legendreModes = [0:8];

    data = dlmread('DD_symcap_gxd_eq.txt', ' ', 1, 0);
    data = data(:, 2:end-1);

    N_runs   = size(data,1);
    N_pixels = sqrt(size(data,2));
    
    x = linspace(-200.0, 200.0, N_pixels);
    y = linspace(-200.0, 200.0, N_pixels);

    images = zeros(N_runs, N_pixels, N_pixels);
    
    close all
    for i = 1
        
       images(i,:,:) = reshape(data(i,:), N_pixels, N_pixels);
       thisImage = reshape(images(i,:,:), N_pixels, N_pixels);
       
       % Get the contour points
       points = contourc(x, y, thisImage./max(max(thisImage)), [0.17 0.17]);
       points = points(:, points(1,:) ~= 0.17);
       
       midY = 0.0;
       %midY = mean(points(2,:));
       %points(2,:) = points(2,:) - midY;       % Shift points
       
       [theta, r] = cart2pol(points(1,:), points(2,:));
       theta = pi/2 - theta;
       
       
       A = zeros(length(r), length(legendreModes));       
       for j = 1:length(legendreModes)           
           A(:,j) = legendreP(legendreModes(j), cos(theta));
       end
       
       cFit = A \ r';
       
       disp([i; cFit]');
       
       
       figure; hold on;
       title(sprintf('GXD Equator Image %d', i));
       image(x, y-midY, 256*thisImage./max(max(thisImage)));
       xlim([x(1) x(end)]);
       ylim([y(1) y(end)]);
       colormap jet;
       
       %scatter(points(1,:), points(2,:), 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'r');
       
       %[xFit, yFit] = legendreFunction(legendreModes, cFit);
       %plot(xFit, yFit, 'w', 'LineWidth', 2)
       
       
       
       
       
    end
    %}
    
end
