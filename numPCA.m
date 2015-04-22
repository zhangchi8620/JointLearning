% Compute the number of PCs
function [nbPC, percent, pc, latent] = numPCA(input, threshold)
    addpath('/Applications/MATLAB_R2014a.app/toolbox/stats/stats/');
    input = input';
    [pc,score,latent,tsquare] = princomp(input);    
    percent = cumsum(latent)./sum(latent);
    
%     figure;
%      plot(percent, 'LineWidth', 3); hold on;
%      plot(3, percent(3), 'r.', 'MarkerSize', 30);grid on;
%      xlabel('Number of components', 'fontsize', 24);
%      ylabel('Data variance', 'fontsize', 24);
    
    %[numDim,lenTime] = size(input)
    for i=1:size(percent)
        if percent(i) >= threshold
            nbPC=i;
        break;
        end
    end
%     fprintf('\tnumPC: %d,  Percentage: %f, threshold %f\n',nbPC, percent(nbPC), threshold);

%     figure;
%     labels = {'X1', 'X2', 'X3', 'X4', 'X5'};     
% %    biplot(pc(:, 1:3) .* repmat(latent(1:3)', 5,1), 'Scores', score(:,1:3), 'VarLabels', ...
% %    labels, 'LineWidth', 5, 'MarkerSize', 5);
%    biplot(pc(:, 1:3), 'Scores', score(:,1:3), 'VarLabels', ...
%    labels, 'LineWidth', 5, 'MarkerSize', 5);
end