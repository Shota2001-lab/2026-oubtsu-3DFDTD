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
% 骨孔の中心座標 (x, y, z) = (172 = 272, 256, 108 + 75 = 183)
% モデルのx方向の先頭に何も存在しない空間を100程足して、距離10mmを確保
% トランスデューサの中心座標 (x, y, z) = (272 - 227 = 45, 256, 100 + 108 = 208)
% figure;
% imagesc(squeeze(adjustment_model(:, 256, :)))
adjustmentModel = adjustmentModel(1:350, 81:431, 1:300);
%%
figure;
imagesc(squeeze(adjustmentModel(:, 175, :)))
%% 
% CTの空間分解能は今回44μm
dx = 44e-6; 

[xNum, yNum, zNum] = size(adjustmentModel);

% 今回のモデルは等方体
spaceLength = xNum * dx;

% 5mmは何セル分に相当するか
L5mmCellSize = round(5e-3/dx);
%% z軸方向に５０セルを前後に追加
addtionalModelZ = zeros(xNum, yNum, 75);

reAdjustmentModel = cat(3, addtionalModelZ, adjustmentModel);
reAdjustmentModel = cat(3, reAdjustmentModel, addtionalModelZ);

[xNum, yNum, zNum] = size(reAdjustmentModel);

%% トランスデューサ（直径14 mm）を配置
% トランスデューサの中心座標 (x, y, z) = (172 - 114 = 58, 256 - 81, 108 + 75 = 183)
transducerX = 172 - L5mmCellSize;
transducerY = 175;
transducerZ = 108 + 75;

% 2値化モデル
isModel = reAdjustmentModel ~= 0;
inputModel = isModel;

% トランスデューサの直径
diameter = 14e-3;

for i = 1:yNum % 円板作成
    for k = 1:zNum

        if sqrt(((i - transducerY))^2 + ((k - transducerZ))^2) < diameter/dx/2
            
           inputModel(transducerX, i, k) = 1;
        
        end
    end
end

% 骨部分を除去
inputModel(transducerX + 1:end, :, :) = 0;
inputModel(:,:,transducerZ + round(diameter/2/dx):end) = 0;

% replace water
reAdjustmentModel(reAdjustmentModel < 1000) = 1e+3;

isModel = reAdjustmentModel ~= 1e+3;

% 計算を少しでも軽くするために単精度に
model = single(reAdjustmentModel);

volumeViewer(isModel + inputModel)

%% モデルとして出力
outDir = "../";

outFile = fullfile(outDir, "clinderModel-5mm_distance.mat");

save(outFile, "model", "isModel", "inputModel", "-v7.3");  % 大きい配列なら -v7.3 推奨

% path = "../rat-tibia-model";
% 
% save(path, model, is_model, input_model)

%% 
figure;
imagesc(squeeze(inputModel(transducerX,:,:)))
%% 
figure;
imagesc(squeeze(model(190,:,:)))
