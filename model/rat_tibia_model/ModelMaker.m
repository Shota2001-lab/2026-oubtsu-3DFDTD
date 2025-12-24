clear
close all
clc
%% 3Dモデル読み込み
load('./group1_9.mat', 'model');

%% VolumeViewer
volumeViewer(model);

%% 断面図
imagesc(model(:,:,300))
%% ノイズ除去対象のモデル
[x_size, y_size, z_size] = size(model);

% モデルをdouble型に
model = double(model);

% モデルの領域を予め確保
new_model = zeros(x_size, y_size, z_size);

% parforで中身を並列計算させる
% parallel Computing Tool Boxがマスト
% 正直普通のfor文とあまり変わらないかも、、
parfor z = 1:z_size
    sliced_image = model(:,:,z);
    
    % 皮質骨の部分を１に置換
    [x_size, y_size] = size(sliced_image);
    isCorticalImage = zeros(x_size,y_size);
    
    % 確実に皮質骨であるだろう値
    absolute_cortical_threhold = 800;
    
    % 皮質骨かどうか判定するための閾値
    % 関数内部で使用している
    cortical_threhold = 200;
    
    for y = 1:y_size
        % 皮質骨切り抜き開始位置
        start_x = SetStartPosition(sliced_image, y, absolute_cortical_threhold);
        % 皮質骨の切り抜き終了位置
        end_x = SetEndPosition(sliced_image, y, absolute_cortical_threhold);
        
        % 皮質骨がなければ次のループに
        if (start_x == 1 && end_x == x_size)
            continue
        end
    
        isCorticalImage(start_x:end_x, y) = 1;
    end
    
    % 皮質骨部分のみを切り取り
    cut_image = sliced_image .*isCorticalImage;
    new_model(:,:,z) = cut_image;
end


% 出力モデルのファイル名
outfile = 'group1_9_cut_density.mat';
save(outfile, 'new_model');
%% 骨密度の平均値を100mg/cm^3に

% BMDの平均値
not_zero_values = new_model(new_model ~= 0);
bmd_avg = round(mean(not_zero_values));

% ラット脛骨の骨密度とBMDが線形だと仮定して、平均の骨密度が100g/cm^3(仮）になるように調整
adjustment_model = new_model*1000/bmd_avg;

imagesc(adjustment_model(:,:,200));

% 出力モデルのファイル名
outfile = 'group1_9_adjustment_model.mat';
save(outfile, 'adjustment_model');