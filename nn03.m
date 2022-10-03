clc
clear

% Read data from file
table = readtable('PETR4.sa.csv', VariableNamingRule='preserve');
closing_price = table2array(table(:,5));

% normalize data
normalized_data = (closing_price - min(closing_price))/(max(closing_price)-min(closing_price));

% choose between normalized data or original data
data = closing_price;

% Narmax
len = size(data);
len = len(1);

input = [];
for i=1:(len-10)
    input = [input data(i:i+9)];
end
output=data(11:len)';

% last 30 days used for testing
P = input(:,1:len-40);
T = output(1:len-40);

% Configure neural network
net = feedforwardnet([15 15]);
net = configure(net, P, T);

net.divideFcn = 'dividerand';
net.divideParam.trainRatio=1;
net.divideParam.valRatio=0;
net.divideParam.testRatio=0;

net=init(net);

net.trainParam.showWindow=true;
net.layers{1}.transferFcn='tansig';
net.layers{2}.transferFcn='poslin';
net.layers{3}.transferFcn='purelin';
net.trainFcn='trainrp';
net.performFcn='mse';
net.trainParam.epochs=10^6;
net.trainParam.time=240;
net.trainParam.lr=0.001;
net.trainParam.min_grad=10^-18;
net.trainParam.max_fail=10^3;

% Train NN
[net, ~]=train(net,P,T);

% Simulating closing price
PsA = net(input);
Ms = [data(1:10)' PsA];

% Plot
% Plot real data, except the last 30 days
plot(1:len-30, data(1:len-30), 'b')
xlabel('Dias', 'FontSize', 12)
ylabel('Preço', 'FontSize', 12)
title('Valor da PETR4', 'FontSize', 12)
grid
hold on

% Plot the last 30 days
plot(len-30:len, data(len-30:len), 'r')

% Plot simulation
plot(1:len, Ms, 'm')

% Add legends
legend('Fechamento real - Treinamento', 'Fechamento real - Validação', 'Previsão', 'FontSize', 12);

% Adjusting figure size
fig=gcf;
fig.Position(3:4)=[1280,400];