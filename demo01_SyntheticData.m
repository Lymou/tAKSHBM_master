clear,clc; close all;
addpath(genpath(pwd))
N3             =             15;
K              =             10;
N1             =             1000;
N2             =             500;
r              =             150;
kappa          =             2;

for k=1:N3
    [U,~]=qr(randn(N1,r),0);
    [V,~]=qr(randn(N2,r),0);
    S=diag(1+(kappa-1).*rand(r,1));
    A(:,:,k)=U*S*V';
end
Xe=randn(N2,K,N3);
B=tprod(A,Xe);
Xn=MinimumNormSolution(A,B,zeros(N2,K,N3));
%
kmax=30000;
TOL=-6;
bs=4;
omega=1;
eta=1;

fprintf(1,'Perform kmax = %2.0f iterations with the tRAK_a method.\n',kmax);
[val_tRAKa,time_tRAKa,X_tRAKa]= tRAK_a(A,B,Xn,kmax,TOL,bs,omega);
fprintf(1,'Perform kmax = %2.0f iterations with the tAKSHBM method.\n',kmax);
[val_tAKSHBM,time_tAKSHBM,X_tAKSHBM,EL]= tAKSHBM(A,B,Xn,kmax,TOL,bs);
fprintf(1,'Perform kmax = %2.0f iterations with the tAKSHBM_II method.\n',kmax);
[val_tAKSHBMII,time_tAKSHBMII,X_tAKSHBMII]= tAKSHBM_II(A,B,Xn,kmax,TOL,bs,EL);

count_tRAKa = size(val_tRAKa, 2);
count_tAKSHBM = size(val_tAKSHBM, 2);
count_tAKSHBMII = size(val_tAKSHBMII, 2);

disp('==================================')
disp(['method', '        IT', '         CPU', '       lg(RSE)'])
disp(['tRAK_a', '      ', num2str(count_tRAKa), '        ', num2str(round(time_tRAKa(end),3)), '      ', num2str(round(val_tRAKa(end),3))])
disp(['tAKSHBM', '     ', num2str(count_tAKSHBM), '        ', num2str(round(time_tAKSHBM(end),3)), '      ', num2str(round(val_tAKSHBM(end),3))])
disp(['tAKSHBMII', '   ', num2str(count_tAKSHBMII), '        ', num2str(round(time_tAKSHBMII(end),3)), '      ', num2str(round(val_tAKSHBMII(end),3))])


