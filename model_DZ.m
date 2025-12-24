clear 
close all
clc

%% サンプルモデル作成

para = struct('dx', 61e-6, 'dt', 8e-9, 'nt', 5000);

L = 50e-3; % 空間の1辺の長さ
L_platex = 10e-3; % 板の長さ（短辺）
L_platey = 14e-3; % 板の長さ（長辺）
r_trans = 10e-3; % センサの直径
d_trans = 30e-3; % センサと板の間の距離
d1 = 14e-3; % 直角二等辺三角形の斜辺
d2 = d1/sqrt(2); % 直角二等辺三角形のその他の辺
d3 = d2;
d = d1/2; % 頂点から底辺までの距離

% 中心座標作成
O_x = round(L/para.dx/2); % 中心座標(x)
O_y = O_x; % 中心座標(y)
O_z = O_x; % 中心座標(z)

% 空間の端からプリズム板の端までの距離
dif_x = round(((L/para.dx) - (L_platex/para.dx))/2);
dif_y = round(((L/para.dx) - (L_platey/para.dx))/2);
dif_z = round(((L/para.dx) - (d/para.dx))/2);
dif_3 = round((L/para.dx - r_trans/para.dx)/2);
O_z_round = round((dif_z) - (d_trans/para.dx)); % トランスデューサ面の中心座標(z)


model = single(zeros(round(L/para.dx),round(L/para.dx),round(L/para.dx))); % 空間モデル作成
is_model = model;
input_model = model;
%% 三角柱モデル作成(yz平面が直角二等辺三角形)

for i = 1:round(L_platex/para.dx) % x方向

    for j = 1:round(d/para.dx) % z方向
    
        is_model(dif_x + i - 1,dif_y + j - 1:end - (dif_y + j - 1),dif_z  + j - 1) = 1;
    end

end
model = is_model*3220; % モデル作成（ガラスSF11の密度 = 3220 g/cm^3)

% volumeViewer(is_model)
% is_model(dif_x + 1:end - dif_x,dif_x + 1:end - dif_x,dif_z + 1:end - dif_z) = 1; % 板の部分を作成
%% 入力トランスデューサを作る（収束型）

focus_d = 10e-3/para.dx; % 焦点距離
kyoku = 20e-3/para.dx; % 曲率 (開口 60°で計算）

step_num = round(L/para.dx);

f = waitbar(0,'start modeling');
for i = 1:round(L/para.dx) % 直径4mmの円板作成
    for j = 1:round(L/para.dx)
        
   
        r = sqrt(((i - O_x))^2 + ((j - O_y))^2 ); % 中心からの距離
       

        if r < r_trans/para.dx/2 
            l = round(sqrt(kyoku^2 + r^2) - focus_d);
            input_model(i,j,O_z_round + l) = 1;
        end
        
       
    end
    waitbar(i/step_num,f,'Processing model...')
end

waitbar(1,f,'Please wait for second')
% model(dif_x + 1:end - dif_x,dif_x + 1:end - dif_x,dif_z + 1:end - dif_z) = 5000; % ガラスの密度（一様）
% model(model == 0) = 1000;


is_model = logical(is_model);
input_model = logical(input_model);

%%
% figure;
% imagesc(squeeze(input_model(:,:,1)))
close(f)
volumeViewer(input_model + is_model)
save model_DZ model is_model input_model
% imagesc(input_model(:,:,57))