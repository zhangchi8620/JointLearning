% star features: distance and angle
% combine two videos, train all joints together
function file = extractFeatureGMM_combineInstance_combineJoints_Tmode(a1, a2, s1, s2, e1, e2, mode)
%   select = [1, 8, 7, 6, 5, 2, 3, 4, 9,10,11, 12, 17, 18, 19, 20, 13, 14, 15, 16]';
%   select = [1, 8, 6, 4, 10, 12, 18, 20, 16, 14]';
%   select = [1, 8, 4, 12, 20, 16]';
%   select = [3, 8, 4, 12, 20, 16]';
%     selJoint = [8, 12, 16, 20]';
    selJoint = [3, 4, 5, 8, 9, 12, 13, 16, 17, 20]';
    refJoint = [1, 3, 3, 5, 3,  9,  1, 13,  1, 17]';
%     selJoint = [1, 8, 4, 12,20, 16]';
%     refJoint = [0, 1, 1, 1,  1,  1]';
%     selJoint=[1  4     5     9     6     7    8     10   11    12     3     2     13   17   14     18    15    19    16    20]';
%     refJoint=[0  3     3     3     5     6    7     9    10    11     2     1     1    1    13     17    14    18    15    19]';

    nbStates = 7;    
    numFrame = 100;

    write2txt(selJoint, refJoint, nbStates, numFrame)    
    
    file = [];
    time = [1:numFrame];
    numRow = 1;
    for action = a1 : a2
        Data = [];
        for subject = s1 : s2
            oneSubject= [];
            for instance = e1 : e2;
                oneInstance=[];
                data = readSkt(action, subject, instance, mode);
                % center all videos to torso=[0,0,0]
                for j = 1:size(data)
                    data(j,:,:) = data(j,:,:) - data(1,:,:);
                end
%                 torso = data(1,:,:);
%                 torso = reshape(torso, [size(data,2), size(data,3)]);
%                 if mod(instance, 2) == 0
%                     plot3(torso(:,1), torso(:,2), torso(:,3)); hold on; grid on;
%                 else
%                     plot3(torso(:,1), torso(:,2), torso(:,3), 'r'); hold on; grid on;
%                 end
%                 plot3(0,0,0,'r*','MarkerSize', 20);
                if (~isempty(data))
                    fprintf('action: %d, subject: %d, instance: %d\n', action, subject, instance);
%                   compareLinkVariance(data);

                    % compute T-mode
                    for j = 1 : size(refJoint)
                        pos = data(selJoint(j),:,:) - data(refJoint(j),:,:);
                        pos = reshape(pos, [size(pos,2), size(pos,3)]);
                        pos = resizem(pos, [numFrame, size(data,3)]);
                        pos = pos';
%                         mynorm = (sqrt(sum((pos').^2))) ;
%                         pos = pos ./ repmat(mynorm',[1,3]);                        
                        oneInstance = [oneInstance; pos];  
                    end
                    oneSubject =  [oneSubject,oneInstance];
                end
            end
            if ~isempty(oneSubject)
                Data = [repmat(time, [1, size(oneSubject,2)/numFrame]); oneSubject];
                fprintf('Data size: %d, %d\n', size(Data));
           
                feature = encodeGMM(Data, nbStates, numFrame, action, subject);
                row = [action, feature];
                fprintf('>>> Encode row %d\n', numRow);
                numRow = numRow + 1;
                file = [file; row];
            end
        end
    end
end 
function feature = encodeGMM(Data, nbStates, numFrame, action, subject)    
    [Priors, Mu, Sigma, expData] = GMM(Data, nbStates, numFrame);
    [Y,I]=sort(Mu(1,:));
    B=Mu(:,I);
%     B = B(2:end, :);
%     B = [[1:nbStates];B(2:end,:)];
    feature = reshape(B, [1, numel(B)]);
%     drawskt_combineJoints(expData);
%     drawskt_expData(expData, selJoint, refJoint);
%     save(['data/expData_',num2str(action), '_', num2str(subject), '.mat'], 'expData');

end