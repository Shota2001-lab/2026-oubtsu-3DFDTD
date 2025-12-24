  %% 圧電性
  % % PLLA
  % (出典：https://www.proquest.com/docview/2901811556?pq-origsite=gscholar&fromopenview=true&sourcetype=Dissertations%20&%20Theses)
  e14 = 2.7e-2;
  e25 = -e14;

  %
  ip1 = [0.7e-9, 2.5*8.85e-9]; %[ε: nF/m] 二列目がPLLAの値(比誘電率＊真空誘電率）
  % ip2 = [0.7e-9, 50e-9];
  % ip3 = [0.7e-9, 50e-9];

%   sigma1 = [1e-2, 1e-16]; % https://www.jstage.jst.go.jp/article/tsjc/2012/0/2012_249/_pdf/-char/ja
  % 適当な値デバック用12/03かなりこれが効いてくる
  sigma1 = [1e-2, 5e-1]; % DOI: 10.1016, Polymer 48(2007) 4213-4225
  % sigma2 = [1e-2, 1e-1];
  % sigma3 = [1e-2, 1e-1];

  % 圧電セラミック
  % e31 = -13;
  % e32 = e31;
  % e33 = 23.1;
  % e15 = 14.4;
  %
  % e14 = 0;
  % e25 = -e14;
  % e24 = e15;
  %
  % ip1 = [0.7e-9, 20.1e-9]; %[ε: nF/m]
  % ip2 = [0.7e-9, 20.1e-9];
  % ip3 = [0.7e-9, 20.1e-9];
  %
  % sigma1 = [1e-2, 1e-6];
  % sigma2 = [1e-2, 1e-2];
  % sigma3 = [1e-2, 1e-1];

  % Dip = D ./ [ip1(2), ip2(2), ip3(2)];
  dtdx.ip = para.solution.dt / para.solution.dx / ip1(2);
  dtdz.ip = para.solution.dt / para.solution.dz / ip1(2);

  rate.sigmaip = sigma1(2) ./ ip1(2) * para.solution.dt;
  % sigmaip2 = sigma2(2) ./ ip2(2) * dt;
  % sigmaip3 = sigma3(2) ./ ip3(2) * dt;

  e = [0, 0, 0, e14, 0, 0;
    0, 0, 0, 0, e25, 0;
    0, 0, 0, 0, 0, 0];

  clear e14 e25 ip1 sigma1




  
