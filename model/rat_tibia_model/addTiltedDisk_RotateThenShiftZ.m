function V = addTiltedDisk_RotateThenShiftZ(V, center, L, phiDeg, dz, val, y0, z0)
    % 回転軸：y=y0, z=z0 の x軸（x方向直線）
    k  = [1;0;0];          % axisDir
    p0 = [0; y0; z0];      % axisPoint（xは任意）

    % 厚みは1セルに固定
    thickness = 1;
    halfT = thickness/2;   % = 0.5

    % 1) 中心を軸まわりに回転（中心も動く）
    phi = deg2rad(phiDeg);
    c = center(:);
    c = p0 + rodriguesRotate(c - p0, k, phi);

    % 2) 傾けた後で z 方向に並行移動
    c(3) = c(3) + dz;

    % 3) 円板の法線も同じ回転を適用（初期法線は z向き）
    n0 = [0;0;1];
    n  = rodriguesRotate(n0, k, phi);
    n  = n / norm(n);

    % 4) 描画範囲（バウンディングボックス）
    B = null(n.'); e1 = B(:,1); e2 = B(:,2);
    ext = abs(e1)*L + abs(e2)*L + abs(n)*halfT;

    mins = max([1;1;1], floor(c - ext));
    maxs = min(size(V).', ceil(c + ext));

    xs = mins(1):maxs(1); ys = mins(2):maxs(2); zs = mins(3):maxs(3);
    [X,Y,Z] = ndgrid(xs,ys,zs);

    % 5) 円板判定：平面距離 & 平面内半径
    vx = X - c(1); vy = Y - c(2); vz = Z - c(3);
    distPlane = vx*n(1) + vy*n(2) + vz*n(3);  % dot(v,n)

    px = vx - distPlane*n(1);
    py = vy - distPlane*n(2);
    pz = vz - distPlane*n(3);
    r2 = px.^2 + py.^2 + pz.^2;

    mask = (abs(distPlane) <= halfT) & (r2 <= L^2);

    % 6) 書き込み
    sub = V(xs,ys,zs);
    sub(mask) = val;
    V(xs,ys,zs) = sub;
end

function vRot = rodriguesRotate(v, k, theta)
    v = v(:); k = k(:)/norm(k);
    vRot = v*cos(theta) + cross(k,v)*sin(theta) + k*(dot(k,v))*(1-cos(theta));
end

