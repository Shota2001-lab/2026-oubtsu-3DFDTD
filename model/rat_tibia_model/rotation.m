clear
close all
clc

load('group1_4.mat', 'model');

% figure;imagesc(squeeze(model(:,:,230))); %figure2
% axis equal

% 回転中心 (x=243, y=258, z=任意) 
x0 = 243; %いじる
y0 = 258; %いじる
z0 = round(size(model,3)/2);   % ここでは中央のZを基準にする
center = [x0 y0 z0];

% 回転角
theta = -5;  % [deg]いじる

% ---- 変換行列の作成 ----
% 平行移動: 中心を原点へ
T1 = eye(4);
T1(4,1:3) = -center;

% 回転: Z軸まわりにtheta回転
Rz = [cosd(theta) -sind(theta) 0 0;
      sind(theta)  cosd(theta) 0 0;
      0            0           1 0;
      0            0           0 1];

% 平行移動: 原点から元の位置へ戻す
T2 = eye(4);
T2(4,1:3) = center;

% 合成変換
M = T1 * Rz * T2;

% affine3d形式へ
tform = affine3d(M);

% ---- 変換の適用 ----
% 出力座標系を指定（入力と同じ大きさにする）
RA = imref3d(size(model));

rotated_model = imwarp(model, tform, 'cubic', 'OutputView', RA);
% 
% % ---- 確認用表示 ----
% figure;
% slice_num = round(size(rotated_model,3)/2);
% imagesc(rotated_model(:,:,slice_num));
% axis equal

% save('group1_4_rotation.mat', 'rotated_model', '-v7.3'); %格納
volumeViewer(rotated_model);