clear
close all
clc

for k = 1:511
    filename = sprintf('0%03d.cb', k);  % 例: 0001.cb, 0002.cb ... に対応
    img(:,:,k) = imread(filename);
end

% volumeViewer(img);

% filename = sprintf('0200.cb');   % ファイル名を文字列として作成
% img = imread(filename);          % 画像を読み込む
model2 = double(img); % 数値行列として格納（必要ならdouble変換）

for m=1:512
    for n=1:512
        for l=1:511
        if model2(m,n,l) < 41256.5
            model2(m,n,l) = 0;
        else
            model2(m,n,l)=round(model2(m,n,l)-41256.5);
        end
    end
end
end

model=round(model2/15.981);
save('group1_4.mat', 'model', '-v7.3');
% figure;
% imagesc(model);                  % 可視化
% colormap gray;                   % グレースケールで表示
% colorbar;                        % 値のスケールを表示
% axis equal

volumeViewer(model);

