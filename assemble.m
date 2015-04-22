% Combine #gap# instances and feed it into GMM
% Move by one instance after each GMM encoding. At the end, come back to
% the beginning.
% gap = 1, no rotation.

function output = assemble(a1, a2, s1, s2, e1, e2, path, assembleMode, gap, jointMode)
    disp('Assembling...');
    global nbStates numFrame selJoint refJoint selBone refBone
     
    output = [];
    numRow = 1;
    idxAct = 1;
    for action = a1 : a2
        videos = [];
        idxSub = 1;
        
        for subject = s1 : s2
            for instance = e1 : e2;
                data = readSkt(action, subject, instance, path);    
%                 drawskt_rawData(data, 'all', 0);
                if (~isempty(data))
                    videos(idxSub).rawData = data;
                    videos(idxSub).action = action;
                    videos(idxSub).subject = subject;
                    
                    % Centralize all 20 joint position relative to torso (root)
                    centeredJointPos = centerData(videos(idxSub).rawData);
                    
                    % Compute bone position (vector of two adjacent joints)
                    boneVector = calVector(centeredJointPos, selJoint, refJoint);
                                       
                    % Compute joint angle (vector of two adjacent bone vectors)
                    jointAngle = calVector(boneVector, selBone, refBone);
                    
                    % Compute nao joint
                    theta = naoJoint(centeredJointPos);
                    
                    videos(idxSub).data = theta;
                    idxSub = idxSub + 1;  
                end
            end  
        end      
        
        
        numInstance = size(videos,2);
        if numInstance ~= 0
            fprintf('\t Action %d, total instance number %d\n', action, numInstance);            
            switch assembleMode
                case 'combineInstance'
                    if ndims(videos(1).data) == 3   %boneVector or jointAngle
                        % normalize data                   
                        videos = normalizeData(videos);                      
                        subArray = extractfield(videos,'subject');
                        for j = min(subArray) : max(subArray)
                            t = find(subArray==j);
                            inVideos = videos(t(1):t(end));

                            inData = align(inVideos, numFrame, 'dimension'); 

                            output(idxAct).action = action;
                            output(idxAct).data = inData;
                            idxAct = idxAct + 1;
                        end
                    else  %naoJoint
                        subArray = extractfield(videos,'subject');
                        for j = min(subArray) : max(subArray)
                            t = find(subArray==j);
                            inVideos = videos(t(1):t(end));
                            
                            inData = align_2D(inVideos, numFrame); 

                            output(idxAct).action = action;
                            output(idxAct).data = inData;
                            idxAct = idxAct + 1;
                        end
                    end
                    
                case 'rotate'
                    % ??? not finished
                     for i = 1 : numInstance
                        inVideos = videos(1:gap);
                        inData = align(inVideos, numFrame, 'dimension');
                        output(idxAct).action = action;
                        output(idxAct).data = inData;
                        
                        % rotate videos
                        tmp = videos(1);
                        videos = [videos(2:end), tmp];
                     end
                case 'exhaust'
                case 'no_comb'
                    if ndims(videos(1).data) == 3   %boneVector or jointAngle
                        % normalize data                   
                        inVideos = normalizeData(videos);  
                        for i = 1 : numInstance
                            fprintf('\t\t instance %d\n', i);
                            % align data (not truely align, but resize to numFrame)
                            inData = align(inVideos(i), numFrame, 'dimension');
                            output(idxAct).action = action;                                                    
                            output(idxAct).data = inData;
                            idxAct = idxAct + 1;                        
                        end
                    else  %naoJoint
                        for i = 1 : numInstance
                            fprintf('\t\t instance %d\n', i);
                            % align data (not truely align, but resize to numFrame)
                            inData = imresize(videos(i).data, [size(videos(i).data, 1) numFrame]);                            
%                             inData = align_2D(videos(i), numFrame);
                            output(idxAct).action = action;                                                    
                            output(idxAct).data = inData;
                            idxAct = idxAct + 1;                        
                        end                        
                    end
                    % old incremental, seems wrong
%                 case 'incremental'
%                     % normalize data                   
%                     videos = normalizeData(videos);                      
%                     subArray = extractfield(videos,'action');
%                     for j = min(subArray) : max(subArray)
%                         t = find(subArray==j);
%                         inVideos = videos(t(1):t(end));
%                         inData = align_2D(inVideos, numFrame); 
% 
%                         output(idxAct).action = action;
%                         output(idxAct).data = inData;
%                         idxAct = idxAct + 1;
%                     end
                    case 'incremental'
                    % normalize data                   
%                     videos = normalizeData(videos);                      
                    for j = 1:size(videos,2)
                        inVideos = videos(1:j);
                        inData = align_2D(inVideos, numFrame); 

                        output(idxAct).action = action;
                        output(idxAct).data = inData;
                        idxAct = idxAct + 1;
                    end
                    
            end
        end
    end    
end

function result = centerData(data)
    numJoint = size(data,1);
    torso = data(1,:,:);
    result = data - repmat(torso, [numJoint,1]);
end
   
function result = calVector(data, selJoint, refJoint)
    numPos = size(selJoint,1);
    for j = 1 : numPos
        x = data(selJoint(j),:,:);
        y = data(refJoint(j),:,:);
        result(j,:,:) =  x - y;
    end
end

% function data = normalize(data)
%     [numJoint, numFrame] = size(data);    
%     for i = 1 : numFrame
%         for j = 1 : 3 : numJoint 
%             v = data(j:j+2, i);
%             if (norm(v) == 0)
%                 data(j:j+2, i) = [0,0,0]';
%             else
%                 data(j:j+2, i) = v / norm(v);
%             end
%         end
%     end
% end

function videos = normalizeData(videos)
    for i = 1 : size(videos, 2)
        tmp = videos(i).data;
        t = permute(tmp, [1,3,2]);
        for f = 1 : size(t, 3)
            t(:,:,f) = normr(t(:,:,f));
        end
        videos(i).data = permute(t, [1,3,2]);
    end    
end

function theta = naoJoint(data)
    X = data(:,:,1);
    Y = data(:,:,2);
    Z = data(:,:,3);
    %RArm
    rshoulder.x = X(5,:);
    rshoulder.y = Y(5,:);
    rshoulder.z = Z(5,:);

    relbow.x = X(6,:);
    relbow.y = Y(6,:);
    relbow.z = Z(6,:);

    rhand.x = X(7,:);
    rhand.y = Y(7,:);
    rhand.z = Z(7,:);

%     non = zeros(1, size(rshoulder.x, 2));

    theta = asin((rshoulder.z - relbow.z) ./ dist(rshoulder, relbow));
    theta =[theta; -asin((rshoulder.x - relbow.x) ./ dist(rshoulder, relbow))];
    theta =[theta; -asin((relbow.x - rhand.x) ./ dist(relbow, rhand))];
    theta =[theta; acos(dist(rshoulder, rhand).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rhand).^2)];
    %triangle - Chi
%     theta =[theta; acos((dist(rshoulder, rhand).^2 - dist(rshoulder, relbow).^2 - dist(relbow,rhand).^2)./ ...
%         (2*dist(rshoulder,relbow).*dist(relbow,rhand)) ...
%         )];

%     theta = [theta; [non;non]];

    %LArm
    lshoulder.x = X(9,:);
    lshoulder.y = Y(9,:);
    lshoulder.z = Z(9,:);

    lelbow.x = X(10,:);
    lelbow.y = Y(10,:);
    lelbow.z = Z(10,:);

    lhand.x = X(11,:);
    lhand.y = Y(11,:);
    lhand.z = Z(11,:);

    theta =[theta; asin((lshoulder.z - lelbow.z) ./ dist(lshoulder, lelbow))];
    theta =[theta; -asin((lshoulder.x - lelbow.x) ./ dist(lshoulder, lelbow))];
    theta =[theta; -asin((lelbow.x - lhand.x) ./ dist(lelbow, lhand))];
    theta =[theta; -acos(dist(lshoulder, lhand).^2 - dist(lshoulder, lelbow).^2 - dist(lelbow,lhand).^2)];
%     theta =[theta; acos((dist(lshoulder, lhand).^2 - dist(lshoulder, lelbow).^2 - dist(lelbow,lhand).^2)./ ...
%         (2*dist(lshoulder,lelbow).*dist(lelbow,lhand)) ...
%         )];
    
    
%     theta =[theta; [non;non]];

    %RLeg
    rhip.x = X(13,:);
    rhip.y = Y(13,:);
    rhip.z = Z(13,:);

    rknee.x = X(14,:);
    rknee.y = Y(14,:);
    rknee.z = Z(14,:);

    rfoot.x = X(15,:);
    rfoot.y = Y(15,:);
    rfoot.z = Z(15,:);

%     theta =[theta; non];
    theta =[theta; asin((rhip.y - rknee.y) ./ dist(rhip, rknee))];
    theta =[theta; asin((rhip.x - rknee.x) ./ dist(rhip, rknee))];
    theta =[theta; asin((rknee.x - rfoot.x) ./ dist(rknee, rfoot))];
%     theta =[theta; [non;non]];

    %LLeg
    lhip.x = X(17,:);
    lhip.y = Y(17,:);
    lhip.z = Z(17,:);

    lknee.x = X(18,:);
    lknee.y = Y(18,:);
    lknee.z = Z(18,:);

    lfoot.x = X(19,:);
    lfoot.y = Y(19,:);
    lfoot.z = Z(19,:);

%     theta =[theta; non];
    theta =[theta; asin((lhip.y - lknee.y) ./ dist(lhip, lknee))];
    theta =[theta; asin((lhip.x - lknee.x) ./ dist(lhip, lknee))];
    theta =[theta; asin((lknee.x - lfoot.x) ./ dist(lknee, lfoot))];
%     theta =[theta; [non;non]];
end

function d = dist(p1, p2)
    d = sqrt(((p1.x - p2.x) .^ 2 + (p1.y - p2.y) .^2 + (p1.z - p2.z) .^2));
end

function result = align_2D(videos, numFrame)
    result = [];
    ref = videos(1).data;
    numJoint = size(ref, 1);    
    ref = imresize(ref, [numJoint numFrame]);
    
    for e = 2 : size(videos, 2)
        new = [];
        v = videos(e).data;
        for j = 1 : numJoint
                dim = ref(j,:);
                tmp = [v(j,:)];
                [w, n] = DTW(tmp', dim');
%                         figure;
%                         plot(n);hold on;plot(dim, 'r'); plot(tmp, 'g');
%                         new =[new; dim];
                new = [new; n'];            
        end
        result = [result, new];        
    end
    result=[ref, result];

end