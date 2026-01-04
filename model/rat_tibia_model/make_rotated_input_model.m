%% 変数の初期化
clear 
close all
clc
%% ノイズ除去＋座標軸調整済みのモデルを読み込み
load('group1_9_adjustment_model.mat')

%% 径14mmの円板上トランスデューサをboolで配置する。
% トランスデューサの場所は以下の条件
% 
% 骨孔（直径1.6mm）の直上10mm
% 骨孔の中心座標 (x, y, z) = (172 + 250 = 422, 256, 100+108 = 208)
% モデルのx方向の先頭に何も存在しない空間を100程足して、距離10mmを確保
% トランスデューサの中心座標 (x, y, z) = (422 - 227 = 195, 256, 100 + 108 = 208)

% CTの空間分解能は今回44μm
dx = 44e-6; 

[x_num, y_num, z_num] = size(adjustment_model);

% 今回のモデルは等方体
space_length = x_num * dx;

% 10mmは何セル分に相当するか
l10_num = round(10e-3/dx);

%% モデルのx先頭に200セルを追加

% 追加用の空間
addtional_model_x = zeros(250, y_num, z_num);
addtional_model_z = zeros(x_num + 250, y_num, 100);

re_adjustment_model = cat(1, addtional_model_x, adjustment_model);
re_adjustment_model = cat(3, re_adjustment_model, addtional_model_z);
re_adjustment_model = cat(3, addtional_model_z, re_adjustment_model);

%% トランスデューサ（直径14 mm）を配置
% トランスデューサの中心座標 (x, y, z) = (422 - 227 = 195, 256, 200 + 108 = 208)
transducer_x = 195;
transducer_y = 256;
transducer_z = 208;

% 2値化モデル
is_model = re_adjustment_model ~= 0;
input_model = is_model;

% トランスデューサの直径
diameter = 14e-3;

for i = 1:y_num % 直径1mmの円板作成
    for k = 1:z_num

        if sqrt(((i - transducer_y))^2 + ((k - transducer_z))^2) < diameter/dx/2
            
           input_model(transducer_x, i, k) = 1;
        
        end
    end
end

% 骨部分を除去
input_model(transducer_x + 1:end, :, :) = 0;

% replace water
re_adjustment_model(re_adjustment_model == 0) = 1e+3;

% 計算を少しでも軽くするために単精度に
model = single(re_adjustment_model);

%% rotate_transducer

rotated_input_model = rotate3DMatrix(input_model, 'y', 45);
input_model = rotated_input_model ~= 0;
volumeViewer(is_model + input_model)

%% configuration
figure;
imagesc(squeeze(is_model(:,256,:)))
%% モデルとして出力
outDir = "../";

outFile = fullfile(outDir, "rat-tibia-rotated-model.mat");

save(outFile, "model", "is_model", "input_model", "-v7.3");  % 大きい配列なら -v7.3 推奨

% path = "../rat-tibia-rotated_model";
% 
% save(path, model, is_model, input_model)


