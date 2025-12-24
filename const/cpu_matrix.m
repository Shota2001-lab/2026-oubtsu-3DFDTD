%% �ｿｽ�ｿｽ�ｿｽ�ｿｽ�ｿｽ�ｿｽ
Txx(:, :, :) = (single(zeros(nx, ny, nz)));
Tyy(:, :, :) = (single(zeros(nx, ny, nz)));
Tzz(:, :, :) = (single(zeros(nx, ny, nz)));

Txy(:, :, :) = (single(zeros(nx + 1, ny + 1, nz + 1)));
Tyz(:, :, :) = (single(zeros(nx + 1, ny + 1, nz + 1)));
Tzx(:, :, :) = (single(zeros(nx + 1, ny + 1, nz + 1)));

Ux(:, :, :) = (single(zeros(nx + 1, ny, nz)));
Uy(:, :, :) = (single(zeros(nx, ny + 1, nz)));
Uz(:, :, :) = (single(zeros(nx, ny, nz + 1)));

Ex = (single(zeros(nx + 1, ny + 1, nz + 1)));
Ey = (single(zeros(nx + 1, ny + 1, nz + 1)));
Ez = (single(zeros(nx + 1, ny + 1, nz + 1)));

tEx = (single(zeros(nx + 1, ny + 1, nz + 1)));
tEy = (single(zeros(nx + 1, ny + 1, nz + 1)));
tEz = (single(zeros(nx + 1, ny + 1, nz + 1)));

h.a1 = single(1);
h.b1 = single((h.a1 * v_water * para.solution.dt - para.solution.dx) / (h.a1 * v_water * para.solution.dt + para.solution.dx));
h.b2 = h.b1;
h.b3 = h.b1;
h.b4 = h.b1;
h.b5 = h.b1;
h.b6 = h.b1;

h.d1 = single(0.00001);
h.d2 = h.d1;

hig.hig1 = (single(zeros(6, ny, nz)));
hig.hig2 = (single(zeros(6, ny, nz)));
hig.hig3 = (single(zeros(nx, 6, nz)));
hig.hig4 = (single(zeros(nx, 6, nz)));
hig.hig5 = (single(zeros(nx, ny, 6)));
hig.hig6 = (single(zeros(nx, ny, 6)));

hig.hig7 = (single(zeros(6, ny, nz)));
hig.hig8 = (single(zeros(6, ny, nz)));
hig.hig9 = (single(zeros(nx, 6, nz)));
hig.hig10 = (single(zeros(nx, 6, nz)));
hig.hig11 = (single(zeros(nx, ny, 6)));
hig.hig12 = (single(zeros(nx, ny, 6)));

hig.hig13 = (single(zeros(6, ny, nz)));
hig.hig14 = (single(zeros(6, ny, nz)));
hig.hig15 = (single(zeros(nx, 6, nz)));
hig.hig16 = (single(zeros(nx, 6, nz)));
hig.hig17 = (single(zeros(nx, ny, 6)));
hig.hig18 = (single(zeros(nx, ny, 6)));

% data=(zeros(nt,2));
