% star features: distance and angle
% seperate each video, train all joints together
function file = extractFeatureGMM_eachInstance_combineJoints(a1, a2, s1, s2, e1, e2, mode, M, N)
    %select = [1, 8, 7, 6, 5, 2, 3, 4, 9,10,11, 12, 17, 18, 19, 20, 13, 14, 15, 16]';
    select = [1, 8, 4, 12, 20, 16]';
    file = [];
    numFrame = 100;
    time = [1:numFrame]';
    numRow = 1;
    for action = a1 : a2
        for subject = s1 : s2
            oneSubject= [];
            for instance = e1 : e2;
                oneInstance=[];
                data = drawskt(action, action, subject, subject, instance, instance, mode);
                if (~isempty(data))
                    fprintf('action: %d, subject: %d, instance: %d\n', action, subject, instance);
                    for j = 1 : size(select)-1
                        pos = data(select(j+1),:,:) - data(1,:,:);
                        pos = reshape(pos, [size(pos,2), size(pos,3)]);
                        pos = resizem(pos, [numFrame, size(data,3)]);
                        mynorm = (sqrt(sum((pos').^2))) ;
                        pos = pos ./ repmat(mynorm',[1,3]);
                        
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
                    row = encodeGMM(oneInstance);
                    row = [action, row];
                    fprintf('>>> Encode row %d\n', numRow);
                    numRow = numRow + 1;
                    file = [file; row];
%                     oneSubject =  [oneSubject,oneInstance]; 
                else
                    break;
                end
            end
            
        end
    end
 end
   
function row = encodeGMM(Data)    
    row = [];
    nbStates = 10;    
    [Priors, Mu, Sigma, expData] = GMM_DR(Data, nbStates);
    [Y,I]=sort(Mu(1,:));
    B=Mu(:,I);
    feature = reshape(B, [1, numel(B)]);
    row = [row, feature]; 
%         plot3(expData(2,:), expData(3,:), expData(4,:), '-.'); hold on; 
%         plot3(expData(2,1), expData(3,1), expData(4,1), 'r*'); grid on;
%          drawskt_combineJoints(expData);
    

end