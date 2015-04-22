function  mapping_paper
    J = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20;
         1,2,3,3,5,6,7,3, 9,10,11, 1,13,14,15, 1,17,18,19];

    B=[];
    file=sprintf(['../dataset_full_modified', '/train/a%02i_s%02i_e%02i_skeleton_proj.txt'],8,1,1);
    fp=fopen(file);
    if (fp>0)
       A=fscanf(fp,'%f');
       B=[B; A];
       fclose(fp);
    end
    l=size(B,1)/5;
    B=reshape(B,5,l);
    B=B';
    A=B;
    B=reshape(B,20,l/20,5);

    X=B(:,:,3);
    Z=B(:,:,4);
    Y=B(:,:,5)/4;

    X = X - repmat(X(1,:), [20,1]);
    Y = Y - repmat(Y(1,:), [20,1]);
    Z = Z - repmat(Z(1,:), [20,1]);
    % Human: x   y   z
    % MSR:   -x  z   y
    X = -X;
    tmp = Y;
    Y = Z;
    Z = tmp;
    

%     for s=1:size(X,2)
%         S=[X(:,s) Y(:,s) Z(:,s)];
% 
%         xlim = [0 800];
%         ylim = [0 800];
%         zlim = [0 800];
%         set(gca, 'xlim', xlim, ...
%                  'ylim', ylim, ...
%                  'zlim', zlim);
% 
%         h=plot3(S(:,1),S(:,2),S(:,3),'r.');
%     %     rotate(h,[0 45], -180);
%         set(gca,'DataAspectRatio',[1 1 1])
%     %     axis([0 400 0 400 0 400])
% 
%         for j=1:19
%             c1=J(1,j);
%             c2=J(2,j);
%             line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)]);
%         end
%         pause(1/20)
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
% %     pause;
%     grid on;
%     end

    %neck
    neck.x = X(3,:);
    neck.y = Y(3,:);
    neck.z = Z(3,:);
    
    %hip
    hip.x = X(1,:);
    hip.y = Y(1,:);
    hip.z = Z(1,:);
    
    %% RArm
    rshoulder.x = X(5,:);
    rshoulder.y = Y(5,:);
    rshoulder.z = Z(5,:);

    relbow.x = X(6,:);
    relbow.y = Y(6,:);
    relbow.z = Z(6,:);

    rwrist.x = X(7,:);
    rwrist.y = Y(7,:);
    rwrist.z = Z(7,:);

    non = zeros(1, size(rshoulder.x, 2));

    vec_Neck_RShoulder = [rshoulder.x-neck.x; rshoulder.y-neck.y; rshoulder.z-neck.z];
    vec_Neck_RShoulder = normalizeVecByCol(vec_Neck_RShoulder);
    vec_RShoulder_RElbow=[relbow.x-rshoulder.x; relbow.y-rshoulder.y; relbow.z-rshoulder.z];
    vec_RShoulder_RElbow = normalizeVecByCol(vec_RShoulder_RElbow);
    vec_RElbow_RWrist = [rwrist.x-relbow.x; rwrist.y-relbow.y; rwrist.z-relbow.z];
    vec_RElbow_RWrist = normalizeVecByCol(vec_RElbow_RWrist);
        
    hRShoulderPitch= pi/2-acos(vec_RShoulder_RElbow(2,:)); %RShoulderPitch
    rRShoulderPitch = -hRShoulderPitch;
    hRShoulderPitchOrig = asin((rshoulder.y - relbow.y) ./ dist(rshoulder, relbow)); %Orig-RShoulderPitch
    
    hRShoulderRoll =asin(dot(vec_Neck_RShoulder, vec_RShoulder_RElbow)); %RShoulderRoll
    rRShoulderRoll = hRShoulderRoll;
    hRShoulderRollOrig = -asin((rshoulder.x - relbow.x) ./ dist(rshoulder, relbow)); %Orig-RShoulderRoll

    hRElbowYaw = -asin(vec_RElbow_RWrist(1,:)); %RElbowYaw
    rRElbowYaw = hRElbowYaw;
    hRElbowYawOrig = -asin((relbow.x - rwrist.x) ./ dist(relbow, rwrist)); %Orig-ElbowYaw
    
    hRElbowRoll =  -asin(-dot(vec_RShoulder_RElbow, vec_RElbow_RWrist)); %ElbowRoll
    rRElbowRoll = hRElbowRoll;
    hRElbowRollOrig=acos(dist(rshoulder, rwrist).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rwrist).^2); %Orig-ElbowRoll
    
    theta = [rRShoulderPitch; rRShoulderRoll;rRElbowYaw;rRElbowRoll;non; non];
%     tmp=dist(rshoulder, rwrist).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rwrist).^2; 
%     t1 =acos(tmp);
%     t1 = t1/pi*180;
%     t2 = acos(tmp ./(2.*dist(rshoulder,relbow).*dist(relbow,rwrist)));
%     t2=t2/pi*180;
%     theta = [theta; [non;non]];

    %% LArm
%     % recover xyz
%     X = -X;
%     tmp = Y;
%     Y = Z;
%     Z = tmp;
    lshoulder.x = X(9,:);
    lshoulder.y = Y(9,:);
    lshoulder.z = Z(9,:);

    lelbow.x = X(10,:);
    lelbow.y = Y(10,:);
    lelbow.z = Z(10,:);

    lwrist.x = X(11,:);
    lwrist.y = Y(11,:);
    lwrist.z = Z(11,:);

    
    vec_Neck_LShoulder = [lshoulder.x-neck.x; lshoulder.y-neck.y; lshoulder.z-neck.z];
    vec_Neck_LShoulder = normalizeVecByCol(vec_Neck_LShoulder);
    vec_LShoulder_LElbow=[lelbow.x-lshoulder.x; lelbow.y-lshoulder.y; lelbow.z-lshoulder.z];
    vec_LShoulder_LElbow = normalizeVecByCol(vec_LShoulder_LElbow);
    vec_LElbow_LWrist = [lwrist.x-lelbow.x; lwrist.y-lelbow.y; lwrist.z-lelbow.z];
    vec_LElbow_LWrist = normalizeVecByCol(vec_LElbow_LWrist);
    
    
    theta = [theta; -asin(vec_LShoulder_LElbow(2,:))]; %ShoulderPitch
%     tmp = asin((rshoulder.y - relbow.y) ./ dist(rshoulder, relbow)); %Orig-ShoulderPitch
    
    theta =[theta; -asin(dot(vec_Neck_LShoulder, vec_LShoulder_LElbow))]; %ShoulderRoll
%     tmp = -asin((rshoulder.x - relbow.x) ./ dist(rshoulder, relbow)); %Orig-ShoulderRoll

    theta =[theta; -asin(vec_LElbow_LWrist(1,:))]; %ElbowYaw
%     tmp = -asin((relbow.x - rwrist.x) ./ dist(relbow, rwrist)); %Orig-ElbowYaw
    
    theta =[theta; asin(-dot(vec_LShoulder_LElbow, vec_LElbow_LWrist))]; %ElbowRoll
%     tmp=acos(dist(rshoulder, rwrist).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rwrist).^2); %Orig-ElbowRoll
        
%     theta =[theta; asin((lshoulder.z - lelbow.z) ./ dist(lshoulder, lelbow))];
%     theta =[theta; -asin((lshoulder.x - lelbow.x) ./ dist(lshoulder, lelbow))]; 
%     theta =[theta; -asin((lelbow.x - lwrist.x) ./ dist(lelbow, lwrist))]; 
%     theta =[theta; -acos(dist(lshoulder, lwrist).^2 - dist(lshoulder, lelbow).^2 - dist(lelbow,lwrist).^2)];
    theta =[theta; [non;non]];

    %RLeg
    rhip.x = X(13,:);
    rhip.y = Y(13,:);
    rhip.z = Z(13,:);

    rknee.x = X(14,:);
    rknee.y = Y(14,:);
    rknee.z = Z(14,:);

    rfoot.x = X(15,:);
    rfoot.y = Y(15,:);
    rfoot.z = Z(15,:);

    theta =[theta; non];
    theta =[theta; asin((rhip.y - rknee.y) ./ dist(rhip, rknee))];   %HipRoll
    theta =[theta; asin((rhip.x - rknee.x) ./ dist(rhip, rknee))];    %HipPItch
    theta =[theta; asin((rknee.x - rfoot.x) ./ dist(rknee, rfoot))];  %KneePitch
    theta =[theta; [non;non]];

    %LLeg
    lhip.x = X(17,:);
    lhip.y = Y(17,:);
    lhip.z = Z(17,:);

    lknee.x = X(18,:);
    lknee.y = Y(18,:);
    lknee.z = Z(18,:);

    lfoot.x = X(19,:);
    lfoot.y = Y(19,:);
    lfoot.z = Z(19,:);

    theta =[theta; non];
    theta =[theta; asin((lhip.y - lknee.y) ./ dist(lhip, lknee))];
    theta =[theta; asin((lhip.x - lknee.x) ./ dist(lhip, lknee))];
    theta =[theta; asin((lknee.x - lfoot.x) ./ dist(lknee, lfoot))];
    theta =[theta; [non;non]];

    theta = theta';
    
    dlmwrite('allJoint.txt',theta,'delimiter','\t');
end

function d = dist(p1, p2)
    d = sqrt(((p1.x - p2.x) .^ 2 + (p1.y - p2.y) .^2 + (p1.z - p2.z) .^2));
end

function vec = normalizeVecByCol(vec)
    for i = 1 : size(vec, 2)
       v = vec(:,i);
       vec(:,i) = v / norm(v);
    end
end