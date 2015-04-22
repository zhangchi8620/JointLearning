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
path = '../dataset_full_modified/';
global nbStates numFrame selJoint refJoint selBone refBone DR
nbStates = 15;    
numFrame = 200;
DR = true;
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
% disp('Combine instances from one sub in Train and Test');
% if (exist('trainCombineSubject.mat') ~= 0)
%     load('trainCombineSubject.mat');
% else
%     trainData = assemble(1,16,1,6,1,4, [path,'train'], 'combineInstance', 0, jointMode);
%     save('trainCombineSubject.mat', 'trainData');
% end
% file = encode(trainData,'train'); 
% addLabel(file, 'train');
% 
% if (exist('testCombineSubject.mat') ~= 0)
%     load('testCombineSubject.mat');
% else
%     testData = assemble(1,16,7,10,1,4, [path,'test'], 'combineInstance', 0, jointMode);
%     save('testCombineSubject.mat', 'testData');
% end
% file = encode(testData, 'test');
% addLabel(file, 'test');
% 
% movefile('*.txt', ['result/combTrain_combTest/', int2str(idx), '/']);
% 
% end
% selectFeature();


%% Case 2 (individual): no combination, treat each instance independently
% disp('no combination in Train and Test');
% if (exist('trainEachSubject.mat') ~= 0)
%     load('trainEachSubject.mat');
% else
%     trainData = assemble(1,16,1,6,1,4, [path,'train'], 'no_comb', 0, jointMode);
%     save('trainEachSubject.mat', 'trainData');
% end
% file = encode(trainData,'train'); 
% addLabel(file, 'train');
% 
% if (exist('testEachSubject.mat') ~= 0)
%     load('testEachSubject.mat');
% else
%     testData = assemble(1,16,7,10,1,4, [path,'test'], 'no_comb', 0, jointMode);
%     save('testEachSubject.mat', 'testData');
% end
% file = encode(testData, 'test');
% addLabel(file, 'test');
% movefile('*.txt', ['result/eachTrain_eachTest/', int2str(idx), '/']);
% end

% selectFeature();

%% Case 3 (incremental): Combine instances from one sub in Train and Test
% Assemble 1 (combine instances from one subject) for both Train and Test 
% Encode with DTW, GMM/GMM-DR ==> Mu_Train, Mu_Test
% Classify with SVM (Mu_Train vs. Mu_Test)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('incremental');
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
movefile('*.txt', ['result/eachTrain_eachTest/', int2str(idx), '/']);
end

%% Case 2: exhaust Train, Raw Test
% Assemble 2 (rotate) train dataset, No assemble for test dataset
% Encode train with DTW, GMM/GMM-DR ==> Model_Train; No test encoding ==> Raw_Test
% Classify with Likelihood (Model_Train vs. Raw_Test)
% Parameters: gap - combine gap instances to feed in GMM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('Rotate instances in Train and Test');
% file = encodeData_rotateTrain_eachTest(1,16,1,6,1,4, [path,'train'], 5, featureMode);
% addLabel(file, 'train');
% file = encodeData_rotateTrain_eachTest(1,16,7,10,1,4, [path, 'test'], 1, featureMode);
% addLabel(file, 'test');

%% Case 3: Rotate Train, Rotate Test
% Assemble 2 (roate) train and test dataset
% Encode train and test with DTW, GMM/GMM-DR ==> Mu_Train, Mu_Test
% Classify with SVM (Mu_Train, Mu_Test)
% Parameters: gap - combine gap instances to feed in GMM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp('Exhaust instances from one sub in Train and Test');
% file = encodeData_rotateTrain_combineTest(1,16,1,6,1,4, [path,'train'], 2, featureMode);
% addLabel(file, 'train');
% file = encodeData_rotateTrain_combineTest(1,16,7,10,1,4, [path, 'test'], 1, featureMode);
% addLabel(file, 'test');

%% Case 4: Combine instances from one subject for Train, No assemble for Test
% Assemble 1 (combine instances from one subject) for Train; No assemble for Test
% Encode with DTW, GMM/GMM-DR ==> Mu_Train, Mu_Test(just one instance)
% Classify with SVM (Mu_Train, Mu_Test(one instance))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp('Combine instances from one sub in Train, No comb for Test');
% if (exist('trainCombineSubject.mat') ~= 0)
%     load('trainCombineSubject.mat');
% else
%     trainData = assemble(1,16,1,6,1,4, [path,'train'], 'combineInstance', 0, jointMode);
%     save('trainCombineSubject.mat', 'trainData');
% end
% file = encode(trainData,'train'); 
% addLabel(file, 'train');
% 
% if (exist('testNoComb.mat') ~= 0)
%     load('testNoComb.mat');
% else
%     testData = assemble(1,16,7,10,1,4, [path,'test'], 'no_comb', 0, jointMode);
%     save('testNoComb.mat', 'testData');
% end
% file = encode(testData, 'test');
% addLabel(file, 'test');
% 
% selectFeature();
