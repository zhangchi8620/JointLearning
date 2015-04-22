function test_plot_Mu()
    load('train.mat');

    for i = 1 : size(file,1)
        switch file(i,1)
            case 1
                plotFile(file(i,:), 'b'); hold on;
            case 2
                plotFile(file(i,:), 'r'); hold on;                
            case 3
                plotFile(file(i,:), 'g'); hold on;                
        end
    end
end


function plotFile(inData, color)
    data = inData(2:end);
    
    time = find(data>1);
    joint = find(data<=1);
    y = data(time);
    tmp = data(joint);
    x = tmp(1:30:end);
    plot(y, x(1:10), [color,'*']);
end