density_water = 1000;
v_water = 1500;
K = density_water * v_water^2;

v_brass = 4390;
v_brass_s = 2120;
density_brass = 8730;
% density_bone = 2000;

density_bake = 1270;
v_bake = 2590;
v_bake_s = 1295;

density_air = 1;
v_air = 340;
v_air_s = 0;


% v_bone = 4000;
% v_bone_s = 2000;
%%
K = density_water * v_water^2;
bC11 = density_brass * v_brass^2;
bC44 = density_brass * v_brass_s^2;
bC12 = bC11 - 2 * bC44;

bakeC11 = density_bake * v_bake^2;
bakeC44 = density_bake * v_bake_s^2;
bakeC12 = bakeC11 - 2 * bakeC44;

airC11 = density_air * v_air^2;
airC44 = density_air * v_air_s^2;
airC12 = airC11 - 2 * airC44;

% be-ku 2,590 m/s 1270kg/m3
% boneC11 = density_bone * v_bone^2;
% boneC44 = density_bone * v_bone_s^2;
% boneC12 = boneC11 - 2 * boneC44;

% c11 = [K boneC11 bC11];
% c12 = [K boneC12 bC12];
% c13 = [K boneC12 bC12];
% c33 = [K boneC11 bC11];
% c44 = [0 boneC44 bC44];
% c66 = [0 boneC44 bC44];
%水1　骨2 真鍮3　ベーク4　空気5

c11 = [K 25.3e9 bC11 bakeC11 airC11];
c12 = [K 12.5e9 bC12 bakeC12 airC12];
c13 = [K 12.8e9 bC12 bakeC12 airC12];
c33 = [K 35.3e9 bC11 bakeC11 airC11];
c44 = [0 8.8e9 bC44 bakeC44 airC44];
c66 = [0 6.6e9 bC44 bakeC44 airC44];

clear K

density = [density_water density_bone density_brass];
density = single(density);


if flag
    dtdx.density_x = gpuArray(para.solution.dt / para.solution.dx / ((density(model(2:nx, :, :)) + density(model(1:nx - 1, :, :))) / 2));
    dtdx.density_y = gpuArray(para.solution.dt / para.solution.dx / ((density(model(:, 2:ny, :)) + density(model(:, 1:ny - 1, :)))/ 2));
    dtdx.density_z = gpuArray(para.solution.dt / para.solution.dx / ((density(model(:, :, 2:nz)) + density(model(:, :, 1:nz - 1))) / 2));

    dtdx.C11 = gpuArray(single(c11(model)) * para.solution.dt / para.solution.dx);
    dtdx.C12 = gpuArray(single(c12(model)) * para.solution.dt / para.solution.dx);
    dtdx.C13 = gpuArray(single(c13(model)) * para.solution.dt / para.solution.dx);
    dtdx.C33 = gpuArray(single(c33(model)) * para.solution.dt / para.solution.dx);
    dtdx.C44 = gpuArray(single(meanMatrix(c44(model))) * para.solution.dt / para.solution.dx);
    dtdx.C66 = gpuArray(single(meanMatrix(c66(model))) * para.solution.dt / para.solution.dx);

else
    dtdx.density_x = para.solution.dt / para.solution.dx / ((density(model(2:nx, :, :)) + density(model(1:nx - 1, :, :))) / 2);
    dtdx.density_y = para.solution.dt / para.solution.dx / ((density(model(:, 2:ny, :)) + density(model(:, 1:ny - 1, :)))/ 2);
    dtdx.density_z = para.solution.dt / para.solution.dx / ((density(model(:, :, 2:nz)) + density(model(:, :, 1:nz - 1))) / 2);

    dtdx.C11 = single(c11(model)) * para.solution.dt / para.solution.dx;
    dtdx.C12 = single(c12(model)) * para.solution.dt / para.solution.dx;
    dtdx.C13 = single(c13(model)) * para.solution.dt / para.solution.dx;
    dtdx.C33 = single(c33(model)) * para.solution.dt / para.solution.dx;
    dtdx.C44 = single(meanMatrix(c44(model))) * para.solution.dt / para.solution.dx;
    dtdx.C66 = single(meanMatrix(c66(model))) * para.solution.dt / para.solution.dx;

end

clear K c11 c12 c13 c33 c66 c44
