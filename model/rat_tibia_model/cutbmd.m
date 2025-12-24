clear
close all
clc

load('group1_4_rotation.mat', 'rotated_model');

model= rotated_model(268,:,:);
model(model < 0) = 0;% bmd の中で 0 未満の要素を 0 に置き換える
bmd = squeeze(model);
figure;imagesc(bmd)
axis equal

% %エクセルシートから長方形を切り抜く
% sheetName = 'z=276'; % 数字だけ変える
% myRange = [238 311 273 363]; % bmd_entyuuから範囲を参照 243 311 279 364  1 1 500 500
% bmd = readmatrix("bmd_xy.xlsx", 'Sheet', sheetName, 'Range', myRange);
% %エクセルの指定範囲コピペ用　R238C311:R273C363
% figure;imagesc(bmd)
% axis equal
% 
% [nx ny]=size(bmd);