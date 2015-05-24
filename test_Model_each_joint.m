% test Model-each-joint.mat
function test_Model_each_joint()
    load('Model-each-joint.mat');
    fea=[];
    for i=1:size(M,1)
        row=[];
        for j=1:size(M,2)
            tmp = M(i,j).Mu;
            spacial = tmp(2,:);
            temporal = tmp(1,:);
            row = [row, spacial];
        end
        fea = [fea; row];
    end
    
    addLabel(file, 'train');
end