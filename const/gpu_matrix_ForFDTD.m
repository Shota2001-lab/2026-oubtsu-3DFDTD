%% �ｿｽ�ｿｽ�ｿｽ�ｿｽ�ｿｽ�ｿｽ
Txx(:, :, :) = gpuArray(single(zeros(nx, ny, nz)));
Tyy(:, :, :) = gpuArray(single(zeros(nx, ny, nz)));
Tzz(:, :, :) = gpuArray(single(zeros(nx, ny, nz)));

Txy(:, :, :) = gpuArray(single(zeros(nx + 1, ny + 1, nz + 1)));
Tyz(:, :, :) = gpuArray(single(zeros(nx + 1, ny + 1, nz + 1)));
Tzx(:, :, :) = gpuArray(single(zeros(nx + 1, ny + 1, nz + 1)));

Ux(:, :, :) = gpuArray(single(zeros(nx + 1, ny, nz)));
Uy(:, :, :) = gpuArray(single(zeros(nx, ny + 1, nz)));
Uz(:, :, :) = gpuArray(single(zeros(nx, ny, nz + 1)));

h.a1 = single(1);
h.b1 = single((h.a1 * v_water * para.solution.dt - para.solution.dx) / (h.a1 * v_water * para.solution.dt + para.solution.dx));
h.b2 = h.b1;
h.b3 = h.b1;
h.b4 = h.b1;
h.b5 = h.b1;
h.b6 = h.b1;

h.d1 = single(0.00001);
h.d2 = h.d1;

hig.hig1 = gpuArray(single(zeros(6, ny, nz)));
hig.hig2 = gpuArray(single(zeros(6, ny, nz)));
hig.hig3 = gpuArray(single(zeros(nx, 6, nz)));
hig.hig4 = gpuArray(single(zeros(nx, 6, nz)));
hig.hig5 = gpuArray(single(zeros(nx, ny, 6)));
hig.hig6 = gpuArray(single(zeros(nx, ny, 6)));

hig.hig7 = gpuArray(single(zeros(6, ny, nz)));
hig.hig8 = gpuArray(single(zeros(6, ny, nz)));
hig.hig9 = gpuArray(single(zeros(nx, 6, nz)));
hig.hig10 = gpuArray(single(zeros(nx, 6, nz)));
hig.hig11 = gpuArray(single(zeros(nx, ny, 6)));
hig.hig12 = gpuArray(single(zeros(nx, ny, 6)));

hig.hig13 = gpuArray(single(zeros(6, ny, nz)));
hig.hig14 = gpuArray(single(zeros(6, ny, nz)));
hig.hig15 = gpuArray(single(zeros(nx, 6, nz)));
hig.hig16 = gpuArray(single(zeros(nx, 6, nz)));
hig.hig17 = gpuArray(single(zeros(nx, ny, 6)));
hig.hig18 = gpuArray(single(zeros(nx, ny, 6)));

