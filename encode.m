function [file, M, loglikelihood] = encode(inData, mode)
    disp('Encoding...');
    file = [];
    
%     plotRawData(inData);

%% Individual & batch modes    
    for i = 1 : size(inData,2)    
        fprintf('\tAction %d \n', inData(i).action);
        data = inData(i).data;
        
%         if inData(i).action == 5
        [row, M(i), expData] = encodeGMM(data, inData(i).action);  
        
        tmp = expData(2:end,:);
        non = zeros(1, size(tmp, 2));
        regData(i).action = inData(i).action;        
        regData(i).data = [tmp(1:4,:); [non;non]; tmp(5:8,:); [non;non;non]; tmp(9:11,:);[non;non;non];tmp(12:14,:);[non;non]]';
        row = [inData(i).action, row];
        file = [file; row];
%         end
    end
    fprintf('\t>>>Total instances %d\n\t\nSaving... %s.mat\n', size(inData,2), mode);
    save([mode,'.mat'], 'file');
    save('regData.mat', 'regData');
    
%% Incremental
% return full GMM model param, or Mu only
%     insModel = [];
%     insMu = [];
%     for i = 1 : size(inData,2)
%         fprintf('\tAction %d \n', inData(i).action);
%         
%         insModel(i).model = encodeGMM_incremental(inData(i).data); 
%         insModel(i).action = inData(i).action;
%         
%         m=insModel(i).model;
%         for ins = 1 : size(m, 2)
%             row = [insModel(i).action];
%             for fea = 1 : size(m, 1)
%                 tmp=m(fea, ins).Mu;
%                 % if return Mu only, sorted Mu
%                 [Y,I]=sort(tmp(1,:));
%                 B=tmp(:,I);
%                 % remove time stamp
%                 B = B(2:end, :);
%                 tmp2 = reshape(B, [1, numel(B)]);    
%                 row = [row, tmp2];
%             end
%             insMu = [insMu; row];
%         end    
% %         row = [inData(i).action, row];        
% %         instance = [instance; row];                    
%     end
% %     file = reshape(row, [1, size(row, 2)]);
% %     file = insModel;
%     file = insMu;
%     fprintf('\t>>>Total instances %d\n\t\nSaving... %s.mat\n', size(inData,2), mode);
%     save([mode,'.mat'], 'file');

    % new version: train each joint angle independently. 
    % model matrix: numVideos*numFeature(numJoint)
  %%%%%%%%%  correct gmm_incremental 
%     for i = 1 : inData(end).action
%         fprintf('\tAction %d \n', i);        
%         datatmp = [];
%         for j = 1 : size(inData, 2)
%             if (inData(j).action == i)
%                 datatmp = [datatmp,inData(j).data];
%             end
%             j = j + 1;        
%         end
%         [gmms, logtmp] = encodeGMM_incremental(datatmp);
%         M(i,:) = gmms;
% %         gmm_action(i).feature = gmm_action_feature;
% %         gmm_action(i).action = i;
% %         M = [M; gmm_action_feature];
%         loglikelihood(i).data = logtmp;
%     end
    %%%%%%%%
    
%     save('loglikelihood.mat', 'loglikelihood');
%         insModel(i).action = inData(i).action;
%         
%         m=insModel(i).model;
%         for ins = 1 : size(m, 2)
%             row = [insModel(i).action];
%             for fea = 1 : size(m, 1)
%                 tmp=m(fea, ins).Mu;
%                 % if return Mu only, sorted Mu
%                 [Y,I]=sort(tmp(1,:));
%                 B=tmp(:,I);
%                 % remove time stamp
%                 B = B(2:end, :);
%                 tmp2 = reshape(B, [1, numel(B)]);    
%                 row = [row, tmp2];
%             end
%             insMu = [insMu; row];
%         end    
% %         row = [inData(i).action, row];        
% %         instance = [instance; row];                    
%     end
% %     file = reshape(row, [1, size(row, 2)]);
% %     file = insModel;
%     file = insMu;
%     fprintf('\t>>>Total instances %d\n\t\nSaving... %s.mat\n', size(inData,2), mode);
%     save([mode,'.mat'], 'file');
end

function plotRawData(inData)
    numJointPlot = 14;
    old = 0;
    count = 1;
    for j = 1 : size(inData,2)
        if inData(j).action ~= old
            h(count) = figure;
            count = count+1;
        end
        
        idx = reshape(1:numJointPlot,2,[])';
        idx = idx(:);
        for i = 1 : numJointPlot
            subplot(numJointPlot/2,2,idx(i));
            plot([inData(j).data(i,:)]');hold on;   
            ylabel(['\xi_{' num2str(i) '}'],'fontsize',16);          
        end
        old = inData(j).action;
    end
    
    for j = 1 : count-1
            savefig(h(j),['./data/plot/indiv_raw/action',int2str(j),'FiguresFile.fig'])  
            close(h(j));
    end
end