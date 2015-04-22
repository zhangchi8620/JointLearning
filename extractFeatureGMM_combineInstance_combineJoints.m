% star features: distance and angle
% combine two videos, train all joints together
function file = extractFeatureGMM_combineInstance_combineJoints(a1, a2, s1, s2, e1, e2, mode)
%   select = [1, 8, 7, 6, 5, 2, 3, 4, 9,10,11, 12, 17, 18, 19, 20, 13, 14, 15, 16]';
%   select = [1, 8, 6, 4, 10, 12, 18, 20, 16, 14]';
%   select = [1, 8, 4, 12, 20, 16]';
%   select = [3, 8, 4, 12, 20, 16]';
%     selJoint = [8, 12, 16, 20]';
%     selJoint = [3, 4, 5, 8, 9, 12, 13, 16, 17, 20]';
%     refJoint = [0, 1, 3, 3, 5, 3,  9,  1, 13,  1, 17]';
%     refJoint = [1, 1, 1, 1, 1,  1,  1, 1,  1, 1]';
%     selJoint=[1  4     5     9     6     7    8     10   11    12     3     2     13   17   14     18    15    19    16    20]';
%     refJoint=[0  3     3     3     5     6    7     9    10    11     2     1     1    1    13     17    14    18    15    19]';
    selJoint = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]';
    refJoint = [1,1,2,3,3,5,6,7,3, 9,10,11, 1,13,14,15, 1,17,18,19]';

            
    nbStates = 10;    
    numFrame = 100;

    write2txt(selJoint, refJoint, nbStates, numFrame)    
    
    file = [];
    time = [1:numFrame]';
    numRow = 1;
    for action = a1 : a2
        for subject = s1 : s2
            oneSubject= [];
            for instance = e1 : e2;
                oneInstance=[];
                data = readSkt(action, subject, instance, mode);
                if (~isempty(data))
                    fprintf('action: %d, subject: %d, instance: %d\n', action, subject, instance);
%                     compareLinkVariance(data);
                    for j = 1 : size(refJoint)
                        if (refJoint(j) == 0)
                            pos = data(selJoint(j),:,:);
                        else
                            pos = data(selJoint(j),:,:) - data(refJoint(j),:,:);
                        end
                        pos = reshape(pos, [size(pos,2), size(pos,3)]);
                        pos = resizem(pos, [numFrame, size(data,3)]);
%                         mynorm = (sqrt(sum((pos').^2))) ;
%                         pos = pos ./ repmat(mynorm',[1,3]);
                        
                        if ((subject == 1 || subject == 7) && instance == 1)
                            ref = pos;
                        else
                            [w,pos]=DTW(pos,ref);
                        end
                        if j == 1
                            oneInstance = [time, pos]';
                        else
                            oneInstance = [oneInstance; pos'];      
                        end            
                    end
                    oneSubject =  [oneSubject,oneInstance]; 
                else
                    break;
                end
            end
            if (~isempty(oneSubject))
                row = encodeGMM(oneSubject, nbStates, numFrame, action, subject);
                row = [action, row];
                fprintf('\t .... Encode row %d\n', numRow);
                numRow = numRow + 1;
                file = [file; row];
            end
        end
    end
 end
   
function row = encodeGMM(Data, nbStates, numFrame, action, subject)    
    row = [];
    [Priors, Mu, Sigma, expData] = GMM(Data, nbStates, numFrame);
    [Y,I]=sort(Mu(1,:));
    B=Mu(:,I);
%     B = B(2:end, :);
%     B = [[1:nbStates];B(2:end,:)];
    feature = reshape(B, [1, numel(B)]);
    row = [row, feature]; 
%     drawskt_combineJoints(expData);
%     drawskt_expData(expData, selJoint, refJoint);
    save(['data/expData_',num2str(action), '_', num2str(subject), '.mat'], 'expData');

end