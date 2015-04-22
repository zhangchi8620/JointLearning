function drawskt_combineJoints(data)
    select = [1, 8, 4, 12, 20, 16]';
%     select = [1, 8, 6, 4, 10, 12, 18, 20, 16, 14]';
    
    X = [];
    Y = [];
    Z = [];
%     X = [X; zeros(1,100)];
%     Y = [Y; zeros(1,100)];
%     Z = [Z; zeros(1,100)];    
    X = [X; data(1,:)];
    Y = [Y; data(2,:)];
    Z = [Z; data(3,:)];
    data = data(3:end, :);
    for joint = 2 : 3:(size(select,1) -1) * 3
        x = data(joint,:);
        y = data(joint+1,:);
        z = data(joint+2,:);
        X = [X;x];
        Y = [Y;y];
        Z = [Z;z];
    end
    figure;
    grid on;        
    for s=1:size(X,2)
        S=[X(:,s) Y(:,s) Z(:,s)];
        xlim = [0 800];
        ylim = [0 800];
        zlim = [0 800];
        set(gca, 'xlim', xlim, ...
                 'ylim', ylim, ...
                 'zlim', zlim);

        h=plot3(S(1,1),S(1,2),S(1,3),'b*', 'MarkerSize', 8);hold on;
        h=plot3(S(2,1),S(2,2),S(2,3),'go', 'MarkerSize', 8);
        h=plot3(S(3,1),S(3,2),S(3,3),'k.', 'MarkerSize', 8);
        h=plot3(S(4,1),S(4,2),S(4,3),'ro', 'MarkerSize', 8);
        h=plot3(S(5,1),S(5,2),S(5,3),'b.', 'MarkerSize', 8);
        h=plot3(S(6,1),S(6,2),S(6,3),'c.', 'MarkerSize', 8);

        %rotate(h,[0 45], -180);
        set(gca,'DataAspectRatio',[1 1 1])
    %     axis([-0.5 0.1 -0.3 0 0 0.3])
        axis([-1 1 -1 1 -1 1])
    J=[ 2     3     4    5     6;
        1     1     1    1     1];
    %    for j=1:19
         for j=1:5
            c1=J(1,j);
            c2=J(2,j);
            line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)]);
        end
        pause(1/20)
        xlabel('x');
        ylabel('y');
        zlabel('z'); 
        grid on;

    end
end