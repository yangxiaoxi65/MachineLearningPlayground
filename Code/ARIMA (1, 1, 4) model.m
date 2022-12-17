%% 导入数据
opts = delimitedTextImportOptions("NumVariables", 10);

% 指定范围和分隔符
opts.DataLines = [5, 30];
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "VarName5", "Var6", "Var7", "Var8", "Var9", "Var10"];
opts.SelectedVariableNames = "VarName5";
opts.VariableTypes = ["string", "string", "string", "string", "double", "string", "string", "string", "string", "string"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 指定变量属性
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var6", "Var7", "Var8", "Var9", "Var10"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var6", "Var7", "Var8", "Var9", "Var10"], "EmptyFieldRule", "auto");

% 导入数据
Untitled = readtable("/Users/alexyang/Desktop/test/10.csv", opts);

clear opts

%% 分析

number=Untitled;
number=table2array(number);


figure
subplot(2,2,1);
autocorr(number)
subplot(2,2,2);
parcorr(number)

%对于我们关注的ARMA(p,q)，通俗地说，PACF最后一个在蓝线外（即阈值外）的Lag值就是p值；ACF最后一个在蓝线外（即阈值外）的Lag值就是q值。

AR_Order =  1;
MA_Order =  4;


subplot(2,2,3);
plot(number);

xticklabels({1994:10:2034})


Mdl = arima(AR_Order, 1, MA_Order);  %第二个变量值为1，即一阶差分
EstMdl = estimate(Mdl,number);

step = 10; %预测步数为10，代表预测直到十年后的旅行人数
[forData,YMSE] = forecast(EstMdl,step,'Y0',number);   %matlab2018及以下版本写为Predict_Y(i+1) = forecast(EstMdl,1,'Y0',Y(1:i)); 
lower = forData - 1.96*sqrt(YMSE); %95置信区间下限
upper = forData + 1.96*sqrt(YMSE); %95置信区间上限


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