clear
close all
clc

load('group1_9_rotation.mat', 'rotated_model');

% % 楕円の中心とスライス圧を決めるために穴が見えるXYとXZ平面のスライス画像を表示
% figure;imagesc(squeeze(rotated_model(182,:,:))); 
% axis equal

%% 楕円のパラメータ (x=258, y=109)
centerX_ellipse = 256;  % 中心のX座標
centerY_ellipse = 108;  % 中心のY座標
semiMajorAxis_ellipse = 21;  % 短軸の長さ
semiMinorAxis_ellipse = 33;  % 長軸の長さ
count=1;
for l=172:192 % 骨孔の厚さ分だけスライス
    for n=1:512
        for m=1:512
            if((n-centerX_ellipse).^2/semiMajorAxis_ellipse^2)+((m-centerY_ellipse).^2/semiMinorAxis_ellipse^2)<=1
                bmd_model(1,count)=rotated_model(l,n,m);
                count=count+1;
            end
        end
    end
end

% BMD範囲を0～1500に分ける
edges = 0:50:2500;  % 分ける範囲（100 ～ 1500、5単位ごと）

% 各範囲内のピクセル数をカウント
pixel_counts = histcounts(bmd_model(bmd_model >= 0 & bmd_model <= 2500), edges);

% プロット
figure;
bar(edges(1:end-1), pixel_counts, 'histc'); % 範囲ごとに棒グラフを描く
xlabel('BMD [dimensionless]');
ylabel('Number of pixels [pixel]');
title('BMD Distribution');
grid on;