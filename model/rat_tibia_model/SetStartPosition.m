function startXposition = SetStartPosition(imageMatrix, startYPosition, absoluteCorticalThreshold)
    % 皮質骨の閾値(200 mg/cm^3)
    % https://doi.org/10.1302/0301-620X.93B4.25449
    cortical_threhold = 200;
    
    % 画像のサイズ
    [xSize, ySize] = size(imageMatrix);

    % 検索開始位置
    x = 1;
    y = startYPosition;

    % 閾値を用いて確実に皮質骨である位置までy座標をインクリメント
    while (absoluteCorticalThreshold > imageMatrix(x, y))
        x = x + 1;

        % もし皮質骨を発見できず最後まで行った場合は1を返す。
        if(x >= xSize)
            startXposition = 1;
            return 
        end
    end

    % 文献値から取った皮質骨の閾値以下になる値までy座標をデクリメント
    while (cortical_threhold < imageMatrix(x, y))
        x = x - 1;
        if(x <= 1)
            startXposition = 1;
            return 
        end
    end

    x = x + 1;

    startXposition = x;
end