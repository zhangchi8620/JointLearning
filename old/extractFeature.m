% star features: distance and angle
function file = extractFeature(a1, a2, s1, s2, e1, e2, mode, M, N)
    select = [1, 8, 4, 12, 20, 16]';
    file = [];
    for action = a1 : a2
        for subject = s1 : s2
            for instance = e1 : e2;
                [action, subject, instance]
        
                data = drawskt(action, action, subject, subject, instance, instance, mode);
                if (~isempty(data))
                    dist = [];
                    angle = [];
                    numFrame = size(data, 2);
                    for frame = 1 : numFrame
                        for i = 1 : size(select)-1
                            tmp = [data(select(1),frame, :) - data(select(i+1), frame, :)];
                            d(i,:) = sqrt(sum((tmp.^2)));
                            p = data(select(1),frame,:) - data(select(i+1),frame,:);
                            if (i+2) <= size(select)  
                                t = i + 2; else t = 2; 
                            end
                            q = data(select(1),frame,:) - data(select(t),frame,:);
                            t1 = sum(p .* q);
                            t2 = sqrt(sum(p.^2)) * sqrt(sum(q.^2));
                            a(i,:) = acos(t1/t2);
                        end

                        dist = [dist, d];
                        angle = [angle, a];
                    end

%                     N = 20;
%                     M = 20;
                    for i = 1 : size(dist)
                        binDist(i,:) = hist(dist(i,:), N) / numFrame;
                        binAngle(i,:) = hist(angle(i,:), M) / numFrame;
                    end
                    feature = [reshape(binDist, 1, numel(binDist)), reshape(binAngle, 1, numel(binAngle))];
                    %feature = [reshape(binDist, 1, numel(binDist))];

                    libsvm = [action, feature];
                    file = [file; libsvm];
                end
            end
        end
    end
    
    %save([mode,'.mat'], 'file');
end