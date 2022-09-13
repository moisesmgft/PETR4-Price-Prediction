function NN(data_filename, option)

    df = readtable(data_filename, VariableNamingRule='preserve');
    closing_price = table2array(df(:,5));

    input = [];
    for i=1:10:size(closing_price,1)
        if (i+9) > size(closing_price,1)
            break
        end
        input = [input closing_price(i:i+9)];
    end

    if (option=='A')||(option=='B')||(option=='D')
        %
        P=input(:,1:size(input,2));
        T=[closing_price(11:10:size(closing_price))]';
        
    elseif (option=='D')||(option=='E')||(option=='F')
        %
        P=input(:,1:size(input,2)-1);
        T=input(:,2:size(input,2));
        size(P)
        size(T)
    end

    if option=='A'
        %
        net = feedforwardnet(15);
        net = configure(net, P, T);

        %
        net.layers{1}.transferFcn='tansig';
        net.layers{2}.transferFcn='purelin';
        net.trainFcn='trainlm';
    end

    if option=='B'
        %
        net = feedforwardnet([10 10]);
        net = configure(net, P, T);

        %
        net.layers{1}.transferFcn='poslin';
        net.layers{2}.transferFcn='poslin';
        net.layers{3}.transferFcn='purelin';
        net.trainFcn='trainlm';

    end

    if option=='C'

    end

    if option=='D'
        %
        net = feedforwardnet(25);
        net = configure(net, P, T);

        %
        net.layers{1}.transferFcn='tansig';
        net.layers{2}.transferFcn='purelin';
        net.trainFcn='trainbr';

    end

    if option=='E'
        %
        net = feedforwardnet([25 25]);
        net = configure(net, P, T);

        %
        net.layers{1}.transferFcn='tansig';
        net.layers{2}.transferFcn='tansig';
        net.layers{3}.transferFcn='purelin';
        net.trainFcn='trainbr';

    end

    if option=='F'

    end

    % 
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio=0.70;
    net.divideParam.valRatio=0.15;
    net.divideParam.testRatio=0.15;

    % 
    net = init(net);

    % 
    net.trainParam.showWindow=true;
    net.performFcn='mse';
    net.trainParam.epochs=10^6;
    net.trainParam.time=240;
    net.trainParam.lr=0.2;
    net.trainParam.min_grad=10^-18;
    net.trainParam.max_fail=1000;
    
    [net, tr]=train(net,P,T);

end