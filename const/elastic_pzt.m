density_water = 1000;
v_water = 1500;
K = density_water * v_water^2;
% c11 = [K 25.3e9 0];
% c12 = [K 12.5e9 0];
% c13 = [K 12.8e9 0];
% c33 = [K 35.3e9 0];
% c44 = [0 8.8e9 0];
% c66 = [0 6.6e9 0];

v_brass = 4390;
v_brass_s = 2120;
density_brass = 8730;
density_pzt = 7620;

%%
K = density_water * v_water^2;
bC11 = density_brass * v_brass^2;
bC44 = density_brass * v_brass_s^2;
bC12 = bC11 - 2 * bC44;


c11 = [K 81.1e9+24.4e9*2 bC11];%C12+2myu
c12 = [K 81.1e9 bC12];%ramda
c13 = [K 81.1e9 bC12];
c33 = [K 81.1e9+24.4e9*2 bC11];
c44 = [0 24.4e9 bC44];
c66 = [0 24.4e9 bC44];
clear K

density = [density_water density_pzt density_brass];
density = single(density);

dtdx.density_x = para.solution.dt / para.solution.dx / ((density(model(2:nx, :, :)) + density(model(1:nx - 1, :, :))) / 2);
dtdx.density_y = para.solution.dt / para.solution.dx / ((density(model(:, 2:ny, :)) + density(model(:, 1:ny - 1, :)))/ 2);
dtdx.density_z = para.solution.dt / para.solution.dx / ((density(model(:, :, 2:nz)) + density(model(:, :, 1:nz - 1))) / 2);

% C11 = single((c11(1 + is_model(:, :, :))));
% C33 = single((c33(1 + is_model(:, :, :))));
% C12 = single((c12(1 + is_model(:, :, :))));
% C13 = single((c13(1 + is_model(:, :, :))));

dtdx.C11 = single(c11(model)) * para.solution.dt / para.solution.dx;
dtdx.C12 = single(c12(model)) * para.solution.dt / para.solution.dx;
dtdx.C13 = single(c13(model)) * para.solution.dt / para.solution.dx;
dtdx.C33 = single(c33(model)) * para.solution.dt / para.solution.dx;
dtdx.C44 = single(meanMatrix(c44(model))) * para.solution.dt / para.solution.dx;
dtdx.C66 = single(meanMatrix(c66(model))) * para.solution.dt / para.solution.dx;

clear K c11 c12 c13 c33 c66 c44
