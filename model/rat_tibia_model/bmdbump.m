% 各要素はスペースまたはカンマ(,)で区切ります
% 各行の終わり（次の行に移る）にセミコロン(;)を置きます

% 3x3 の場合
sheetName = 'z=284tri'; % 数字だけ変える
myRange = [41 2 43 4]; % bmd_entyuuから範囲を参照
bmd_3x3 = readmatrix("bmd_xy.xlsx", 'Sheet', sheetName, 'Range', myRange);

% 9x9 の場合
sheetName = 'z=284tri'; % 数字だけ変える
myRange = [39 6 47 14]; % bmd_entyuuから範囲を参照
bmd_9x9 = readmatrix("bmd_xy.xlsx", 'Sheet', sheetName, 'Range', myRange);

figure;
imagesc(bmd_3x3);