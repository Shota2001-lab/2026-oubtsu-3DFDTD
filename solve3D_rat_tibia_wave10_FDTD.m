% function [T, Txx] = solve3D(para, model, flag) %#codegen
clc
clear
close all
%等方性　境界の圧電性カット
%%
para.solution = struct('dx', 44e-6, 'dt', 5e-9, 'nt', 5000); % 空間、時間分解能は1.5MHzで計算すること
wd = 0.5 - 0.5 * cos(2 * pi * 1.5e6 * para.solution.dt * (1:round(1/1.5e6/ para.solution.dt)));
para.wave = single(sin(2 * pi * 1.5e6 *  para.solution.dt * (1:round(1/1.5e6/ para.solution.dt)*10)));

%%
hann_wd = hann(numel(para.wave));   % ← numel or length が正解
hann_wd = hann_wd.';  

% hann window
% para.wave = para.wave.*hann_wd;

figure;
plot(para.wave)

model = 'model/rat-tibia-model';

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
is_model_normal(is_model_normal < 1) = 0;
is_model_share = single(is_model_normal(1:end-1, 1:end-1, 1:end-1));
is_model_share(is_model_share < 1) = 0;
% rate = struct('axcial', 1 - 10^(-2.1/20 * 100 * para.solution.dx), 'normal', 1 - 10^(-3.1/20 * 100 * para.solution.dx), 'share', 1 - 10^(-5.2/20 * 100 * para.solution.dx));
rate = struct('axcial', 0, 'normal', 0, 'share', 0); % 今回は減衰ゼロで回す
run 'const/elastic_homo'
%% モデルを見る
volumeViewer(input_model)
figure;


%% 入力波形作成
input_wave = single(zeros(1, para.solution.nt * 2));
input_wave(1, 1:length(para.wave)) = para.wave;

figure;
plot(input_wave)

%%
if flag
  run 'const/gpu_matrix_ForFDTD'
  is_model_share = gpuArray(is_model_share);
  is_model_normal = gpuArray(is_model_normal);
else
  run 'const/cpu_matrix'
end


a = figure;
a.Position = [50 -100 1200 750];
c = round(15e-3/ para.solution.dx/2);

tt = gpuArray(zeros(1, para.solution.nt));

dataTxx = gpuArray(single(zeros(para.solution.nt, 1)));
dataTxy = gpuArray(single(zeros(para.solution.nt, 1)));
dataTzz = gpuArray(single(zeros(para.solution.nt, 1)));


tic

%%
for s = 1:para.solution.nt

  [Txx, Tyy, Tzz] = send_wave(Txx, Tyy, Tzz, input_model, input_wave(s));

  [Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy] ...
    = FDTD3D_3(Ux, Uy, Uz, Txx, Tyy, Tzz, Tyz, Tzx, Txy,  ...
    dtdx ...
    , nx, ny, nz, is_model_normal, is_model_share);

  [Txx, Tyy, Tzz, hig] ...
    = higdon3D(Txx, Tyy, Tzz, hig, h, nx, ny, nz);

  %%%%

  if rem(s, 10) == 0
    drawnow
    %%
    subplot(2,2,1); imagesc(squeeze(Txx(:, 256, :))); axis equal tight; caxis([-0.5 0.5]); % z=200がPLLAフィルムの座標
    subplot(2,2,2); imagesc(squeeze(Tyy(:, 256, :))); axis equal tight; caxis([-0.5 0.5]);
    subplot(2,2,3); imagesc(squeeze(Txy(:, 256, :))); axis equal tight; 

    %%
    saveas(gcf, sprintf('image10/image_%04d.png', s))
  end

  clc
  sprintf('回転数: %d回/%d回', s, para.solution.nt)
  time = toc / s * (para.solution.nt - s);
  tt(1, s) = time;
  sprintf('残り時間: %d時間 %d分%0.3f秒', round(rem(time / 3600, 60)), rem(round(time / 60), 60), round(rem(time, 60), 3))
  %% 観測波形
  dataTxx(s, 1) = Txx(280, 260, 110);
  dataTxy(s, 1) = Txy(280, 260, 110);
  dataTzz(s, 1) = Tzz(280, 260, 110);

end
T = toc

%% 

figure;
plot(dataTxx)

figure(2);
plot(dataTzz)

figure(3);
plot(dataTxy);

writematrix(dataTxx,'wave1_Txx.csv')
writematrix(dataTxy,'wave1_Txy.csv')
writematrix(dataTzz,'wave1_Tzz.csv')

