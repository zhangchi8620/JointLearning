function row=extractMu()
    load('M.mat');
    count=1;
    [numAction, numFeature] = size(M);
    file =[];
    for i = 1 : numAction
        numInstance = size(M(i,1).model, 2);
        
        for s = 1 : numInstance
            row=i;            
            for f = 1 : numFeature
                ins = M(i,f).model(s);
                tmp=sortMu(ins);
                row =[row,tmp];
                count = count+1;
            end
            
            file = [file;row];
        end
    end
    addLabel(file,'train');
end

function row=sortMuMatrix(mm)
    row=[];
    for i = 1 : size(mm,2)
        row=[row,sortMu(mm)];
    end
end