function feature = sortFeature(M)
    feature = [];
    for i = 1 : size(M, 2)
%         M.Priors = Priors;
%         M.Mu = Mu;
%         M.Sigma = Sigma;
    %     M.Pix = Pix;
    %     save(['data/M',int2str(idx),'.mat'], 'M');
        [Y,I]=sort(M(i).Mu(1,:));
        B=M(i).Mu(:,I);
    %     B = B(2:end, :);
    %     B = [[1:nbStates];B(2:end,:)];
        feature = [feature; reshape(B, [1, numel(B)])];
    end
%     drawskt_combineJoints(expData);
%     drawskt_expData(expData, selJoint, refJoint);
%     save(['data/expData_',num2str(action), '_', num2str(subject), '.mat'], 'expData');
end