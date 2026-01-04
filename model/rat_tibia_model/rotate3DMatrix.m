%% 送波器を回転させるコードのテスト
function rotatedMatrix = rotate3DMatrix(inputMatrix, axis, angle)
    % rotate3DMatrix: 3次元行列内の1で表現された円盤を指定軸に沿って回転
    % 入力:
    %   inputMatrix - 3次元行列 (1が円盤、0が背景)
    %   axis - 回転軸 ('x', 'y', 'z' のいずれか)
    %   angle - 回転角度（deg）
    % 出力:
    %   rotatedMatrix - 回転後の3次元行列
    
    % 度数をラジアンに変換
    angle = deg2rad(angle);

    % 入力行列のサイズ取得
    [dimX, dimY, dimZ] = size(inputMatrix);
    
    % 行列内の1の位置を取得 (インデックス形式)
    [X, Y, Z] = ind2sub(size(inputMatrix), find(inputMatrix == 1));
    points = [X, Y, Z]'; % 座標を列ベクトル形式に

    % 回転軸に基づく回転行列を構築
    switch axis
        case 'x'
            R = [
                1, 0, 0;
                0, cos(angle), -sin(angle);
                0, sin(angle), cos(angle)
            ];
        case 'y'
            R = [
                cos(angle), 0, sin(angle);
                0, 1, 0;
                -sin(angle), 0, cos(angle)
            ];
        case 'z'
            R = [
                cos(angle), -sin(angle), 0;
                sin(angle), cos(angle), 0;
                0, 0, 1
            ];
        otherwise
            error('軸は ''x'', ''y'', ''z'' のいずれかを指定してください。');
    end

    % 回転行列を適用
    rotatedPoints = R * (points - [dimX; dimY; dimZ] / 2); % 中心基準に調整して回転
    rotatedPoints = rotatedPoints + [dimX; dimY; dimZ] / 2; % 元の位置に戻す

    % 座標を丸めてインデックス形式に戻す
    rotatedPoints = round(rotatedPoints);
    
    % 有効な範囲内の座標に制限
    validIdx = all(rotatedPoints > 0 & rotatedPoints <= [dimX; dimY; dimZ], 1);
    rotatedPoints = rotatedPoints(:, validIdx);

    % 回転後の行列を構築
    rotatedMatrix = zeros(size(inputMatrix));
    for i = 1:size(rotatedPoints, 2)
        rotatedMatrix(rotatedPoints(1, i), rotatedPoints(2, i), rotatedPoints(3, i)) = 1;
    end
end
