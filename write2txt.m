function write2txt()
    global nbStates numFrame selJoint refJoint DR

    disp('***********************')
    disp('selJoint'); disp(selJoint');
    disp('refJoint'); disp(refJoint');
    fprintf('nbStates:\t%d,\nnumFrame:\t%d,\nnumPos:\t\t%d,\nDR:\t\t%d\n', nbStates, numFrame, size(selJoint,1), DR);
    disp('***********************')

    fileID = fopen('config.txt','w');
    fprintf(fileID, 'selJoint: ');
    for i = 1 : size(selJoint,1)
        fprintf(fileID,'%d\t',selJoint(i));
    end
    fprintf(fileID, '\nrefJoint: ');
    for i = 1 : size(selJoint,1)
        fprintf(fileID,'%d\t',refJoint(i));
    end
    
    fprintf(fileID, '\n# of GMM:\t%d\n# of Frame:\t%d\nDR:\t\t\t%d\n', nbStates, numFrame, DR);
    fclose(fileID);
end