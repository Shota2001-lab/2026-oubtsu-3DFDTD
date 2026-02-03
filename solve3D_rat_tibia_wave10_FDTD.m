% function [T, Txx] = solve3D(para, model, flag) %#codegen
clc
clear
close all
%等方性　境界の圧電性カット
%%
para.solution = struct('dx', 44e-6, 'dt', 2e-9, 'nt', 4000); % 空間、時間分解能は1.5MHzで計算すること
wd = 0.5 - 0.5 * cos(2 * pi * 1.5e6 * para.solution.dt * (1:round(1/1.5e6/ para.solution.dt)));
para.wave = single(sin(2 * pi * 1.5e6 *  para.solution.dt * (1:round(1/1.5e6/ para.solution.dt)*10)));

%%
hann_wd = hann(numel(para.wave));   % ← numel or length が正解
hann_wd = hann_wd.';  

% hann window
% para.wave = para.wave.*hann_wd;

model = 'model/clinderModel-5mm_distance.mat';

flag = true;
% flag = false;
%%
gpuDevice(1);
gpuDeviceTable

%% solve3D(para, 'model.mat', false);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(model);

[nx, ny, nz] = size(inputModel);
nx = single(nx);
ny = single(ny);
nz = single(nz);

is_model_normal = single(isModel);
is_model_share = single(meanMatrix(is_model_normal));
% rate = struct('axcial', 1 - 10^(-2.1/20 * 100 * para.solution.dx), 'normal', 1 - 10^(-3.1/20 * 100 * para.solution.dx), 'share', 1 - 10^(-5.2/20 * 100 * para.solution.dx));
rate = struct('axcial', 0, 'normal', 0, 'share', 0); % 今回は減衰ゼロで回す
run 'const/elastic_homo'
%% モデルを見る
% volumeViewer(isModel + inputModel)
%% 断面図の画像
% figure;
% imagesc(squeeze(model(holeX, :, :)));

% caxis([1000 5500]);
% axis image;
% cb = colorbar;
% ax = gca;
% 
% 
% cb.FontSize = 10;
% imagesc(squeeze(model(290, 156:356, 100:350)))
% saveas(gcf, "cut_xslice.fig")

%% 入力波形作成
input_wave = single(zeros(1, para.solution.nt * 2));
input_wave(1, 1:length(para.wave)) = para.wave;

figure;
plot(input_wave);

%%
if flag
  run 'const/gpu_matrix_ForFDTD'
  is_model_share = gpuArray(is_model_share);
  is_model_normal = gpuArray(is_model_normal);
else
  run 'const/cpu_matrix'
end

%%
a = figure;
a.Position = [50 -100 1200 750];
c = round(15e-3/ para.solution.dx/2);

tt = gpuArray(zeros(1, para.solution.nt));

% 骨孔の位置
holeX = 190;
holeY = 175;
holeZ = 108 + 75;

rangeY = 75:275;
rangeZ = 125:325;
%%
figure;
imagesc(squeeze(model(holeX,rangeY,rangeZ)))
%% ここで出力先のディレクトリを用意してなければ作成する
root = pwd;
dirPath = fullfile(root, "Result_0127_1");

if ~isfolder(dirPath)
    mkdir(dirPath);
end

resultPath.resultPathTxx = fullfile(dirPath, 'Txx');
resultPath.resultPathTyz = fullfile(dirPath, 'Tyz');
resultPath.resultPathTzx = fullfile(dirPath, 'Tzx');
resultPath.resultPathImage = fullfile(dirPath, 'Images');

fn = fieldnames(resultPath);          % フィールド名一覧
for k = 1:numel(fn)
    p = resultPath.(fn{k});           % 動的フィールド参照でパス文字列を取得
    if ~isfolder(p)
        mkdir(p);
    end
end


dataTxy = gpuArray(single(zeros(ny, nz)));
dataTyz = gpuArray(single(zeros(ny, nz)));
dataTzx = gpuArray(single(zeros(ny, nz)));


tic

%%
for s = 1:para.solution.nt
    
    [Txx, Tyy, Tzz] = send_wave(Txx, Tyy, Tzz, inputModel, input_wave(s));

    [Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy] ...
    = FDTD3D_3_valid(Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy,  ...
    dtdx ...
    , nx, ny, nz);

    [Txx, Tyy, Tzz, hig] ...
    = higdon3D(Txx, Tyy, Tzz, hig, h, nx, ny, nz);

  %%%%

  if rem(s, 10) == 0
    drawnow
    %%
    subplot(2,2,1); imagesc(squeeze(Txx(holeX, rangeY, rangeZ))); axis equal tight; caxis([-2 2]);
    subplot(2,2,2); imagesc(squeeze(Tzz(holeX, rangeY, rangeZ))); axis equal tight; caxis([-2 2]);
    subplot(2,2,3); imagesc(squeeze(Tzx(holeX, rangeY, rangeZ))); axis equal tight; caxis([-2 2]);
    subplot(2,2,4); imagesc(squeeze(Tyz(holeX, rangeY, rangeZ))); axis equal tight; caxis([-2 2]);
    saveas(gcf, fullfile(resultPath.resultPathImage,sprintf('image_%04d.png', s)))
    
    %% 観測波形
    dataTxx = squeeze(Txx(holeX, :, rangeZ));
    dataTyz = squeeze(Tyz(holeX, :, rangeZ));
    dataTzx = squeeze(Tzx(holeX, :, rangeZ));

    fileName_Txx = fullfile(resultPath.resultPathTxx, sprintf("wave10_%04d.csv", s));
    fileName_Tyz = fullfile(resultPath.resultPathTyz, sprintf("wave10_%04d.csv", s));
    fileName_Tzx = fullfile(resultPath.resultPathTzx, sprintf("wave10_%04d.csv", s));
    writematrix(dataTxx,fileName_Txx);
    writematrix(dataTyz,fileName_Tyz)
    writematrix(dataTzx,fileName_Tzx)
  end

  clc
  sprintf('回転数: %d回/%d回', s, para.solution.nt)
  time = toc / s * (para.solution.nt - s);
  tt(1, s) = time;
  sprintf('残り時間: %d時間 %d分%0.3f秒', round(rem(time / 3600, 60)), rem(round(time / 60), 60), round(rem(time, 60), 3))

  

end
T = toc

