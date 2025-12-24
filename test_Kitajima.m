clear 
close all
clc

%% サンプルモデル作成

para = struct('dx', 50e-6, 'dz', 10e-6, 'dt', 8e-9, 'nt', 5000); % dz方向だけPLLAフィルムに厚みを持たせるため分解能を高くする。

L = 5e-3; % 空間の1辺の長さ
L_plate = 3e-3; % 板の１辺の長さ
r_trans = 1e-3; % センサの直径
d_trans = 1e-3; % センサと板の間の距離
d = 1e-3; % 板の厚み

dif_1 = (round(L/para.dx) - round(L_plate/para.dx))/2;
dif_2 = (round(L/para.dz) - round(d/para.dz))/2;
PLLA_thickness = round(100e-6/para.dz); % PLLAフィルムの厚みは50μ
dif_3 = round((L/para.dx - r_trans/para.dx)/2);

model = single(zeros(round(L/para.dx),round(L/para.dx),round(L/para.dz))); % 空間モデル作成
is_model = model;

is_model(dif_1 + 1:end - dif_1,dif_1 + 1:end - dif_1, dif_2 + 1:dif_2 + PLLA_thickness) = 1; % 板の部分を作成

input_model = model;

O_x = round(L/para.dx/2); % 中心座標
O_y = O_x;
O_z = round(dif_2 + (d_trans/para.dz));

for i = 1:round(L/para.dx) % 直径1mmの円板作成
    for k = 1:round(L/para.dx)

        if sqrt(((i - O_x))^2 + ((k - O_y))^2) < r_trans/para.dx/2
            
           input_model(i,k,O_z) = 1;
        
        end
    end
end
        
model(dif_1 + 1:end - dif_1,dif_1 + 1:end - dif_1,dif_2 + 1:dif_2 + PLLA_thickness) = 1290; % PLLAの密度（一様）
model(model == 0) = 1000;


is_model = logical(is_model);
input_model = logical(input_model);

%%
% % volumeViewer(input_model)
save model_Test_100u model is_model input_model


%%
% a = figure;
% a.Position = [50 -100 1200 750];
% imagesc(model(:,:,201))