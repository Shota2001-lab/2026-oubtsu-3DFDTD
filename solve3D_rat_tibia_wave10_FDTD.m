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

figure;
plot(para.wave)

model = 'model/rat-tibia-model_close3';

flag = true;
% flag = false;
%%
gpuDevice(1);
gpuDeviceTable

%% solve3D(para, 'model.mat', false);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(model);

[nx, ny, nz] = size(input_model);
nx = single(nx);
ny = single(ny);
nz = single(nz);

is_model_normal = single(is_model);
% is_model_normal(is_model_normal < 1) = 0;
is_model_share = single(meanMatrix(is_model_normal));
% is_model_share(is_model_share < 1) = 0;
% rate = struct('axcial', 1 - 10^(-2.1/20 * 100 * para.solution.dx), 'normal', 1 - 10^(-3.1/20 * 100 * para.solution.dx), 'share', 1 - 10^(-5.2/20 * 100 * para.solution.dx));
rate = struct('axcial', 0, 'normal', 0, 'share', 0); % 今回は減衰ゼロで回す
run 'const/elastic_homo'
%% モデルを見る
% volumeViewer(input_model)
%%
% figure;
% imagesc(squeeze(model(hole_x, :, range_z)));

caxis([1000 5500]);
axis image;
cb = colorbar;
ax = gca;


cb.FontSize = 10;
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
% figure;
% imagesc(squeeze(is_model_normal(:,100,:)));
% figure;
% c = dtdx.C44(is_model_normal + 1);
% volumeViewer(c)

% is_model_normal = single(is_model);
% unique(is_model_normal(:))

%%
a = figure;
a.Position = [50 -100 1200 750];
c = round(15e-3/ para.solution.dx/2);

tt = gpuArray(zeros(1, para.solution.nt));

% hole_x = 440;
hole_x = 190;
hole_y = 100;
hole_z = 158;

% range_y = 1:356;
range_z = 50:250;
% range_z = 150:350;

outDirTxx = 'Result/Txx';
outDirTyz = 'Result/Tyz';
outDirTzx = 'Result/Tzx';

dataTxy = gpuArray(single(zeros(ny, nz)));
dataTyz = gpuArray(single(zeros(ny, nz)));
dataTzx = gpuArray(single(zeros(ny, nz)));


tic

%%
for s = 1:para.solution.nt

  [Txx, Tyy, Tzz] = send_wave(Txx, Tyy, Tzz, input_model, input_wave(s));

  % [Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy] ...
  %   = FDTD3D_3(Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy,  ...
  %   dtdx ...
  %   , nx, ny, nz, is_model_normal, is_model_share);

    [Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy] ...
    = FDTD3D_3_valid(Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy,  ...
    dtdx ...
    , nx, ny, nz, is_model_normal);

  [Txx, Tyy, Tzz, hig] ...
    = higdon3D(Txx, Tyy, Tzz, hig, h, nx, ny, nz);

  %%%%

  if rem(s, 10) == 0
    drawnow
    %%
    subplot(2,2,1); imagesc(squeeze(Txx(hole_x, :, range_z))); axis equal tight; caxis([-2 2]);
    subplot(2,2,2); imagesc(squeeze(Tzz(hole_x, :, range_z))); axis equal tight; caxis([-2 2]);
    subplot(2,2,3); imagesc(squeeze(Tzx(hole_x, :, range_z))); axis equal tight; caxis([-2 2]);
    subplot(2,2,4); imagesc(squeeze(Tyz(hole_x, :, range_z))); axis equal tight; caxis([-2 2]);
    saveas(gcf, sprintf('image_per100/image_%04d.png', s))
    
    %% 観測波形
    dataTxx = squeeze(Txx(hole_x, :, range_z));
    dataTyz = squeeze(Tyz(hole_x, :, range_z));
    dataTzx = squeeze(Tzx(hole_x, :, range_z));

    fileName_Txx = fullfile(outDirTxx, sprintf("wave10_Txx_%04d.csv", s));
    fileName_Tyz = fullfile(outDirTyz, sprintf("wave10_Tyz_%04d.csv", s));
    fileName_Tzx = fullfile(outDirTzx, sprintf("wave10_Tzx_%04d.csv", s));
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

