%% 変数の初期化
clear 
close all
clc
%% ノイズ除去＋座標軸調整済みのモデルを読み込み
load('group1_9_adjustment_model2.mat')

%% 径14mmの円板上トランスデューサをboolで配置する。
% トランスデューサの場所は以下の条件
% 
% 骨孔（直径1.6mm）の直上10mm
% 骨孔の中心座標 (x, y, z) = (172 + 100 = 272, 256, 100+108 = 208)
% モデルのx方向の先頭に何も存在しない空間を100程足して、距離10mmを確保
% トランスデューサの中心座標 (x, y, z) = (272 - 227 = 45, 256, 100 + 108 = 208)
% figure;
% imagesc(squeeze(adjustment_model(:, 256, :)))
adjustment_model = adjustment_model(1:350, 156:356, 1:250);

figure;
imagesc(squeeze(adjustment_model(:, 100, :)))
%% 
% CTの空間分解能は今回44μm
dx = 44e-6; 

[x_num, y_num, z_num] = size(adjustment_model);

% 今回のモデルは等方体
space_length = x_num * dx;

% 10mmは何セル分に相当するか
L5mm_num = round(5e-3/dx);
%% z軸方向に５０セル前後に追加
addtional_model_z = zeros(x_num, y_num, 50);

re_adjustment_model = cat(3, addtional_model_z, adjustment_model);
re_adjustment_model = cat(3, re_adjustment_model, addtional_model_z);

%% トランスデューサ（直径14 mm）を配置
% トランスデューサの中心座標 (x, y, z) = (172 - 114 = 58, 256, 108 + 50 = 158)
transducer_x = 172 - L5mm_num;
transducer_y = 100;
transducer_z = 158;

% 2値化モデル
is_model = re_adjustment_model ~= 0;
input_model = is_model;

% トランスデューサの直径
diameter = 5e-3;

for i = 1:y_num % 円板作成
    for k = 1:z_num

        if sqrt(((i - transducer_y))^2 + ((k - transducer_z))^2) < diameter/dx/2
            
           input_model(transducer_x, i, k) = 1;
        
        end
    end
end

% 骨部分を除去
input_model(transducer_x + 1:end, :, :) = 0;
input_model(:,:,transducer_z + round(diameter/2/dx):end) = 0;

% replace water
re_adjustment_model(re_adjustment_model < 1000) = 1e+3;

is_model = re_adjustment_model ~= 1e+3;

% 計算を少しでも軽くするために単精度に
model = single(re_adjustment_model);

%% モデルとして出力
outDir = "../";

outFile = fullfile(outDir, "rat-tibia-model_close3.mat");

save(outFile, "model", "is_model", "input_model", "-v7.3");  % 大きい配列なら -v7.3 推奨

% path = "../rat-tibia-model";
% 
% save(path, model, is_model, input_model)

%% 
figure;
imagesc(squeeze(input_model(:,100,:)))
