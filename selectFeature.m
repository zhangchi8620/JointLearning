function feature = selectFeature()
    clc;
    clear;
    addpath('/Users/zhangchi8620/Codes/FEAST/FEAST-v1.1.1/FEAST');
    load('train.mat');
    inData = file;
    data = inData(:,2:end);
    labels = inData(:,1);
    
    feature = feast('mrmr',20,data,labels);
%     feature = feast('jmi',5,data, labels);
%     feature = feast('mifs',5,data,labels,0.7);
    
    reAssemble(feature, 'train');
    reAssemble(feature, 'test');
end

function reAssemble(feature, mode)
    load([mode, '.mat']);
    labels = file(:,1);

    for i = 1 : size(feature)
        result(:,i) = file(:,feature(i) + 1);
    end
    result = [labels, result];

    x = result(1,:);
    idx = find (x>1);
    x(idx)
    addLabel(result, [mode, '_selFeature']);      
end