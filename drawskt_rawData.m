%USAGE: drawskt(1,3,1,4,1,2) --- show actions 1,2,3 performed by subjects 1,2,3,4 with instances 1 and 2.
function data=drawskt_rawData(data, mode, fixTorso)
    if strcmp (mode, 'torso')
        %1,2,3,4,5,9,13,17
        J=[ 4     5     9    3     2     1     1;
            3     3     3    2     1     13    17];
    elseif strcmp (mode, 'star')
        J = [8    4     12   16   20;
             1    1     1     1   1];
    elseif strcmp (mode, 'all')
        J=[ 4     5     9     5     6    7     9     10    11     3     2     1     1     13     17    14    18    15    19;
            3     3     3     6     7    8     10    11    12     2     1     13    17    14     18    15    19    16    20]; 
    else
        error('Wrong mode name!')
    end
    
    X = data(:,:,1);
    Y = data(:,:,2);
    Z = data(:,:,3);    
    
    if fixTorso == 1
        ref = X(1,:,1);
        X = X -repmat(ref,[20,1]);

        ref = Y(1,:,1);
        Y = Y -repmat(ref,[20,1]);

        ref = Z(1,:,1);
        Z = Z -repmat(ref,[20,1]);
    end
    %% plot skeleton
    figure;

    for s=1:size(X,2)
        plot3(0,0,0, 'ko', 'MarkerSize', 20); hold on;
        S=[X(:,s) Y(:,s) Z(:,s)];
        
        xlim = [0 800];
        ylim = [0 800];
        zlim = [0 800];
        set(gca, 'xlim', xlim, ...
                 'ylim', ylim, ...
                 'zlim', zlim);

        h=plot3(S(:,1),S(:,2),S(:,3),'r.');
        %rotate(h,[0 45], -180);
        set(gca,'DataAspectRatio',[1 1 1])
        axis([-0.8 0.8 -0.8 0.8 -0.8 0.8])
        grid on;

        for j=1:size(J,2)
            c1=J(1,j);
            c2=J(2,j);
            line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)]);
        end
        pause(1/20)
        xlabel('x');
        ylabel('y');
        zlabel('z');
        hold off;
    end

end



