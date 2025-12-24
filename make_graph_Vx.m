%% 
clear
close all
clc
%% データ読み込み
loadPath = 'Voltage_result/onlyPLLA_1MHz/fai_90deg/';

list = dir(fullfile(loadPath, '*.csv'));
[row, column] = size(readmatrix("Voltage_result/onlyPLLA_1MHz/fai_90deg/Vx_rotate_00deg.csv"));

data = zeros(length(list), row);

for i = 1:length(list)
    fileName = list(i).name;
    data(i, :) = readmatrix(strcat(loadPath, fileName)).';
end

%% グラフ描画
maxVx = max(data,[], 2); % 各行ごとの最大値を取得
theta = 0:5:60;
figure(1);
plot(theta, maxVx,'-o','LineWidth',1.2);
saveas(gcf, "Vx_fai_90deg.svg")

