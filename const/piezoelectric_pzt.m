  %% 圧電性
  % % %二次元骨
%   e31 = 0.15e-3;
%   e32 = e31;
%   e33 = e31;
%   e15 = 2e-3;
% 
%   e14 = 10e-3;
%   e25 = -e14;
%   e24 = e15;
%   %
%   ip1 = [0.7e-9, 50e-9]; %[ε: nF/m]
%   % ip2 = [0.7e-9, 50e-9];
%   % ip3 = [0.7e-9, 50e-9];
% 
%   sigma1 = [1e-2, 1e-1];
  % sigma2 = [1e-2, 1e-1];
  % sigma3 = [1e-2, 1e-1];

  % 圧電セラミック
  e31 = -13;
  e32 = e31;
  e33 = 23.1;
  e15 = 14.4;
  
  e14 = 0;
  e25 = -e14;
  e24 = e15;
  
%   ip1 = [0.7e-9, 20.1e-9]; %[ε: nF/m]
%   ip2 = [0.7e-9, 20.1e-9];
%   ip3 = [0.7e-9, 20.1e-9];

  ip1 = [0.7e-9, 20.1e-9]; %[ε: nF/m]
  ip2 = [0.7e-9, 20.1e-9];
  ip3 = [0.7e-9, 20.1e-9];
  
  sigma1 = [1e-2, 1e-6];
  sigma2 = [1e-2, 1e-2];
  sigma3 = [1e-2, 1e-1];

  % Dip = D ./ [ip1(2), ip2(2), ip3(2)];
  dtdx.ip1 = para.solution.dt / para.solution.dx / ip1(2);
  dtdx.ip2 = para.solution.dt / para.solution.dx / ip2(2);
  dtdx.ip3 = para.solution.dt / para.solution.dx / ip3(2);

  rate.sigmaip1 = sigma1(2) ./ ip1(2) * para.solution.dt;
  rate.sigmaip2 = sigma2(2) ./ ip2(2) * para.solution.dt;
  rate.sigmaip3 = sigma3(2) ./ ip3(2) * para.solution.dt;

  e = [0, 0, 0, e14, e15, 0;
    0, 0, 0, e24, e25, 0;
    e31, e32, e33, 0, 0, 0];

  clear e14 e15 e24 e25 e31 e32 e33 ip1 sigma1
