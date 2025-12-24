clear
close all
clc

load('group1_9_rotation.mat', 'rotated_model');

model= rotated_model(182,:,:);
% model(model < 0) = 0;% bmd の中で 0 未満の要素を 0 に置き換える
bmd = squeeze(model);
figure;imagesc(bmd)
axis equal

% %エクセルシートから長方形を切り抜く
% sheetName = 'original'; % 数字だけ変える
% myRange = [230 203 265 255]; % bmd_entyuuから範囲を参照
% bmd = readmatrix("bmd_xy11.xlsx", 'Sheet', sheetName, 'Range', myRange);
% %エクセルの指定範囲コピペ用　R230C203:R265C255
% figure;imagesc(bmd)
% axis equal
% 
% [nx ny]=size(bmd);