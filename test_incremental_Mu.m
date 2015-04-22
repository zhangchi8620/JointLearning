% load('file.mat')
row=[];
for i = 1 : 16
    m=file(i).model;
    for ins = 1 : size(m, 2)
        mu = [file(i).action];
        for fea = 1 : size(m, 1)
            tmp=m(fea, ins).Mu;
            mu = [mu, reshape(tmp, [1, 14])];
        end
        row = [row; mu];
    end
end