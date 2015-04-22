function [feature, M, expData] = encodeGMM(Data, action)
    global nbStates numFrame DR

    tmp = [1:numFrame];
    time = repmat(tmp, [1, size(Data,2)/numFrame]);
        
    % add time to Data    
    Data = [time; Data];
    
    if DR        
        [Priors, Mu, Sigma, expData, Pix] = GMM_DR(Data, nbStates, numFrame);        
    else
        [Priors, Mu, Sigma, expData, Pix] = GMM(Data, nbStates, numFrame, action);
    end
        
    M.Priors = Priors;
    M.Mu = Mu;
    M.Sigma = Sigma;
    M.Pix = Pix;
%     save(['data/M',int2str(idx),'.mat'], 'M');
    [Y,I]=sort(Mu(1,:));
    B=Mu(:,I);
%     B = B(2:end, :);
%     B = [[1:nbStates];B(2:end,:)];
    feature = reshape(B, [1, numel(B)]);
%     drawskt_combineJoints(expData);
%     drawskt_expData(expData, selJoint, refJoint);
%     save(['data/expData_',num2str(action), '_', num2str(subject), '.mat'], 'expData');

end