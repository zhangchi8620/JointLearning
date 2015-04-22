function result = test_calLoglik(Data, numFrame, numAct)
classifier = ones(1,16) * (-10000);
    Data = [[1:numFrame]; Data];
    for j = 1 : 16
        if (j~=3 && j~=5 && j~=7)
            load(['data/M_action_', int2str(j), '.mat']);
        
            for i = 1:size(M,2)
                loglik(i) = calLoglik(Data, M(i).Priors, M(i).Mu, M(i).Sigma, M(i).Pix);
            end
            classifier(j) = mean(loglik);
%             fprintf('Train act %d, avg %f\n', j, classifier(j));    

        end
    end
    result = find(classifier == max(classifier));    
    fprintf('classify as: %d\n', result);
end