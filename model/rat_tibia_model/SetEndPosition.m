function endXposition = SetEndPosition(imageMatrix, startYPosition, absoluteCorticalThreshold)
    % 皮質骨の閾値(200 mg/cm^3)
    % https://doi.org/10.1302/0301-620X.93B4.25449
    corticalThreshold = 200;

    % 検索開始位置
    [xSize, ySize] = size(imageMatrix);
    x = xSize;
    y = startYPosition;

    % 閾値を用いて確実に皮質骨である位置までy座標をインクリメント
    while (absoluteCorticalThreshold > imageMatrix(x, y))

        % もし皮質骨を発見できず最後まで行った場合は最大座標を返す。
        if(x <= 1)
            endXposition = xSize;
            return 
        end
        x = x - 1;
    end

    % 文献値から取った皮質骨の閾値以下になる値までy座標をデクリメント
    while (corticalThreshold < imageMatrix(x, y))
        if(x >= xSize)
            endXposition = xSize;
            return 
        end
        x = x + 1;
    end

    x = x - 1;

    endXposition = x;
end