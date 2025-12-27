density_water = 1000;
v_water = 1500;
K = density_water * v_water^2;

% rat tibia 
% assumption: homogeneous structure
c11 = [K 18.1e9]; 
c12 = [K 7.7e9];
c13 = [K 7.7e9];
c33 = [K 18.1e9];
c44 = [0 5.2e9];
c66 = [0 5.2e9];

if flag
    dtdx.density_x = gpuArray(para.solution.dt / para.solution.dx / ((model(2:nx, :, :) + model(1:nx - 1, :, :)) / 2));
    dtdx.density_y = gpuArray(para.solution.dt / para.solution.dx / ((model(:, 2:ny, :) + model(:, 1:ny - 1, :)) / 2));
    dtdx.density_z = gpuArray(para.solution.dt / para.solution.dx / ((model(:, :, 2:nz) + model(:, :, 1:nz - 1)) / 2));

    dtdx.C11 = gpuArray(single(c11(is_model_normal + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C12 = gpuArray(single(c12(is_model_normal + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C13 = gpuArray(single(c13(is_model_normal + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C33 = gpuArray(single(c33(is_model_normal + 1)) * para.solution.dt / para.solution.dx);
    dtdx.C44 = gpuArray(single(meanMatrix(c44(is_model_normal + 1))) * para.solution.dt / para.solution.dx);
    dtdx.C66 = gpuArray(single(meanMatrix(c66(is_model_normal + 1))) * para.solution.dt / para.solution.dx);

else
    dtdx.density_x = para.solution.dt / para.solution.dx / ((model(2:nx, :, :) + model(1:nx - 1, :, :)) / 2);
    dtdx.density_y = para.solution.dt / para.solution.dx / ((model(:, 2:ny, :) + model(:, 1:ny - 1, :)) / 2);
    dtdx.density_z = para.solution.dt / para.solution.dx / ((model(:, :, 2:nz) + model(:, :, 1:nz - 1)) / 2);


    dtdx.C11 = single(c11(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C12 = single(c12(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C13 = single(c13(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C33 = single(c33(is_model_normal + 1)) * para.solution.dt / para.solution.dx;
    dtdx.C44 = single(meanMatrix(c44(is_model_normal + 1))) * para.solution.dt / para.solution.dx;
    dtdx.C66 = single(meanMatrix(c66(is_model_normal + 1))) * para.solution.dt / para.solution.dx;

end

clear K c11 c12 c13 c33 c66 c44













