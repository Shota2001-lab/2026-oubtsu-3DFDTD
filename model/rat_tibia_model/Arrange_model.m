%% ラット脛骨の向きを調整するスクリプト
clear 
close all
clc
%% ノイズ除去＋骨密度調整したモデルを読み込む
load('group1_9_adjustment_model.mat')

%% 
% VoulumeViewerで1,2,3軸が揃っているか確認
volumeViewer(adjustment_model)

