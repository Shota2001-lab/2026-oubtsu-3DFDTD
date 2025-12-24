function endXposition = SetEndPosition(image_matrix, start_Yposition, absolute_cortical_threhold)
    % 皮質骨の閾値(200 mg/cm^3)
    % https://doi.org/10.1302/0301-620X.93B4.25449
    cortical_threhold = 200;

    % 検索開始位置
    [x_size, y_size] = size(image_matrix);
    x = x_size;
    y = start_Yposition;

    % 閾値を用いて確実に皮質骨である位置までy座標をインクリメント
    while (absolute_cortical_threhold > image_matrix(x, y))

        % もし皮質骨を発見できず最後まで行った場合は最大座標を返す。
        if(x <= 1)
            endXposition = x_size;
            return 
        end
        x = x - 1;
    end

    % 文献値から取った皮質骨の閾値以下になる値までy座標をデクリメント
    while (cortical_threhold < image_matrix(x, y))
        if(x >= x_size)
            endXposition = x_size;
            return 
        end
        x = x + 1;
    end

    x = x - 1;

    endXposition = x;
end