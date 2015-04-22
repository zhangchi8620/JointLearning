function test_calRawVariance(a1, a2, s1, s2, e1, e2, path)

    for action = a1 : a2
            for subject = s1 : s2
                for instance = e1 : e2;
                    data = readSkt(action, subject, instance, path);
                    if ~isempty(data)
                        plotStat(data);
                    end
                end
            end
    end
end
   
function plotStat(data)
    figure;
    rightShoulder = cal_dist(data,3,5); 
    leftShoulder = cal_dist(data,3,9);
    plot(rightShoulder); hold on; plot(leftShoulder, 'r');
    
    neck = cal_dist(data,4,3);
    chest = cal_dist(data,3,2);
    belly = cal_dist(data,2,1);
    plot(neck,'g-.'); hold on; plot(chest, 'go');plot(belly, 'g-*');
    
    legend('rightShoulder', 'leftShoulder', 'neck', 'chest', 'belly');
    
    upperRightArm = cal_dist(data,5,6);
    upperLeftArm = cal_dist(data,9,10);
    plot(upperRightArm,'o'); hold on; plot(upperLeftArm, 'ro-');
    
    lowerRightArm = cal_dist(data,6,7);
    lowerLeftArm = cal_dist(data,10,11);
    plot(lowerRightArm,'*'); hold on; plot(lowerLeftArm, 'r*');
    
    rightWrist = cal_dist(data,7,8);
    leftWrist = cal_dist(data,11,12);
    plot(rightWrist,'-.'); hold on; plot(leftWrist, 'r-.');
    
    meanRightArm = [mean(rightShoulder), mean(upperRightArm), mean(lowerRightArm),  mean(rightWrist)]
    stdRightArm = [std(rightShoulder), std(upperRightArm), std(lowerRightArm),  std(rightWrist)]
    meanLeftArm = [mean(leftShoulder), mean(upperLeftArm), mean(lowerLeftArm),  mean(leftWrist)]
    stdLeftArm = [std(leftShoulder), std(upperLeftArm), std(lowerLeftArm),  std(leftWrist)]
    meanCenter = [mean(neck),mean(chest), mean(belly);std(neck),std(chest), std(belly) ]
    legend('rightShoulder', 'leftShoulder', 'neck', 'chest', 'belly', 'upperRightArm', 'upperLeftArm', 'lowerRightArm', 'lowerLeftArm', 'rightWrist', 'leftWrist');

    
end

function dist = cal_dist(data,j1, j2)    
    d = data(j1, :,:) - data(j2, :,:);
    d = reshape(d, [size(d,2), size(d,3)]);
    dist = sqrt(sum (d .^ 2, 2));
end