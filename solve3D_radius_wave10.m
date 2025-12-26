% function [T, Txx] = solve3D(para, model, flag) %#codegen
clc
clear
close all
%等方性　境界の圧電性カット
%%
para.solution = struct('dx', 50e-6,'dz', 10e-6, 'dt', 2e-9, 'nt', 8000); % 空間、時間分解能は5MHzで計算すること
wd = 0.5 - 0.5 * cos(2 * pi * 1e6 * para.solution.dt * (1:round(1/1e6/ para.solution.dt))); % 送波1MHz
para.wave = single(sin(2 * pi * 1e6 *  para.solution.dt * (1:round(1/1e6/ para.solution.dt)*10)));

model = 'model/model_Test_100u';

flag = true;
% flag = false;
%%
gpuDevice(2);
gpuDeviceTable

%% solve3D(para, 'model.mat', false);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(model);
volumeViewer(input_model)
volumeViewer(is_model)
%%
[nx, ny, nz] = size(input_model);
nx = single(nx);
ny = single(ny);
nz = single(nz);

is_model_normal = single(is_model);
is_model_normal(is_model_normal < 1) = 0;
is_model_share = single(meanMatrix(is_model_normal));
is_model_share(is_model_share < 1) = 0;
% rate = struct('axcial', 1 - 10^(-2.1/20 * 100 * para.solution.dx), 'normal', 1 - 10^(-3.1/20 * 100 * para.solution.dx), 'share', 1 - 10^(-5.2/20 * 100 * para.solution.dx));
rate = struct('axcial', 0, 'normal', 0, 'share', 0); % 今回は減衰ゼロで回す
% run 'const/elastic_brass'
run 'const/elastic_test'
run 'const/piezoelectric'

%% モデルを見る
% figure(3);
% plot(dtdz.C44(:,50,202));
% volumeViewer(is_model_normal)
% volumeViewer(dtdx.C66)
% density_water = 1000;
% v_water = 1500;
% K = density_water * v_water^2
% 
% c11_test = K* para.solution.dt / para.solution.dx

%% 入力波形作成
input_wave = single(zeros(1, para.solution.nt * 2));
input_wave(1, 1:length(para.wave)) = para.wave;

figure(2);
plot(input_wave)
xticks([])
ylim([-2 2])
%%
if flag
  run 'const'/gpu_matrix.m
  is_model_share = gpuArray(is_model_share);
  is_model_normal = gpuArray(is_model_normal);
else
  run 'const/cpu_matrix'
end
% e = single(e);

a = figure(1);
a.Position = [50 -100 1200 750];
c = round(15e-3/ para.solution.dx/2);

tt = gpuArray(zeros(1, para.solution.nt));

dataTzz = gpuArray(single(zeros(para.solution.nt, 1)));
dataTyz = gpuArray(single(zeros(para.solution.nt, 1)));
% dataTzz = gpuArray(single(zeros(para.solution.nt, 1)));

dataEx = gpuArray(single(zeros(para.solution.nt, 10)));

tic

%%
for s = 1:para.solution.nt

  [Txx, Tyy, Tzz] = send_wave(Txx, Tyy, Tzz, input_model, input_wave(s));

  [Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy, Ex, Ey, Ez, tEx, tEy, tEz] ...
    = PE_FDTD3D_3_Test(Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy, Ex, Ey, Ez, tEx, tEy, tEz ...
    , dtdx, dtdz...
    , nx, ny, nz, rate ...
    , e,is_model_share);

% 動作検証用（圧電なし）
%   [Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy] ...
%     = FDTD3D_3(Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy ...
%     , dtdx, nx, ny, nz, is_model_normal, is_model_share);

  [Txx, Tyy, Tzz, hig] ...
    = higdon3D(Txx, Tyy, Tzz, hig, h, nx, ny, nz);

  %%%%

  if rem(s, 10) == 0
    drawnow
    %%
%     subplot(3, 4, 1); imagesc(squeeze(is_model_normal(148 - c, :, :) * 1e-2 + Txx(148 - c, :, :))); axis equal tight; caxis([-1e-1 1e-1])
%     subplot(3, 4, 2); imagesc(squeeze(is_model_share(148 - c, :, :) * 1e-9 + Ex(148 - c, 2:end - 1, 2:end - 1))); axis equal tight; caxis([-1e-8 1e-8])
%     subplot(3, 4, 3); imagesc(squeeze(is_model_normal(:, :, 423 - c) * 1e-2 + Txx(:, :, 423 - c))); axis equal tight; caxis([-1e-1 1e-1])
%     subplot(3, 4, 4); imagesc(squeeze(is_model_share(:, :, 423 - c) * 1e-9 + Ex(2:end - 1, 2:end - 1, 423 - c))); axis equal tight; caxis([-1e-8 1e-8])
%     subplot(3, 4, 5); imagesc(squeeze(is_model_normal(148, :, :) * 1e-2 + Txx(148, :, :))); axis equal tight; caxis([-1e-1 1e-1])
%     subplot(3, 4, 6); imagesc(squeeze(is_model_share(148, :, :) * 1e-9 + Ex(148, 2:end - 1, 2:end - 1))); axis equal tight; caxis([-1e-8 1e-8])
%     subplot(3, 4, 7); imagesc(squeeze(is_model_normal(:, :, 423) * 1e-2 + Txx(:, :, 423))); axis equal tight; caxis([-1e-1 1e-1])
%     subplot(3, 4, 8); imagesc(squeeze(is_model_share(:, :, 423) * 1e-9 + Ex(2:end - 1, 2:end - 1, 423))); axis equal tight; caxis([-1e-8 1e-8])
%     subplot(3, 4, 9); imagesc(squeeze(is_model_normal(148 + c, :, :) * 1e-2 + Txx(148 + c, :, :))); axis equal tight; caxis([-1e-1 1e-1])
%     subplot(3, 4, 10); imagesc(squeeze(is_model_share(148 + c, :, :) * 1e-9 + Ex(148 + c, 2:end - 1, 2:end - 1))); axis equal tight; caxis([-1e-8 1e-8])
%     subplot(3, 4, 11); imagesc(squeeze(is_model_normal(:, :, 423 + c) * 1e-2 + Txx(:, :, 423 + c))); axis equal tight; caxis([-1e-1 1e-1])
%     subplot(3, 4, 12); imagesc(squeeze(is_model_share(:, :, 423 + c) * 1e-9 + Ex(2:end - 1, 2:end - 1, 423 + c))); axis equal tight; caxis([-1e-8 1e-8])

    subplot(2,2,1); imagesc(squeeze(Txx(:, 42, :))); axis equal tight; caxis([-0.5 0.5]); % z=200がPLLAフィルムの座標
    subplot(2,2,2); imagesc(squeeze(Tyy(:, 42, :))); axis equal tight; caxis([-0.5 0.5]);
    subplot(2,2,3); imagesc(squeeze(Ex(:, :, 202))); axis equal tight; caxis([-0.5e-4 0.5e-4]);
    subplot(2,2,4); imagesc(squeeze(Tyz(:, :, 202))); axis equal tight; caxis([-1e-2 1e-2]);
    %% デバック用2024/12/11
%     saveas(gcf, sprintf('image_55deg/image_%04d.png', s))
  end

  clc
  sprintf('回転数: %d回/%d回', s, para.solution.nt)
  time = toc / s * (para.solution.nt - s);
  tt(1, s) = time;
  sprintf('残り時間: %d時間 %d分%0.3f秒', round(rem(time / 3600, 60)), rem(round(time / 60), 60), round(rem(time, 60), 3))
  %   data(s,1:18) = sum(Ez(:,:,655:672),[1,2]);
  %% 観測波形
  dataTzz(s, 1) = sum(sum(Tzz(21:80, 21:80, 205)));
  dataTyz(s, 1) = sum(sum(Tyz(21:80, 21:80, 205)));

  % Exの平均電界
  % 1203 なぜか振幅が上昇していく一方
  dataEx(s, 1) = sum(sum(Ex(21:80, 21:80, 201)));
  dataEx(s, 2) = sum(sum(Ex(21:80, 21:80, 202)));
  dataEx(s, 3) = sum(sum(Ex(21:80, 21:80, 203)));  
  dataEx(s, 4) = sum(sum(Ex(21:80, 21:80, 204)));
  dataEx(s, 5) = sum(sum(Ex(21:80, 21:80, 205)));
  dataEx(s, 6) = sum(sum(Ex(21:80, 21:80, 206)));
%   dataEx(s, 7) = sum(sum(Ex(21:80, 21:80, 207)));
%   dataEx(s, 8) = sum(sum(Ex(21:80, 21:80, 208)));
%   dataEx(s, 9) = sum(sum(Ex(21:80, 21:80, 209)));
%   dataEx(s, 10) = sum(sum(Ex(21:80, 21:80, 210)));


end
T = toc

%%

figure;
plot(dataEx(:,1))
% writematrix(dataTxx, "dataTxx_H_10.csv")
% writematrix(dataEy, "dataEy_H_10.csv")
% writematrix(dataEz1, "dataEz1.csv")
% writematrix(dataEz2, "dataEz2.csv")
% writematrix(dataEz3, "dataEz3.csv")
% writematrix(dataEz4, "dataEz4.csv")
% writematrix(dataEz5, "dataEz5.csv")

%% グラフ描写
figure(2);
plot(dataTzz)

figure(3);
plot(dataTyz);

figure(4);
plot(dataEx(:,2));

% save Result/Ex_rotate55deg_rate0 dataEx

writematrix(dataTzz, "Result/0deg/Tzz_z205.csv");
writematrix(dataTyz, "Result/0deg/Tyz_z205.csv");
% 
% figure(4);
% plot(dataEx);
%  plot(data(3000:6000,3)-data(3000:6000,18))
%  ylim([-1.5e-2 1.5e-2])
% writematrix(data,'wave1_Ex.csv')
% save('wave1_Ex_1018')

% %%
% volumeViewer(model2)

% %%
% clc
% size(model)

% size(model(:, :, 200:end - 200))

% model2 = single(ones(352, 455, 846 + 20)) * 1000;
% model2(:, :, 11:end - 10) = model(:, :, 200:end - 200);

% is_model2 = false(352, 455, 846 + 20);
% is_model2(:, :, 11:end - 10) = is_model(:, :, 200:end - 200);

% input_model2 = false(352, 455, 846 + 20);
% input_model2(:, :, 11:end - 10) = input_model(:, :, 200:end - 200);

% %%
% model = model2;
% is_model = is_model2;
% input_model = input_model2;

% %%
% % figure
% % imagesc(squeeze(model2(:,round(end/2),:)))
% %
% % %%
% %
% % save('model_1025_radius_small_z', 'model', "input_model", "is_model");
% %
