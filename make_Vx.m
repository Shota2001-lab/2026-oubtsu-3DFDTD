%% 変数初期化
clc
clear
close all
%% データ読み込み
load Result/onlyPLLA/fai_45deg/Ex_rotate55deg_rate0.mat

%% データ加工（各レイヤーのExを加算）

[row, column] = size(dataEx);
numLayer = 5; % PLLAの層は今回五層（10μ×5）
Vx = zeros(row, 1); % 電位初期化
for i = 1:numLayer
    Ex = dataEx(:, i + 1);
    Vx = Vx + Ex;
end

%% 表示
figure(1);
plot(Vx)
writematrix(Vx, "Voltage_result/onlyPLLA_1MHz/fai_45deg/Vx_rotate_55deg.csv")