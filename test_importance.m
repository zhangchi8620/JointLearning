function result = test_importance(vector, value)
%     x = vector .* vector .* repmat(value',5, 1);
%     result = sqrt(sum(x, 2));
    x = vector .* repmat(value',size(vector, 1), 1);
    result = sqrt(sum(x.*x, 2));
%     result
%     figure;
    bar(result);
end