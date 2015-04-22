function theta = mapping_14
    J = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20;
         1,2,3,3,5,6,7,3, 9,10,11, 1,13,14,15, 1,17,18,19];

    B=[];
    file=sprintf(['../dataset_full_modified', '/train/a%02i_s%02i_e%02i_skeleton_proj.txt'],10,3,2);
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

    
for s=1:size(X,2)
    S=[X(:,s) Y(:,s) Z(:,s)];
  
    xlim = [0 800];
    ylim = [0 800];
    zlim = [0 800];
    set(gca, 'xlim', xlim, ...
             'ylim', ylim, ...
             'zlim', zlim);

    h=plot3(S(:,1),S(:,2),S(:,3),'r.');
%     rotate(h,[0 45], -180);
    set(gca,'DataAspectRatio',[1 1 1])
%     axis([0 400 0 400 0 400])

    for j=1:19
        c1=J(1,j);
        c2=J(2,j);
        line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)]);
    end
    pause(1/20)
xlabel('x');
ylabel('y');
zlabel('z');
pause;
end

%RArm
  rshoulder.x = X(5,:);
rshoulder.y = Y(5,:);
rshoulder.z = Z(5,:);

relbow.x = X(6,:);
relbow.y = Y(6,:);
relbow.z = Z(6,:);

rhand.x = X(7,:);
rhand.y = Y(7,:);
rhand.z = Z(7,:);

non = zeros(1, size(rshoulder.x, 2));

% theta = asin((rshoulder.z - relbow.z) ./ dist(rshoulder, relbow)); %ShoulderRoll
% theta =[theta; -asin((rshoulder.x - relbow.x) ./ dist(rshoulder, relbow))]; %ShoulderPitch
% theta =[theta; -asin((relbow.x - rhand.x) ./ dist(relbow, rhand))];
% theta =[theta; acos(dist(rshoulder, rhand).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rhand).^2)];
% tmp=dist(rshoulder, rhand).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rhand).^2;
% t1 =acos(tmp);
% t1 = t1/pi*180;
% t2 = acos(tmp ./(2.*dist(rshoulder,relbow).*dist(relbow,rhand)));
% t2=t2/pi*180;

% ShoulderPitch, ShoulderRoll, ElbowYaw, ElbowRoll, WristYaw

theta = [theta; [non;non]];

%LArm
lshoulder.x = X(9,:);
lshoulder.y = Y(9,:);
lshoulder.z = Z(9,:);

lelbow.x = X(10,:);
lelbow.y = Y(10,:);
lelbow.z = Z(10,:);

lhand.x = X(11,:);
lhand.y = Y(11,:);
lhand.z = Z(11,:);

theta =[theta; asin((lshoulder.z - lelbow.z) ./ dist(lshoulder, lelbow))];
theta =[theta; -asin((lshoulder.x - lelbow.x) ./ dist(lshoulder, lelbow))]; 
theta =[theta; -asin((lelbow.x - lhand.x) ./ dist(lelbow, lhand))]; 
theta =[theta; -acos(dist(lshoulder, lhand).^2 - dist(lshoulder, lelbow).^2 - dist(lelbow,lhand).^2)];
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
end
function d = dist(p1, p2)
    d = sqrt(((p1.x - p2.x) .^ 2 + (p1.y - p2.y) .^2 + (p1.z - p2.z) .^2));
end