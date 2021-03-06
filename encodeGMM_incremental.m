function result = encodeGMM_incremental(Data)
    global nbStates numFrame DR
    %align
    % add time to Data
    tmp = [1:numFrame];
    time = repmat(tmp, [1, size(Data,2)/numFrame]);
    result = [];
    for i = 1 : 3: size(Data, 1)
        % each joint angle
        newData = [time; Data(i:i+2,:)];
        [M, expData] = GMM_incremental(newData, nbStates, numFrame); 
        result = [result;M];
%         feature = [feature,sortFeature(M(end))];        
    end
    
end

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


% function result = alignEach(Data)
%     global nbStates numFrame DR
%     ref = Data(:, 1:numFrame);
%     result = ref;
%     for i = 2 : size(Data, 2) / numFrame
%         new = [];        
%         tmp = Data(:, (i-1)*numFrame+1: i*numFrame);
%         for j = 1 : size(Data, 1)
%             [w, n] = DTW(tmp(j,:)', ref(j,:)');
%             new = [new; n'];
% %             figure;
% %             plot(ref(j,:), 'r'); hold on;
% %             plot(tmp(j,:),'g*');
% %             plot(n');
%         end
%         result = [result, new];    
%     end
%     
% end