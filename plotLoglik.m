function plotLoglik
load('plotLoglik/loglik13.mat');
for i = 1 : 14
    y(:,:,i)=loglik(i).data;
end
z=mean(y,3);
bar3(-z);xlabel('data','FontSize',20);ylabel('model','FontSize',20);zlabel('-loglik','FontSize',20);set(gca, 'FontSize', 15);
figure;
d=loglik.data;
bar3(-d);xlabel('data','FontSize',20);ylabel('model','FontSize',20);zlabel('-loglik','FontSize',20);set(gca, 'FontSize', 15);