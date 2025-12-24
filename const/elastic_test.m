density_water = 1000;
v_water = 1500;
K = density_water * v_water^2;

% 真鍮の情報
v_brass = 4390;
v_brass_s = 2120;
density_brass = 8730;

bC11 = density_brass * v_brass^2;
bC44 = density_brass * v_brass_s^2;
bC12 = bC11 - 2 * bC44;

c11 = [K 15.34e9 0]; % PLLA弾性マトリクス、J. Phys. Chem. B 114, 9, 2010, T. Lin, X.Liu
c12 = [K 5.25e9 0];
c13 = [K 10.01e9 0];
c33 = [K 28.62e9 0];
c44 = [0 13e9 0];
c66 = [0 3.53e9 0];



% zのみ空間分解能を高く設定している。
if flag
    dtdx.density_x = gpuArray(para.solution.dt / para.solution.dx / ((model(2:nx, :, :) + model(1:nx - 1, :, :)) / 2));
    dtdx.density_y = gpuArray(para.solution.dt / para.solution.dx / ((model(:, 2:ny, :) + model(:, 1:ny - 1, :)) / 2));
    dtdx.density_z = gpuArray(para.solution.dt / para.solution.dx / ((model(:, :, 2:nz) + model(:, :, 1:nz - 1)) / 2));

    dtdz.density_x = gpuArray(para.solution.dt / para.solution.dz / ((model(2:nx, :, :) + model(1:nx - 1, :, :)) / 2));
    dtdz.density_y = gpuArray(para.solution.dt / para.solution.dz / ((model(:, 2:ny, :) + model(:, 1:ny - 1, :)) / 2));
    dtdz.density_z = gpuArray(para.solution.dt / para.solution.dz / ((model(:, :, 2:nz) + model(:, :, 1:nz - 1)) / 2));


    dtdx.C11 = gpuArray(single(c11(is_model_normal + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C12 = gpuArray(single(c12(is_model_normal + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C13 = gpuArray(single(c13(is_model_normal + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C33 = gpuArray(single(c33(is_model_normal + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C44 = gpuArray(single(c44(is_model_share + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C66 = gpuArray(single(c66(is_model_share + 1)) * para.solution.dt / para.solution.dx);

    dtdz.C13 = gpuArray(single(c13(is_model_normal + 1)) * para.solution.dt / para.solution.dz);
    dtdz.C33 = gpuArray(single(c33(is_model_normal + 1)) * para.solution.dt / para.solution.dz);
    dtdz.C44 = gpuArray(single(c44(is_model_share + 1)) * para.solution.dt / para.solution.dz);

else
    dtdx.density_x = para.solution.dt / para.solution.dx / ((model(2:nx, :, :) + model(1:nx - 1, :, :)) / 2);
    dtdx.density_y = para.solution.dt / para.solution.dx / ((model(:, 2:ny, :) + model(:, 1:ny - 1, :)) / 2);
    dtdx.density_z = para.solution.dt / para.solution.dx / ((model(:, :, 2:nz) + model(:, :, 1:nz - 1)) / 2);

    dtdz.density_x = para.solution.dt / para.solution.dz / ((model(2:nx, :, :) + model(1:nx - 1, :, :)) / 2);
    dtdz.density_y = para.solution.dt / para.solution.dz / ((model(:, 2:ny, :) + model(:, 1:ny - 1, :)) / 2);
    dtdz.density_z = para.solution.dt / para.solution.dz / ((model(:, :, 2:nz) + model(:, :, 1:nz - 1)) / 2);


    dtdx.C11 = single(c11(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C12 = single(c12(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C13 = single(c13(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C33 = single(c33(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C44 = single(c44(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C66 = single(meanMatrix(c66(is_model_normal + 1))) * para.solution.dt / para.solution.dx;

    dtdz.C13 = single(c13(is_model_normal + 1)) * para.solution.dt / para.solution.dz;
    dtdz.C33 = single(c33(is_model_normal + 1)) * para.solution.dt / para.solution.dz;
    dtdz.C44 = single(meanMatrix(c44(is_model_normal + 1))) * para.solution.dt / para.solution.dz;

end

clear K c11 c12 c13 c33 c66 c44













