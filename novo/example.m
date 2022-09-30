clc
clear

table = readtable('PETR4.sa.csv', VariableNamingRule='preserve');
closing_price = table2array(table(:,5));

% normalize data
normalized_data = (closing_price - min(closing_price))/(max(closing_price)-min(closing_price));

% choose between normalized data or original data
data = normalized_data;

% reshaping the input data
% col = floor(size(data)/10);
% col = col(1);
% input = reshape(data(1:10*col), [10, col]);

%
% P = input;
% T = data(11:10:10*col+1)';

% POR FAVOR
len = size(data);
len = len(1);

input = [];
for i=1:(len-10)
    input = [input data(i:i+9)];
end
output=data(11:len)';

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
net.trainParam.lr=0.2;
net.trainParam.min_grad=10^-18;
net.trainParam.max_fail=10^3;

[net, ~]=train(net,P,T);

% Plotando
plot(1:len, data(1:len), 'b')
xlabel('Dias')
ylabel('Preço')
title('Valor da PETR4')
grid
hold on

% Simulando
PsA = data(1:10);
Ms = PsA;

for i=1:970
    PsD = net(PsA);
    PsA = [PsA(2:10,1); PsD(1,1)];
    Ms = [Ms;PsD];
end

y = net(P);
Ms = [data(1:10); y];

plot(1:980, Ms, 'm')