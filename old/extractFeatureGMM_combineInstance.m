% star features: distance and angle
function file = extractFeatureGMM_combineInstance(a1, a2, s1, s2, e1, e2, mode, M, N)
    %select = [1, 8, 7, 6, 5, 2, 3, 4, 9,10,11, 12, 17, 18, 19, 20, 13, 14, 15, 16]';
    select = [1, 8, 4, 12, 20, 16]';

    file = [];
    numFrame = 100;
    expData = zeros(4, 100, 5);
    for action = a1 : a2
        oneAct = [];
        row=[];
        for i = 2 : size(select)
            for subject = s1 : s2
                onePerson= [];
                    for instance = e1 : e2;
                        [action, subject, instance]
                        data = drawskt(action, action, subject, subject, instance, instance, mode);
                        if (~isempty(data))
                            % torso as reference point
                                oneJoint = data(select(i),:,:) - data(select(1),:,:);
                                x = oneJoint(1,:,1);
                                z = oneJoint(1,:,2);
                                y = oneJoint(1,:,3);
                                oneFile = [x;y;z];

                                oneFile = resizem(oneFile, [3, numFrame]);
                                if ((subject == 1 || subject == 7) && instance == 1)
                                    ref = oneFile;
                                else
                                    [w,oneFile]=DTW(oneFile,ref);
                                end
                                time = (1:size(oneFile, 2));
                                oneFile = [time; oneFile];
                                onePerson = [onePerson, oneFile];          
                        end
                    end
                oneAct = [oneAct, onePerson];
            end
            if (~isempty(data))
                [Priors, Mu, Sigma] = GMM(oneAct);
%                 tmp= regress(Priors, Mu, Sigma, oneAct);
%                 expData(:,:,i-1) = tmp;
                [Y,I]=sort(Mu(1,:));
                B=Mu(:,I);
                feature = reshape(B, [1, numel(B)]);
                row = [row, feature];                
            end
        end       
        if (~isempty(data))
            row = [action, row];
            file = [file; row];
        end
                        drawskt2(expData);

    end
    
    %save([mode,'.mat'], 'file');
end