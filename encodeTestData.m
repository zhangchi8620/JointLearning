% Combine #gap# instances and feed it into GMM
% Move by one instance after each GMM encoding. At the end, come back to
% the beginning.
% gap = 1, no rotation.

function file = encodeTestData(a1, a2, s1, s2, e1, e2, mode, gap, featureMode)
    nbStates = 10;    
    numFrame = 200;
    
    switch featureMode
        % relative to a single ref: torso (centralized)    
        case 'centerStar'
            selJoint = [4, 8, 12, 16, 20]';
            refJoint = ones(size(selJoint));

        case 'centerAll'
            selJoint = [1:20]';
            refJoint = ones(size(selJoint));

        % relateive to adjacent joints (adjacent)    
        case 'adjacent'
            selJoint = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]';
            refJoint = [1,1,2,3,3,5,6,7,3, 9,10,11, 1,13,14,15, 1,17,18,19]';

        % relative to torso area (Tmode)
        case 'Tmode'
            selJoint = [4, 8, 12, 16, 20]';
            refJoint = [3, 5,  9, 13, 17]';
        otherwise
             error('Wrong feature mode.')
    end



    % write configuration to file
    write2txt(selJoint, refJoint, nbStates, numFrame)    
    
    file = [];
    numRow = 1;
    for action = a1 : a2
        videos = [];
        idx = 1;
        
        for subject = s1 : s2
            for instance = e1 : e2;
                data = readSkt(action, subject, instance, mode);                
                if (~isempty(data))
                    videos(idx).rawData = data;
                    videos(idx).action = action;
                    % Centralize all 20 joints relative to torso
                    centeredData = centerData(videos(idx).rawData);
                    
                    % Compute reference of adjacent joint
                    jointDistData = calJointDist(centeredData, selJoint, refJoint);
                    videos(idx).selCenteredData = jointDistData;
                    idx = idx + 1;                    
                end
            end  
        end        
        numInstance = size(videos,2);
        if numInstance ~= 0
            fprintf('>>> Action %d, %d instances\n', action, numInstance);
            for i = 1 : numInstance
                inVideos = videos(1:gap);
                inData = align(inVideos, numFrame, 'dimension');
                [feature, M] = encodeGMM(inData,nbStates, numFrame, action, subject);
                row = [action, feature];
                file = [file; row];

                % rotate videos
                tmp = videos(1);
                videos = [videos(2:end), tmp];                                  
            end                 
        end
    end    
end

function result = centerData(data)
    numJoint = size(data,1);
    torso = data(1,:,:);
    result = data - repmat(torso, [numJoint,1]);
end
   
function result = calJointDist(data, selJoint, refJoint)
    numPos = size(selJoint,1);
    for j = 1 : numPos
        x = data(selJoint(j),:,:);
        y = data(refJoint(j),:,:);
        result(j,:,:) =  x - y;
    end
end
