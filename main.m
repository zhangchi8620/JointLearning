function main
clc;
clear;
% delete('*.mat');
% delete('*.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Configurations    
% Assemble dataset (within one action): 
%   1) combine instances from one subject
%   2) rotate instances in sequence
%   3) exhaust fidxed number of instances combinations 
%   5) no combination, treat each instance independently
%   Align:  
%       1) Resize; 
%       2) DTW: each dimension VS each joint

% Encode feature
%   1) GMM;    
%   2) GMM-DR
%   3) No encoding
%   ==> Mu_Train (1~3 Assemble), Mu_Test (1~3 Assemble)
%   ==> Model_Train (1~3 Assemble), Raw_Test (4 Assemble)  

% Classify
%   1) SVM: Mu_Train vs. Mu_Test
%   2) Loglikelihood:  Model_Train vs. Raw_Test

%% PARAMETERS
% jointMode: centerStar, centerAll, adjacent, Tmode    
% DR: false - no PCA, true - PCA
path = '../dataset_GMM/';
global nbStates numFrame selJoint refJoint selBone refBone DR
nbStates = 10;    
numFrame = 400;
DR = false;
jointMode = 'Nao';
switch jointMode
        % position: relative to a single ref: 
        % torso (centralized) with star joints  
        case 'centerStar'
            selJoint = [4, 8, 12, 16, 20]';
            refJoint = ones(size(selJoint));
        % position: relative to a single ref: 
        % torso with all joints
        case 'centerAll'
            selJoint = [1:20]';
            refJoint = ones(size(selJoint));
        % joint angle: all    
        case 'adjacent'
            selJoint = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]';
            refJoint = [1,2,3,3,5,6,7,3, 9,10,11, 1,13,14,15, 1,17,18,19]';
        % joint angle: torso area (Tmode)
        case 'Tmode'
            selJoint = [4, 8, 12, 16, 20]';
            refJoint = [3, 5,  9, 13, 17]';            
        case 'Nao'
            selJoint = [4, 5, 3, 6, 5, 8, 4, 9, 3, 10,  9, 12,  1, 14, 13, 16,  1, 18, 17, 20]';
            refJoint = [3, 3, 5, 5, 6, 6, 3, 3, 9,  9, 10, 10, 13, 13, 14, 14, 17, 17, 18, 18]';
            selBone =  [2:2:20]';
            refBone =  [1:2:19]';               
        otherwise
             error('Wrong feature mode.')
end

for idx = 1 : 1
% write configuration to file
write2txt();   
    
    %% Case 1 (Baseline, batch): Combine instances from one sub in Train and Test
    % Assemble 1 (combine instances from one subject) for both Train and Test 
    % Encode with DTW, GMM/GMM-DR ==> Mu_Train, Mu_Test
    % Classify with SVM (Mu_Train vs. Mu_Test)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     disp('Batch mode (combine vodeis from one sub in Train and Test)');
%     if (exist('trainCombineSubject.mat') ~= 0)
%         load('trainCombineSubject.mat');
%     else
%         trainData = assemble(1,16,1,6,1,4, [path,'train'], 'combineInstance', 0, jointMode);
%         save('trainCombineSubject.mat', 'trainData');
%     end
%     file = encode(trainData,'train'); 
%     addLabel(file, 'train');
%     
%     if (exist('testCombineSubject.mat') ~= 0)
%         load('testCombineSubject.mat');
%     else
%         testData = assemble(1,16,7,10,1,4, [path,'test'], 'combineInstance', 0, jointMode);
%         save('testCombineSubject.mat', 'testData');
%     end
%     file = encode(testData, 'test');
%     addLabel(file, 'test');
%     
% %     movefile('*.txt', ['result/combTrain_combTest/', int2str(idx), '/']);
%     
%     end
    % selectFeature();


    %% Case 2 (individual): individual mode, treat each instance independently
    disp('Individual mode (no comb in Train and Test)');
    if (exist('trainEachSubject.mat') ~= 0)
        load('trainEachSubject.mat');
    else
        trainData = assemble(1,16,1,6,1,4, [path,'train'], 'no_comb', 0, jointMode);
        save('trainEachSubject.mat', 'trainData');
    end
    file = encode(trainData,'train'); 
    addLabel(file, 'train');
    
    if (exist('testEachSubject.mat') ~= 0)
        load('testEachSubject.mat');
    else
        testData = assemble(1,16,7,10,1,4, [path,'test'], 'no_comb', 0, jointMode);
        save('testEachSubject.mat', 'testData');
    end
    file = encode(testData, 'test');
    addLabel(file, 'test');
%     movefile('*.txt', ['result/eachTrain_eachTest/', int2str(idx), '/']);
    end

    % selectFeature();

    %% Case 3 (incremental): Add classified test data to train new models
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%`%%%%%%%%%%%%%%%%%%%%%%%%%
%     disp('incremental');
%     if (exist('trainIncremental.mat') ~= 0)
%         load('trainIncremental.mat');
%     else
%         trainData = assemble(1,16,1,6,1,4, [path,'train'], 'incremental', 0, jointMode);
%         save('trainIncremental.mat', 'trainData');
%     end    
%     file = encode(trainData,'train'); 
%     addLabel(file, 'train');
% 
%     if (exist('testIncremental.mat') ~= 0)
%         load('testIncremental.mat');
%     else
%         testData = assemble(1,16,7,10,1,4, [path,'test'], 'no_comb', 0, jointMode);
%         save('testIncremental.mat', 'testData');
%     end
%     file = encode(testData,'test'); 
%     addLabel(file, 'test');
%         
%     end
    
%     load('file.mat');
%     rate = 0;
%     for ins = 1 : 128
%     for act = 1 : 16       
%         for row = 1:30
%             for col = 1:2
% %                 fprintf('action %d, feature %d\t, model %d\n',act, row, col);
%                 m = file(act).model(row, col);
%                 time = [1:numFrame];
%                 inData = [time; testData(ins).data(row,:)];
%                 result2(row, col, act) = calLoglik(inData, m.Priors,m.Mu,m.Sigma,m.Pix);                
%             end
%             result(row, act) = max(result2(row, :, act));
%         end              
%     end
%     
%     for i = 1 : 30
%         x=result(i,:);
%         y(i)=find(x==max(x));
%     end
%     if (testData(ins).action == mode(y))
%         rate = rate + 1;
%     end
%     fprintf('truth %d, classification %d\n',testData(ins).action, mode(y));
%     
%     
%     end
%     rate / 40
%     for i = 1 : 5
%         x = result(:,:,i);
%         [v,ind]=max(x(:));
%         [y,x] = ind2sub(size(x),ind);
%         disp(sprintf('The largest element in this matrix is %f at (%d,%d).', v, y, x ));
%         loglik(i) = v;
%     end
%     if (testData(ins).action == (find(loglik==max(loglik))))
%         rate = rate + 1;
%     end
%     fprintf('truth %d, classification %d\n',testData(ins).action,  find(loglik==max(loglik)));
%     end
%     rate / 40
%     maxIdx = find(result == max(result))
%         maxVal = max(result)
%         rr(act) = maxVal;
%         fprintf('action %d, loglik %f, maxIdx %d\n',act, maxVal,maxIdx);  
        
% find(rr == max(rr))        
%     file = encode(testData, 'test');
%     addLabel(file, 'test');
%     movefile('*.txt', ['result/incremTrain_incremTest/', int2str(idx), '/']);
end

