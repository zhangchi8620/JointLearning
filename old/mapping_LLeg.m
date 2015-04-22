function theta = mapping_LLeg
    J = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20;
         1,2,3,3,5,6,7,3, 9,10,11, 1,13,14,15, 1,17,18,19];

    B=[];
    file=sprintf(['../dataset_full_modified', '/train/a%02i_s%02i_e%02i_skeleton_proj.txt'],16,4,1);
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
    %P=B(:,:,4);
    % B(:,:,5) = B(:,:,5)/4;
    % data = B(:,:,3:5);

    data(:,:,1) = X;
    data(:,:,2) = Y;
    data(:,:,3) = Z;     
    
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
end

lhip.x = X(17,:,:);
lhip.y = Y(17,:,:);
lhip.z = Z(17,:,:);

lknee.x = X(18,:,:);
lknee.y = Y(18,:,:);
lknee.z = Z(18,:,:);

lfoot.x = X(19,:,:);
lfoot.y = Y(19,:,:);
lfoot.z = Z(19,:,:);

non = zeros(1, size(lfoot.x, 2));
theta(1,:) = non;
theta(2,:) = -asin((lhip.x - lknee.x) ./ dist(lhip, lknee));
theta(3,:) = asin((lhip.y - lknee.y) ./ dist(lhip, lknee));
theta(4,:) = asin((lknee.x - lfoot.x) ./ dist(lknee, lfoot));
theta(5:6,:) = [non;non];

theta = theta';
end
function d = dist(p1, p2)
    d = sqrt(((p1.x - p2.x) .^ 2 + (p1.y - p2.y) .^2 + (p1.z - p2.z) .^2));
end