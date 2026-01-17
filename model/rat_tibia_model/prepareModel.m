clear
close all
clc
%% 3Dモデル読み込み
load('./group1_9_rotation.mat', 'rotated_model');

%% VolumeViewer
%volumeViewer(rotated_model);

%% 断面図
imagesc(rotated_model(:,:,300))
%% ノイズ除去対象のモデル
[xSize, ySize, zSize] = size(rotated_model);

% モデルをdouble型に
rotated_model = double(rotated_model);

% モデルの領域を予め確保
newModel = zeros(xSize, ySize, zSize);


% 確実に皮質骨であるだろう値
absoluteCorticalThreshold = 470;

% 皮質骨かどうか判定するための閾値
% 関数内部で使用している
corticalThreshold = 200;

% parforで中身を並列計算させる
% parallel Computing Tool Boxがマスト
% 正直普通のfor文とあまり変わらないかも、、
parfor z = 1:zSize
    slicedImage = rotated_model(:,:,z);
    
    % 皮質骨の部分を１に置換
    [xSize, ySize] = size(slicedImage);
    isCorticalImage = zeros(xSize,ySize);
    
    for y = 1:ySize
        % 皮質骨切り抜き開始位置
        startX = SetStartPosition(slicedImage, y, absoluteCorticalThreshold);
        % 皮質骨の切り抜き終了位置
        endX = SetEndPosition(slicedImage, y, absoluteCorticalThreshold);
        
        % 皮質骨がなければ次のループに
        if (startX == 1 && endX == xSize)
            continue
        end
    
        isCorticalImage(startX:endX, y) = 1;
    end
    
    % 皮質骨部分のみを切り取り
    cutImage = slicedImage .*isCorticalImage;
    newModel(:,:,z) = cutImage;
end


% 出力モデルのファイル名
outfile = 'group1_9_cut_density.mat';
save(outfile, 'newModel');
%% 骨密度の平均値を1.3g/cm^3に

% BMDの平均値
notZeroValues = newModel(newModel ~= 0);
bmdAvg = round(mean(notZeroValues));

% ラット脛骨の骨密度とBMDが線形だと仮定して、平均の骨密度が1.38g/cm^3(仮）になるように調整
% wada IEEE mice density
adjustmentModel = newModel*1.38e+3/bmdAvg;

%%
figure;
imagesc(newModel(:,:,110))
figure;
imagesc(adjustmentModel(:,:,110));

% 出力モデルのファイル名
outfile = 'group1_9_adjustment_model.mat';
save(outfile, 'adjustmentModel');