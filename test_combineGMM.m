function test_combineGMM()
    addpath('/Users/zhangchi8620/Codes/GMM-incremental-v2.0');    
    global numFrame;
    load Model;
    
    nbVar = size(M(1).Priors, 2);
    temporalData = [1:numFrame];
%     for i = 1 : size(M,2)        
    for i = 1 : 12        
        [y, Sigma_y] = GMR(M(i).Priors, M(i).Mu, M(i).Sigma, temporalData, [1], [2:nbVar]);   
        for j=1:numFrame
            tmp = gaussSampling(y(:,j), Sigma_y(:,:,j), 1);
            sampedtmp(:,j) = tmp';            
        end
%         for joint = 1 : nbVar - 1
        for joint = 3
            plot(y(joint,:),'r'); hold on; plot(sampedtmp(joint,:));
        end

%         sampledData(i).data = sampedtmp;
%         sampledData(i).action = M(i).action;
    end
end