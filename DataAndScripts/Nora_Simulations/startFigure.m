close all;

figure('Position', [100 100 1200 500])
box on; hold on;

for i = 1:4
    plot((25*i+0.5)*[1 1], 1e14*[-1 1], '-k', 'LineWidth', 2)
end

for i = 1:24
    plot((5*i+0.5)*[1 1], 1e14*[-1 1], '--k')    
end

xlim([0 126])
set(gca, 'XTick', [], 'FontSize', 12)