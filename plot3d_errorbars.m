function [h]=plot3d_errorbars(z, e)
% this matlab function plots 3d data using the plot3 function
% it adds vertical errorbars to each point symmetric around z
% I experimented a little with creating the standard horizontal hash
% tops the error bars in a 2d plot, but it creates a mess when you 
% rotate the plot
%
% x = xaxis, y = yaxis, z = zaxis, e = error value

% create the standard 3d scatterplot
% hold off;

% looks better with large points

hold on;

% now draw the vertical errorbar for each point
for i=1:size(z,1)
    for j = 1 : size(z,2)    
        fprintf('i %d, j %d\n', i, j);
        plot3(i,j, z(i,j), '.r', 'MarkerSize', 20);
%         set(h, 'MarkerSize', 25);
        
        xV = [i; i];
        yV = [j; j];
        zMin = z(i,j) + e(i,j);
        zMax = z(i,j) - e(i,j);

        zV = [zMin, zMax];
        % draw vertical error bar
        h=plot3(xV, yV, zV, '-g');
        set(h, 'LineWidth', 2);
     end
end