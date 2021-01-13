function profileScript

    radius = dlmread('DD_symcap_rad_npole.txt' , ' ', 1, 0);
    rho    = dlmread('DD_symcap_den_npole.txt' , ' ', 1, 0);
    index  = dlmread('DD_symcap_ireg_npole.txt', ' ', 1, 0);

    radius = 1e4*radius(:, 2:end-1);
    rho    = rho   (:, 2:end-1);
    index  = index (:, 2:end-1);

    N_runs   = size(rho,1);
    N_nodes  = size(rho,2);
    
    fuelIndex    = index == 1;
    iceIndex     = index == 2;
    ablatorIndex = index == 3;
    mixIndex     = index == -1;
    
    for i = 1:N_runs
       
        try 
        
            fuel  = radius(i, fuelIndex(i,:));
            shell = radius(i, iceIndex (i,:));
            fprintf('%d %.4f %.4f\n', i, fuel(1), shell(end));
        
        catch
           
            close all; 
            subplot(2,1,1); hold on; box on;
            title(['Run #' num2str(i)])
            plot(radius(i,fuelIndex(i,:)), rho(i,fuelIndex(i,:)), '-r', 'DisplayName', 'ireg == +1')
            plot(radius(i,iceIndex(i,:)), rho(i,iceIndex(i,:)), '-b', 'DisplayName', 'ireg == +2')
            plot(radius(i,ablatorIndex(i,:)), rho(i,ablatorIndex(i,:)), '-k', 'DisplayName', 'ireg == +3')
            scatter(radius(i,mixIndex(i,:)), rho(i,mixIndex(i,:)), 'k', 'DisplayName', 'ireg == -1')
            xlim([0 200])
            ylabel('Density (g/cc)')
            legend show
            
            subplot(2,1,2); hold on; box on;
            title('IREG')
            plot(radius(i,:), index(i,:), '-k')
            xlim([0 200])            
            xlabel('Radius (um)')
            
            uiwait;
            
        end
        
    end

    
end
