function drawskt_expData()
    load('data/expData_action16.mat');
    data = expData(2:end, :);
    
%     selJoint = [1, 3, 4, 8, 5, 12, 9, 16, 13, 20, 17]';
%     refJoint = [0, 1, 3, 5, 3,  9, 3, 13,  1, 17,  1]';
%     selJoint = [1, 3, 4, 5, 8, 9, 12, 13, 16, 17, 20]';
%     refJoint = [0, 1, 3, 3, 5, 3,  9,  1, 13,  1, 17]';
%     selJoint = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]';
%     refJoint = [0, 1, 2, 2, 4, 2, 6, 1, 8,  1, 10]';
    selJoint = [1, 2, 3, 4,  5, 6]';
    refJoint = [0, 1, 1, 1,  1, 1]';

    numFrame = size(data, 2);
    numJoint = size(data, 1)/3;
    ini=zeros(10000,10000);
    tmp = ini(1:numJoint, 1:numFrame);
    X = tmp;
    Y = tmp;
    Z = tmp;
    
    for j = 1 : numJoint
        X(j,:) = data(1+(j-1)*3,:);
        Y(j,:) = data(2+(j-1)*3,:);
        Z(j,:) = data(3+(j-1)*3,:);
    end
    
    for j = 2 : numJoint
        diff = findRefJoint(refJoint(j), data);
        X(j,:) = X(j,:) + diff(1,:);
        Y(j,:) = Y(j,:) + diff(2,:);
        Z(j,:) = Z(j,:) + diff(3,:);
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
%         h=plot3(S(:,1),S(:,2),S(:,3),'r.'); hold on;
%         h=plot3(S(1,1),S(1,2),S(1,3),'b*');

        h=plot3(S(1,1),S(1,2),S(1,3),'b*', 'MarkerSize', 8); hold on;
        h=plot3(S(2,1),S(2,2),S(2,3),'go', 'MarkerSize', 8);
        h=plot3(S(3,1),S(3,2),S(3,3),'ko', 'MarkerSize', 8);
        h=plot3(S(4,1),S(4,2),S(4,3),'ro', 'MarkerSize', 8);
%         leftHand(s,:) = [S(4,1),S(4,2),S(4,3)];
        h=plot3(S(5,1),S(5,2),S(5,3),'bo', 'MarkerSize', 8);
        h=plot3(S(6,1),S(6,2),S(6,3),'co', 'MarkerSize', 8);

        %rotate(h,[0 45], -180);
        set(gca,'DataAspectRatio',[1 1 1])
    %     axis([-0.5 0.1 -0.3 0 0 0.3])
        axis([-0.8 0.4 0.2 0.6 -1 0.4])  
%     selJoint = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]';
%     refJoint = [0, 1, 2, 2, 4, 2, 6, 1, 8,  1, 10]';
    selJoint = [1, 2, 3, 4,  5, 6]';
    refJoint = [0, 1, 1, 1,  1, 1]';
    
    %    for j=1:19
         for j=2:size(selJoint,1)
            c1=selJoint(j);
            c2=refJoint(j);
            line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)], 'LineWidth', 0.5);
        end
        pause(1/20)
        xlabel('x');
    ylabel('y');
    zlabel('z'); 
        grid on;

    end
end

function result = findRefJoint(jointIdx, data)
    
    result = data((3*jointIdx-2): (3*jointIdx), :);
end