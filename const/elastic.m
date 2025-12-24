density_water = 1000;
v_water = 1500;
K = density_water * v_water^2;
c11 = [K 2.5e9]; % PLLA弾性マトリクス、Macromolecules 2012, 45, 7019-7026
c12 = [K 6.48e9];
c13 = [K 7.15e9];
c33 = [K 17.87e9];
c44 = [0 15.03e9];
c66 = [0 3.9e9];

% c11 = [K 1e9]; % PLLA弾性マトリクス、Macromolecules 2012, 45, 7019-7026
% c12 = [K 1e9];
% c13 = [K 1e9];
% c33 = [K 1e9];
% c44 = [0 1e9];
% c66 = [0 1e9];


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
    dtdx.C44 = gpuArray(single(meanMatrix(c44(is_model_normal + 1))) * para.solution.dt / para.solution.dx);
    dtdx.C66 = gpuArray(single(meanMatrix(c66(is_model_normal + 1))) * para.solution.dt / para.solution.dx);

    dtdz.C13 = gpuArray(single(c13(is_model_normal + 1)) * para.solution.dt / para.solution.dz);
    dtdz.C33 = gpuArray(single(c33(is_model_normal + 1)) * para.solution.dt / para.solution.dz);
    dtdz.C44 = gpuArray(single(meanMatrix(c44(is_model_normal + 1))) * para.solution.dt / para.solution.dz);

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
    dtdx.C44 = single(meanMatrix(c44(is_model_normal + 1))) * para.solution.dt / para.solution.dx;
    dtdx.C66 = single(meanMatrix(c66(is_model_normal + 1))) * para.solution.dt / para.solution.dx;

    dtdz.C13 = single(c13(is_model_normal + 1)) * para.solution.dt / para.solution.dz;
    dtdz.C33 = single(c33(is_model_normal + 1)) * para.solution.dt / para.solution.dz;
    dtdz.C44 = single(meanMatrix(c44(is_model_normal + 1))) * para.solution.dt / para.solution.dz;

end

clear K c11 c12 c13 c33 c66 c44













