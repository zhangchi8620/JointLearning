load Model-each-joint;
file = [];
for line =  1: 199
    row = [];    
    for fea = 1 : 14
        row=[row,sortFeature(M(line,fea))];
    end
    file = [file; row];
end
    save('train.mat', 'file');
    addLabel(file, 'train');
