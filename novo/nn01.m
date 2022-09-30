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

%
net = feedforwardnet(15);
net = configure(net, P, T);

net.divideFcn = 'dividerand';
net.divideParam.trainRatio=1;
net.divideParam.valRatio=0;
net.divideParam.testRatio=0;

net=init(net);

net.trainParam.showWindow=true;
net.layers{1}.transferFcn='tansig';
net.layers{2}.transferFcn='purelin';
net.trainFcn='trainlm';
net.performFcn='mse';
net.trainParam.epochs=10^6;
net.trainParam.time=240;
net.trainParam.lr=0.1;
net.trainParam.min_grad=10^-18;
net.trainParam.max_fail=10^3;

[net, ~]=train(net,P,T);

% Plotando
% Plot exceto dos 30 dias finais
plot(1:len-30, data(1:len-30), 'b')
xlabel('Dias')
ylabel('Preço')
title('Valor da PETR4')
grid
hold on

% Plot dos 30 últimos dias
plot(len-30:len, data(len-30:len), 'r')

% Simulando
PsA = net(input);
Ms = [data(1:10)' PsA];

plot(1:len, Ms, 'm')