% All test files here

%% draw raw skeleton data
% torso area(8joints:1,2,3,4,5,9,13,17)
% all(20joints),
% star connect to torso(6joints:1,8,4,12,16,20)
% T-mode(8,5,3,4,9,12,13,16,17,20)
% flag 0: raw data; 1: move human to [0,0,0]
% test_plotRawSkt(1,1,1,6,1,4,'../dataset_GMM/train', 'torso', fixTorso);

%% calculate link variations
test_calRawVariance(1,16,1,2,1,4,'../dataset_GMM/train');