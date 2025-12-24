function out_matrix = meanMatrix(matrix) %#codegen
  %MEANMATRIX この関数の概要をここに記述
  %   詳細説明をここに記述

  out_matrix = (matrix(1:end - 1, 1:end - 1, 1:end - 1) + matrix(2:end, 1:end - 1, 1:end - 1) + matrix(1:end - 1, 2:end, 1:end - 1) + matrix(1:end - 1, 1:end - 1, 2:end) ...
  + matrix(2:end, 2:end, 1:end - 1) + matrix(1:end - 1, 2:end, 2:end) + matrix(2:end, 1:end - 1, 2:end) + matrix(2:end, 2:end, 2:end)) / 8;
end
