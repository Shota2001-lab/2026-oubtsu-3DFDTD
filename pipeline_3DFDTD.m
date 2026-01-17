%% 変数の初期化（matlabはcamelCase推奨）
clear 
close all
clc
%% 3D-FDTDを連続で回すためのケース定義
% 3D-FDTDシミュレーションを実行するためには以下の条件が変わる
% 分解能：空間分解能(dx), 時間分解能(dt)、シミュレーション回数(nt)
% 照射条件：周波数(freq), バースト回数(burstNum)
% 3Dモデル：以下の3つのモデルを含む.matファイルのパス
%           model(密度パラメータ入りの3次元マトリクス), isModel（水部分を0, 骨を1とした2値化モデル）
%           inputModel(送波器部分を1それ以外を0とした2値化モデル)
% 弾性定数：弾性定数をマトリクス配置するスクリプトが記述してあるファイルのパス
% 計測範囲：rangeX, rangeY, rangeZ
% 出力ディレクトリ：結果を出力するためのディレクトリパス

caseName = '1-3_homo';
para.solution = struct('dx', 44e-6, 'dt', 2e-9, 'nt', 4000);
para.irradiation = struct('freq', 1.5e+6,'burstNum',10);
para.model = struct('model', 'model/rat-tibia-model_close3');
para.elastic = struct('elastic', 'const/elastic_homo');
para.measurementRange = struct('rangeX', 190, 'rangeY', :, 'rangeY', 50:250);
resultDir = 'Result'+caseName;
para.outputDir = struct('ResultDir', resultDir);
