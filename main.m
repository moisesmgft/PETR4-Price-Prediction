clc
clear

[net, closing_price,P,T] = NN('PETR4.sa.csv','B','false');

xP=1:970;
xF=971:980;

plot(1:970,closing_price(1:970),'b',xF,closing_price(971:980),'r')
xlabel('Dias')
ylabel('Preço')
title('Valor da PETR4')
grid

% 6.2) Plotar resultados da Simulação

% hold on
% xS=1:980;
% PsA=closing_price(1:10);
% Ms=PsA;
% size(Ms)
% for i=1:98
%     PsD=sim(net,PsA);
%     size(PsD)
%     Ms=[Ms' PsD]';
%     PsA=PsD;
% end
% yS=[];
% for i=1:98
%     yS=[yS Ms(:,i)'];
% end
% size(yS)
% size(xS)
% plot(xS,yS,':m');

hold on
xS=1:980;
PsA=closing_price(1:10,1);
Ms=PsA;

for i=1:970
    PsD=sim(net,PsA);
    PsA = [PsA(2:10,1); PsD(1,1)];
    Ms = [Ms;PsD];
end

plot(xS, Ms, 'm')
