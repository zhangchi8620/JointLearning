% star features: vectors
function file = extractFeature3(a1, a2, s1, s2, e1, e2, mode, M, N)
    select = [1, 8, 4, 12, 20, 16]';
    
    file = [];

    for action = a1 : a2
        for subject = s1 : s2
            for instance = e1 : e2;
                [action, subject, instance]
                % one single file(instance)
                data = drawskt(action, action, subject, subject, instance, instance, mode);
                if (~isempty(data))
                    vec = [];        
                    numFrame = size(data, 2);
                    for frame = 1 : numFrame
                        oneVec = [];
                        for i = 1 : size(select)-1
                            tmp = [data(select(1),frame, :) - data(select(i+1), frame, :)];
                            tmp = squeeze(tmp);
                            oneVec = [oneVec; tmp];
                        end
                        vec = [vec, oneVec];
                    end
                    
                    for i = 1 : size(vec)
                        binVec(i,:) = hist(vec(i,:), N) / numFrame;
                    end
                    feature = [reshape(binVec, 1, numel(binVec))];
                    %feature = [reshape(binDist, 1, numel(binDist))];

                    libsvm = [action, feature];
                    file = [file; libsvm];
                end
            end
        end
    end
    
    save([mode,'.mat'], 'file');
end