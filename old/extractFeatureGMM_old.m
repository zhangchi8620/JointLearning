% star features: distance and angle
function file = extractFeatureGMM(a1, a2, s1, s2, e1, e2, mode, M, N)
    %select = [1, 8, 7, 6, 5, 2, 3, 4, 9,10,11, 12, 17, 18, 19, 20, 13, 14, 15, 16]';
    select = [1, 8, 4, 12, 20, 16]';
    
    file = [];
    numFrame = 100;
    for action = a1 : a2
        for subject = s1 : s2
            row=[];
            Data= [];
            for i = 2 : size(select)
                for instance = e1 : e2;
                    [action, subject, instance]
                    data = drawskt(action, action, subject, subject, instance, instance, mode);

                    if (~isempty(data))
                        % torso as reference point
                            oneJoint = data(select(i),:,:) - data(select(1),:,:);
    %                     figure;
    %                     plot3(0,0,0,'r*'); hold all;
                            x = oneJoint(1,:,1);
                            z = oneJoint(1,:,2);
                            y = oneJoint(1,:,3);
                            person = [x;y;z];
    %                       plot3(person(1,:), person(2,:), person(3,:)); hold all;
    %                       legend('torso','right hand', 'head', 'left hand', 'left foot', 'right foot');
    %                       grid on;
                            person = resizem(person, [3, numFrame]);
                            time = (1:size(person, 2));
                            person = [time; person];
                            Data = [Data, person];          
                    end
                end
                if (~isempty(data))
                    [Priors, Mu, Sigma] = GMM(Data);
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
        end
    end
    
    %save([mode,'.mat'], 'file');
end