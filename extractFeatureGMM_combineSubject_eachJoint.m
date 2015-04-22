% norm each subject, then combine
function file = extractFeatureGMM_combineSubject_eachJoint(a1, a2, s1, s2, e1, e2, mode, M, N)
    %select = [1, 8, 7, 6, 5, 2, 3, 4, 9,10,11, 12, 17, 18, 19, 20, 13, 14, 15, 16]';
    select = [1, 8, 4, 12, 20, 16]';
    file = [];
    numFrame = 100;
    time = [1:numFrame]';
    numRow = 1;
    for action = a1 : a2
        oneAction = [];
        for subject = s1 : s2
%             oneSubject= [];
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
                        oneInstance(j,:,:,:) = [time, pos];   
                                                
                    end
                    oneAction =  cat(2,oneAction,oneInstance); 
                else
                    break;
                end
            end  
        end
        if (~isempty(data))
            row = encodeGMM(oneAction);
            row = [action, row];
            fprintf('>>> Encode row %d\n', numRow);
            numRow = numRow + 1;
            file = [file; row];
        end
            
    end
 end
   
function row = encodeGMM(Data)
    numJoint = size(Data,1);
    
    row = [];
    expAll = zeros(4, 100, numJoint);
    for j = 1:numJoint
        tmp = Data(j,:,:);
        tmp = reshape(tmp, [size(tmp,2), size(tmp,3)]);
        [Priors, Mu, Sigma, expData] = GMM(tmp');
        [Y,I]=sort(Mu(1,:));
        B=Mu(:,I);
        feature = reshape(B, [1, numel(B)]);
        row = [row, feature]; 
        expAll(:,:,j) = expData;
    end
%         drawskt2(expAll);

end