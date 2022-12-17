%% ��������
opts = delimitedTextImportOptions("NumVariables", 10);

% ָ����Χ�ͷָ���
opts.DataLines = [5, 30];
opts.Delimiter = ",";

% ָ�������ƺ�����
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "VarName5", "Var6", "Var7", "Var8", "Var9", "Var10"];
opts.SelectedVariableNames = "VarName5";
opts.VariableTypes = ["string", "string", "string", "string", "double", "string", "string", "string", "string", "string"];

% ָ���ļ�������
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% ָ����������
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var6", "Var7", "Var8", "Var9", "Var10"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var6", "Var7", "Var8", "Var9", "Var10"], "EmptyFieldRule", "auto");

% ��������
Untitled = readtable("/Users/alexyang/Desktop/test/10.csv", opts);

clear opts

%% ����

number=Untitled;
number=table2array(number);


figure
subplot(2,2,1);
autocorr(number)
subplot(2,2,2);
parcorr(number)

%�������ǹ�ע��ARMA(p,q)��ͨ�׵�˵��PACF���һ���������⣨����ֵ�⣩��Lagֵ����pֵ��ACF���һ���������⣨����ֵ�⣩��Lagֵ����qֵ��

AR_Order =  1;
MA_Order =  4;


subplot(2,2,3);
plot(number);

xticklabels({1994:10:2034})


Mdl = arima(AR_Order, 1, MA_Order);  %�ڶ�������ֵΪ1����һ�ײ��
EstMdl = estimate(Mdl,number);

step = 10; %Ԥ�ⲽ��Ϊ10������Ԥ��ֱ��ʮ������������
[forData,YMSE] = forecast(EstMdl,step,'Y0',number);   %matlab2018�����°汾дΪPredict_Y(i+1) = forecast(EstMdl,1,'Y0',Y(1:i)); 
lower = forData - 1.96*sqrt(YMSE); %95������������
upper = forData + 1.96*sqrt(YMSE); %95������������


subplot(2,2,4);
plot(number,'Color',[.7,.7,.7]);
xticklabels({1994:10:2034})


hold on
h1 = plot(length(number):length(number)+step,[number(end);lower],'r:','LineWidth',2);
plot(length(number):length(number)+step,[number(end);upper],'r:','LineWidth',2)
h2 = plot(length(number):length(number)+step,[number(end);forData],'k','LineWidth',2);
legend([h1 h2],'95% confidence interval','Predictive value',...
	     'Location','NorthWest')
title('Forecast')
hold off