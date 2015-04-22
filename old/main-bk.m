clc;
clear;
delete('*.mat');
delete('*.txt');

% M = 40;
% N = 40;
% GMM features
% path = '../dataset_GMM/';
% file = extractFeatureGMM(1,16,1,6,1,2, [path,'train'], M, N);
% addLabel(file, 'train');
% file = extractFeatureGMM(1,16,7,10,1,2, [path, 'test'], M, N);
% addLabel(file, 'test');

% GMM features, all joints
path = '../dataset_GMM/';
file = extractFeatureGMM_combineInstance_combineJoints(1,16,1,6,1,4, [path,'train']);
addLabel(file, 'train');
file = extractFeatureGMM_combineInstance_combineJoints(1,16,7,10,1,4, [path, 'test']);
addLabel(file, 'test');

% star joints: distance and angle: 54% (M=20,N=20)
% path = '../dataset/';
% file = extractFeature(8,16,1,6,1,2, [path,'train'], M, N);
% addLabel(file, 'train');
% file = extractFeature(8,16,7,10,1,2, [path, 'test'], M, N);
% addLabel(file, 'test');

% all joints: distance and angle: 64% (M=20,N=20)
% path = '../dataset/';
% file = extractFeature2(1,16,1,6,1,2, [path, 'train'], M, N);
% addLabel(file, 'train');
% file = extractFeature2(1,16,7,10,1,2, [path, 'test'], M, N);
% addLabel(file, 'test');

% star joints: vectors: 72% (M=20,N=20)
% path = '../dataset/';
% file = extractFeature3(8,16,1,6,1,2, [path, 'train'], M, N);
% addLabel(file, 'train');
% file = extractFeature3(8,16,7,10,1,2, [path, 'test'], M, N);
% addLabel(file, 'test');

% all joints: vectors: 70% (M=20,N=20, M=15,N=15); 81%(M=10,N=10)
% 83% (M=5, N=5)
% path = '../dataset_full/';
% file = extractFeature4(1,16,1,6,1,2, [path, 'train'], M, N);
% addLabel(file, 'train');
% file = extractFeature4(1,16,7,10,1,2, [path, 'test'], M, N);
% addLabel(file, 'test');

