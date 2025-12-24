clear
close all
clc

load('group1_4_rotation.mat', 'rotated_model');


% figure;imagesc(squeeze(rotated_model(278,:,:))); %figure2
% axis equal

%% 楕円のパラメータ
centerX_ellipse = 260;  % 中心のX座標
centerY_ellipse = 337;  % 中心のY座標
semiMajorAxis_ellipse = 18;  % 短軸の長さ
semiMinorAxis_ellipse = 26;  % 長軸の長さ
count=1;
for l=276:294 %何枚くりぬくか
    for n=1:512
        for m=1:511
       if((n-centerX_ellipse).^2/semiMajorAxis_ellipse^2)+((m-centerY_ellipse).^2/semiMinorAxis_ellipse^2)<=1
          bmd_model(1,count)=rotated_model(l,n,m);
          count=count+1;
       end
        end
    end
end
% %% 直方体のパラメータ
% centerX_ellipse = 260;  % 中心のX座標
% centerY_ellipse = 337;  % 中心のY座標
% semiMajorAxis_ellipse = 18;  % 短軸の長さ
% semiMinorAxis_ellipse = 26;  % 長軸の長さ
% count=1;
% for l=276:294 %何枚くりぬくか
%     for n=centerX_ellipse-17:centerX_ellipse+19
%         for m=centerY_ellipse-26:centerY_ellipse+27
%           bmd_model(1,count)=rotated_model(l,n,m);
%           count=count+1;
%         end
% 
%     end
% end

% BMD範囲を10～1000に分ける
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