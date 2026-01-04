clear 
close all
clc
%% Combaine images into video
%% png2video.m
% フォルダ内のPNGを連結して動画(mp4)にする

% ====== 設定 ======
imgDir   = "image_per100";   % PNGが並んでいるフォルダ
pattern  = "*.png";                % 対象拡張子
outFile  = fullfile(imgDir, "result_per100us.mp4");
fps      = 30;                     % フレームレート
quality  = 95;                     % 0-100 (MPEG-4 の場合)
resizeToFirst = true;              % サイズがバラバラなら最初の画像に合わせる
% ==================

files = dir(fullfile(imgDir, pattern));
if isempty(files)
    error("No PNG files found in: %s", imgDir);
end

% --- VideoWriter 準備 ---
vw = VideoWriter(outFile, "MPEG-4");
vw.FrameRate = fps;
vw.Quality   = quality;
open(vw);

% --- 1枚目でサイズ基準を決める ---
first = imread(fullfile(imgDir, files(1).name));
if size(first,3) == 1
    first = repmat(first, 1, 1, 3); % グレースケール -> RGB
end
baseH = size(first,1);
baseW = size(first,2);

% --- 書き込み ---
for k = 1:numel(files)
    fp = fullfile(imgDir, files(k).name);
    img = imread(fp);

    % グレースケール対応
    if size(img,3) == 1
        img = repmat(img, 1, 1, 3);
    end

    % サイズ統一（必要なら）
    if resizeToFirst && (size(img,1) ~= baseH || size(img,2) ~= baseW)
        img = imresize(img, [baseH baseW]);
    end

    writeVideo(vw, img);
    % 進捗表示したいなら:
    fprintf("%d/%d: %s\n", k, numel(files), files(k).name);
end

close(vw);
fprintf("Saved video: %s\n", outFile);
