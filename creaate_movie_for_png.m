%% 初期化
clear
clc
close all

%% 動画作成

path = 'image_55deg/';
v = VideoWriter('movie/onlyPLLA/fai_45deg/movie_55deg.mp4', 'MPEG-4');

write0bj.FrameRate = 3;

open(v)
list = dir(append(path, "/*.png"));
error_image = [""];
for i = 1:length(list)
%     length(list)
    clc
    i
    image_data = imread(append(path, '/', list(i).name));
    try
        writeVideo(v, image_data)
    catch
        error_image(end+1) = string(list(i).name);
    end
end

close(v)
error_image