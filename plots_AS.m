tab = [];
ratio = 1;

for i =1:ntot
    tab = [tab; output{i}];
end

tab = [tab, kron(ones(ntot, 1), (1:7)')];

% Statistics for each estimator
gmm1 = [tab(tab(:, end) == 1, :), grid];
gmm2 = [tab(tab(:, end) == 2, :), grid];
gmmI = [tab(tab(:, end) == 3, :), grid];
gmmC = [tab(tab(:, end) == 4, :), grid];
smm1 = [tab(tab(:, end) == 5, :), grid];
smm2 = [tab(tab(:, end) == 6, :), grid];
amm1 = [tab(tab(:, end) == 7, :), grid];

plot_config

cmap = [249,65,68; 
            243,114,44;
            248,150,30;
            249,132,74;
            249,199,79;
            144,190,109;
            67,170,139; 
            77,144,142; 
            87,117,144; 
            39,125,161] / 255;

%--------------------------------------------------------------------------

fullfig

for d = 1:nD
    for n = 1:nN

        subplot(nN, nD, nD * (n-1) + d)

        hold on

        plot(T, gmm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 1), 'Color', cmap(1, :));
        plot(T, gmm2(grid(:, 1) == N(n) & grid(:, 3) == D(d), 1), '--', 'Color', cmap(2, :));
        plot(T, gmmC(grid(:, 1) == N(n) & grid(:, 3) == D(d), 1), ':', 'Color', cmap(3, :));
        plot(T, smm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 1), 'Color', cmap(5, :));
        plot(T, smm2(grid(:, 1) == N(n) & grid(:, 3) == D(d), 1), '--', 'Color', cmap(6, :));
        plot(T, amm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 1), 'Color', cmap(10, :));
        yline(0, '--k');
        
        if d == 3
            ylim([-.6, .05])
        else
            ylim([-.15, .05])
        end

plot_config

for g = 1:4
    subplot(2, 2, g)
    plot(par, squeeze(perc(g, :, :)))
    ylabel('Loss')
    xlabel('$\beta$')
    title(strcat('Noise dispersion $\sigma = ', num2str(sigma(g)), '$'))
    legend('p10', 'p25', 'p50', 'p75', 'p90')
end        
        hold off

    end
end

sgtitle('Bias for different estimators', 'FontSize', 24)
legend('GMM', 'GMM--2', 'GMM--CU', 'SMM', 'SMM--2', 'AMM')
saveas(gcf, strcat(respath, 'bias_as'), 'epsc')

%--------------------------------------------------------------------------

fullfig

for d = 1:nD
    for n = 1:nN

        subplot(nN, nD, nD * (n-1) + d)
        
        hold on

        plot(T, gmm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 2), 'Color', cmap(1, :));
        plot(T, gmm2(grid(:, 1) == N(n) & grid(:, 3) == D(d), 2), '--', 'Color', cmap(2, :));
        plot(T, gmmC(grid(:, 1) == N(n) & grid(:, 3) == D(d), 2), ':', 'Color', cmap(3, :));
        plot(T, smm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 2), 'Color', cmap(5, :));
        plot(T, smm2(grid(:, 1) == N(n) & grid(:, 3) == D(d), 2), '--', 'Color', cmap(6, :));
        plot(T, amm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 2), 'Color', cmap(10, :));
        yline(0, '--k');
        legend('GMM', 'GMM--2', 'GMM--CU', 'SMM', 'SMM--2', 'AMM')
        
        if d == 3
            ylim([0, .6])
        else
            ylim([0, .3])
        end

        title(strcat(names{D(d)}, ' Distribution, $N=', num2str(N(n)),'$'));
        
        hold off
        
    end
end

sgtitle('SD for different estimators', 'FontSize', 24)
saveas(gcf, strcat(respath, 'sd_as'), 'epsc')

%--------------------------------------------------------------------------

fullfig

for d = 1:nD
    for n = 1:nN

        subplot(nN, nD, nD * (n-1) + d)
        
        hold on

        plot(T, gmm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 3), 'Color', cmap(1, :));
        plot(T, gmm2(grid(:, 1) == N(n) & grid(:, 3) == D(d), 3), '--', 'Color', cmap(2, :));
        plot(T, gmmC(grid(:, 1) == N(n) & grid(:, 3) == D(d), 3), ':', 'Color', cmap(3, :));
        plot(T, smm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 3), 'Color', cmap(5, :));
        plot(T, smm2(grid(:, 1) == N(n) & grid(:, 3) == D(d), 3), '--', 'Color', cmap(6, :));
        plot(T, amm1(grid(:, 1) == N(n) & grid(:, 3) == D(d), 3), 'Color', cmap(10, :));
        yline(0, '--k');
        legend('GMM', 'GMM--2', 'GMM--CU', 'SMM', 'SMM--2', 'AMM')

        if d == 3
            ylim([0, .6])
        else
            ylim([0, .3])
        end

        title(strcat(names{D(d)}, ' Distribution, $N=', num2str(N(n)),'$'));
        
        hold off
        
    end
end

sgtitle('RMSE for different estimators', 'FontSize', 24)
saveas(gcf, strcat(respath, 'rmse_as'), 'epsc')