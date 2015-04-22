function theta = mapping_LArm
    J = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20;
         1,2,3,3,5,6,7,3, 9,10,11, 1,13,14,15, 1,17,18,19];

    B=[];
    file=sprintf(['../dataset_full_modified', '/train/a%02i_s%02i_e%02i_skeleton_proj.txt'],15,1,1);
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

lshoulder.x = X(9,:,:);
lshoulder.y = Y(9,:,:);
lshoulder.z = Z(9,:,:);

lelbow.x = X(10,:,:);
lelbow.y = Y(10,:,:);
lelbow.z = Z(10,:,:);

lhand.x = X(11,:,:);
lhand.y = Y(11,:,:);
lhand.z = Z(11,:,:);

theta(1,:) = -asin((lshoulder.x - lelbow.x) ./ dist(lshoulder, lelbow));
theta(2,:) = asin((lshoulder.y - lelbow.y) ./ dist(lshoulder, lelbow));
theta(3,:) = -asin((lelbow.x - lhand.x) ./ dist(lelbow, lhand));
theta(4,:) = acos(dist(lshoulder, lhand).^2 - dist(lshoulder, lelbow).^2 - dist(lelbow,lhand).^2);
theta(5:6,:) = zeros(2, size(theta(1,:),2));

end
function d = dist(p1, p2)
    d = sqrt(((p1.x - p2.x) .^ 2 + (p1.y - p2.y) .^2 + (p1.z - p2.z) .^2));
end