clear
close all
clc

load('group1_9.mat', 'model');

% % 回転中心を決めるために穴が見えるXY平面のスライス画像を表示
% figure;imagesc(squeeze(model(:,:,100))); 
% axis equal

% 回転中心 (x=194,y=227,z=256.x0とy0は上のスライスを見て決める。figureではXYの値が逆なので注意。Zはなんでも大丈夫なので半分にしている。) 
x0 = 194; % いじる
y0 = 227; % いじる
z0 = round(size(model,3)/2); % ここでは中央のZを基準にする。size(model,3)はmodelの３次元目、つまりZのサイズのことで今回は512。
center = [x0 y0 z0];

% 回転角
theta = -50;  % [deg] Z軸まわりの回転角
phi   = 0;   % [deg] X軸まわりの回転角

% ---- 変換行列の作成 ----
% 平行移動: 中心を原点へ
T1 = eye(4);
T1(4,1:3) = -center;
% 回転1: Z軸まわりにtheta回転
Rz = [cosd(theta) -sind(theta) 0 0;
      sind(theta)  cosd(theta) 0 0;
      0            0           1 0;
      0            0           0 1];
% 回転2: X軸まわりにphi回転
Rx = [1 0          0          0;
      0 cosd(phi) -sind(phi) 0;
      0 sind(phi)  cosd(phi) 0;
      0 0          0          1];
% 合成回転行列 (Z軸回転の後にX軸回転を適用)
R_total = Rz * Rx; 
% R_total = Rx * Rz; % 順番を逆にしたい場合はこちら
% 平行移動: 原点から元の位置へ戻す
T2 = eye(4);
T2(4,1:3) = center;
% 合成変換 (T1 * R_total * T2)
M = T1 * R_total * T2; 
% affine3d形式へ
tform = affine3d(M);
% ---- 変換の適用 ----
% 出力座標系を指定（入力と同じ大きさにする）
RA = imref3d(size(model));
rotated_model = imwarp(model, tform, 'cubic', 'OutputView', RA);

% % 回転後の確認用表示
% figure;imagesc(squeeze(rotated_model(:,:,100))); 
% axis equal

save('group1_9_rotation.mat', 'rotated_model', '-v7.3');
volumeViewer(rotated_model);