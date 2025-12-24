function [Txx,Tyy,Tzz] = send_wave(Txx,Tyy,Tzz,input_model,value) %#codegen
%SEND_WAVE この関数の概要をここに記述
%   詳細説明をここに記述
  Txx(input_model) = value;
  Tyy(input_model) = value;
  Tzz(input_model) = value;
end
