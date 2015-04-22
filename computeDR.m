function selectedData = computeDR(Data, threshold) 
    [nbPC, percent, eigenVector, eigenValue] = numPCA(Data, threshold);
    feature = test_importance(eigenVector, eigenValue);
    ordered = sortIdx(test_importance(eigenVector, eigenValue));
    topDim = 2;
    selectedData = [];
    for i = 1 : topDim
        selectedData = [selectedData; Data(ordered(i),:)];
    end
%     sortIdx(test_importance(eigenVector(:, 4:5), eigenValue(4:5)))

    %Compute the transformation matrix by keeping the first nbPC eigenvectors
%     A = eigenVector(:,1:nbPC);
%     B = eigenVector(:,nbPC+1:end);
%     
%     %Project the data in the latent space
%     DataProjPrin = A' * Data;
%     DataProjUnprin = B' * Data;

%     [nbVar,nbData] = size(Data);
%     
%     prinDim = zeros(1, nbPC);
%     
%     %Data has been Re-center in the normalize step
%     
%     %Extract the eigen components of the covariance matrix 
%     cMatrix = cov(Data');
%     [eigenVector,eigenValue] = eig(cMatrix);
%     
%     eigenVector = fliplr(eigenVector);
%     eigenValue = flipud(diag(eigenValue));
% 
%     
%     %Compute the transformation matrix by keeping the first nbPC eigenvectors
%     A = eigenVector(:,1:nbPC);
%     B = eigenVector(:,nbPC+1:end);
%     
%     %Project the data in the latent space
%     DataProjPrin = A' * Data;
%     DataProjUnprin = B' * Data;
%     
%     a = abs(A);
%     rest_a = abs(B);
% 
%          
%     imp = abs(eigenVector) .* repmat(eigenValue', [nbVar, 1]);
% 
%     all = sum(imp, 2);
%     rank_all = sortIdx(all);
%     
%     prinDim = rank_all(1:nbPC);
%     unprinDim = rank_all(nbPC+1:end);
%     
%     firstDims = sum(imp(:, 1:nbPC), 2);
%     rank_first = sortIdx(firstDims);
%     lastDims = sum(imp(:, nbPC+1:end), 2);
%     rank_last = sortIdx(lastDims);
%     
%   %  for i = 1: 5 - nbPC
%   %      unimpA(:, i) = B(:, i) / eig_value(nbPC+i)
%   %  end
%     impA = imp(:, 1:nbPC);
%     unimpA = imp(:, nbPC+1:end);
%     for i = 1 : 5
%        length_imp(i) = sqrt(sum(impA(i,:) .* impA(i,:)));
%        length_unimp(i) = sqrt(sum(unimpA(i,:) .* unimpA(i,:)));
%     end
%     sortIdx(length_imp');
%     sortIdx(length_unimp');
% 
% %    sortIdx(test_importance(eigenVector, eigenValue))
%     sortIdx(test_importance(eigenVector(:, 1:5), eigenValue(1:5)))
%     sortIdx(test_importance(eigenVector(:, 1:3), eigenValue(1:3)))
%     sortIdx(test_importance(eigenVector(:, 4:5), eigenValue(4:5)))
end

function rank = sortIdx(array)
    for i = 1 : size(array,1)
        rank(i) = find(array==max(array));
        array(rank(i)) = -1000;
    end
end