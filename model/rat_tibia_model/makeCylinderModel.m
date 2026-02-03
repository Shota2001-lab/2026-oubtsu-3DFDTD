%% 初期化
clear
close all
clc
%% 空間定義
% サイズ
nx = 350; ny = 350; nz = 450;

% 物理スケール（ボクセル間隔）。不要なら dx=dy=dz=1 でOK
dx = 1; dy = 1; dz = 1;

% 楕円の中心（index座標で指定）
cx = 215; % according to x position of makeCutModel
cy = (ny+1)/2;

% 半径（ボクセル単位。物理単位でやりたいなら a_m = a*dx みたいに揃える）
a = 30;  % x方向の半径
b = 80;  % y方向の半径
d = 10;  % kotuatsu

% 柱の高さ（z範囲）
z1 = 75; 
z2 = 375;

% 座標グリッド（index -> 物理座標にしたいなら (X-cx)*dx 等にする）
[X, Y, Z] = ndgrid(1:nx, 1:ny, 1:nz);

% 楕円条件（xy）
outerEllipseXY = ((X - cx)/a).^2 + ((Y - cy)/b).^2 <= 1;

innerElipseXY = ((X - cx)/(a - d)).^2 + ((Y - cy)/(b - d)).^2 <= 1;

% z範囲条件
inZ = (Z >= z1) & (Z <= z2);

% 3Dマスク（logical）
mask = (outerEllipseXY & ~innerElipseXY) & inZ;

% 0/1 の3Dマトリクスにするなら
elipseClyinderModel = single(mask);   % 0/1

%%
% volumeViewer(elipseClyinderModel)
%% replace 1 with bone density (1.38 kg/m^3)
% assume bone is homogenious

elipseClyinderModel = elipseClyinderModel.*1.38e+3;
elipseClyinderModel(elipseClyinderModel == 0) = 1e+3;
%% save as a .mat file
outDir = '..';
outFile = fullfile(outDir, 'elipseCylinderModel.mat');

%%
figure;
imagesc(squeeze(elipseClyinderModel(:, :, 200)))
axis equal;

%% make a bone hole (diameter: 1.4mm, dx = 44 um)
% x = 
holeX = 190;
holeY = 175;
holeZ = 108 + 75;

rangeX = 180:200;
rangeY = 75:275;
rangeZ = 125:325;



%% 
dx = 44e-6; 
% bone holeの直径
boneHoleDiameter = 1.4e-3;

for i = rangeX
    for  j = rangeY % 円板作成
        for k = rangeZ
    
            if sqrt(((j - holeY))^2 + ((k - holeZ))^2) < boneHoleDiameter/dx/2
                
               elipseClyinderModel(i, j, k) = 1e+3;
            
            end
        end
    end
end  
%% 
figure;
imagesc(squeeze(elipseClyinderModel(holeX, rangeY, rangeZ)))
axis equal;
%% make a transducer (diameter:14e+3, 5mm from bone surface)

% 5mmは何セル分に相当するか
L5mmCellSize = round(5e-3/dx);

[xNum, yNum, zNum] = size(elipseClyinderModel);

%% 

transducerX = 172 - L5mmCellSize;
transducerY = 175;
transducerZ = 108 + 75;

% 2値化モデル
inputModel = false(size(elipseClyinderModel));
isModel = elipseClyinderModel ~= 1e+3;

% トランスデューサの直径
diameter = 14e-3;

for i = 1:yNum % 円板作成
    for k = 1:zNum

        if sqrt(((i - transducerY))^2 + ((k - transducerZ))^2) < diameter/dx/2
            
           inputModel(transducerX, i, k) = 1;
        
        end
    end
end

% % 骨部分を除去
% inputModel(transducerX + 1:end, :, :) = 0;
% inputModel(:,:,transducerZ + round(diameter/2/dx):end) = 0;
% 
% % replace water
% elipseClyinderModel(elipseClyinderModel < 1000) = 1e+3;
% 
% isModel = elipseClyinderModel ~= 1e+3;

% 計算を少しでも軽くするために単精度に
model = single(elipseClyinderModel);

%%
volumeViewer(isModel + inputModel)

%% save clynderModel
% モデルとして出力
outDir = "../";

outFile = fullfile(outDir, "clinderModel-5mm_distance.mat");

save(outFile, "model", "isModel", "inputModel", "-v7.3");
