clear
close all
clc

for k = 1:512
    filename = sprintf('0%03d.cb', k - 1);  % 例: 0000.cb, 0001.cb ... に対応
    img(:,:,k) = imread(filename);
end

%% 輝度値で3D画像を見たいときはこっち
% volumeViewer(img); 
% figure;imagesc(squeeze(img(182,:,:))); 
% axis equal

%% bmdへ変換
premodel = double(img); % double変換はここでOK
premodel(premodel < 40839) = 0; % 輝度値が切片未満のボクセルを0にする (bmd=0)
premodel(premodel >= 40839) = round(premodel(premodel >= 40839) - 40839);
model=uint16(round(premodel/12.63)); % bmdと輝度値の検量線から傾きを求めて入力

save('group1_9.mat', 'model', '-v7.3');
volumeViewer(model);








%% （参考用）元々のループ節
% premodel = double(img); % 数値行列として格納（必要ならdouble変換）
% 
% for m=1:512
%     for n=1:512
%         for l=1:512
%             if premodel(m,n,l) < 40839 % bmd=0となる輝度値を入力
%                  premodel(m,n,l) = 0;
%             else
%                  premodel(m,n,l)=round(premodel(m,n,l)-40839);
%             end
%         end
%     end
% end