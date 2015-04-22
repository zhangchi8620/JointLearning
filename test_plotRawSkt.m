function test_plotRawSkt(a1, a2, s1, s2, e1, e2, path, mode)
   
%     select = [1, 8, 7, 6, 5, 2, 3, 4, 9,10,11, 12, 17, 18, 19, 20, 13, 14, 15, 16]';
    for action = a1 : a2
        for subject = s1 : s2
            for instance = e1 : e2;
                data = readSkt(action, subject, instance, path);
                if ~isempty(data)
%                     plotStat(data);
                    drawskt_raw(data, mode);
                end
            end
        end
    end
end