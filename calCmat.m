function calCmat()
    cmat1 = zeros(16, 16);
    numVideo = 8;
    
    %% indiv mode
    x = textread('/Users/zhangchi8620/Codes/libsvm-3.18/tools/data_paper/msr/indiv/output.txt');
    predData = reshape(x, [128, numVideo]);
    y = textread('/Users/zhangchi8620/Codes/libsvm-3.18/tools/data_paper/msr/indiv/groundTrue.txt');
    
    trueData = repmat(y, [1 numVideo])

        
    for i = 1 : numVideo
        cmat1 = cmat1 + eachVideo(predData(:,i), trueData);
    end
    cmat1 = cmat1 / numVideo;
    
    %% batch mode
    cmat2 = zeros(16, 16);    
    x2 = textread('/Users/zhangchi8620/Codes/libsvm-3.18/tools/data_paper/msr/batch/output.txt');
    predData2 = reshape(x2, [64, numVideo]);
    y2 = textread('/Users/zhangchi8620/Codes/libsvm-3.18/tools/data_paper/msr/batch/groundTrue.txt');
    
    trueData2 = repmat(y2, [1 numVideo])
        
    for i = 1 : numVideo
        cmat2 = cmat2 + eachVideo(predData2(:,i), trueData2);
    end
    cmat2 = cmat2 / numVideo;
    
    cmat = (cmat1 + cmat2)/2;
    save('cmat.mat', 'cmat');    
    drawTestConfMat();
end

function cmat = eachVideo(predData, trueData)
    numAct = max(trueData);
    count = 1;
    for i = 1 : size(trueData,1)-1 
        if trueData(i) ~= trueData(i+1)
            endIdx(count) = i;
            count = count+1;
        end
        
    end
    
    startIdx = endIdx + 1;
    startIdx = [1, startIdx];
    endIdx = [endIdx, size(trueData,1)];
    startIdx, endIdx

    for i = 1 : numAct
        x = predData(startIdx(i):endIdx(i));
        label = trueData(startIdx(i));
        for act = 1 : numAct
            cmat(label,act) = length(find(x==act)) / length(x);
        end
    end
end

