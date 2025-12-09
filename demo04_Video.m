clear,clc;close all
warning off
addpath(genpath(pwd))
obj = VideoReader('traffic.avi');
numFrames = obj.NumberOfFrames;
model = read(obj);       
data = double(squeeze(model(:,:,1,:)));
Xe=data;
Xn=Xe/max(Xe(:));

K=size(Xe,2);
N=size(Xe,1);
noiselevel              =               1e-3;
sigma                   =               1.8;
band                    =               12;
A=tblur(N,sigma,band);
[N1,N2,N3]=size(A);
Bblur=tprod(A,Xn);

E=rand(N1,K,N3);
for k=1:N3
    Bnoise(:,:,k)=noiselevel*E(:,:,k)*(norm(Bblur(:,:,k),'fro')/norm(E(:,:,k),'fro'));
end

B=Bblur+Bnoise;
kmax              =          750;
TOL               =          -4;
bs                =          15;
omega             =          1;
eta               =          1;

linestyle={'bo-','kx-','m*-'};
fprintf(1,'Perform kmax = %2.0f iterations with the tRAK_a method.\n',kmax);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
[val_tRAKa,time_tRAKa,X_tRAKa]= tRAK_a(A,B,Xn,kmax,TOL,bs,omega);
fprintf(1,'Perform kmax = %2.0f iterations with the tAKSHBM method.\n',kmax);
[val_tAKSHBM,time_tAKSHBM,X_tAKSHBM,EL]= tAKSHBM(A,B,Xn,kmax,TOL,bs);
fprintf(1,'Perform kmax = %2.0f iterations with the tAKSHBM_II method.\n',kmax);
[val_tAKSHBMII,time_tAKSHBMII,X_tAKSHBMII]= tAKSHBM_II(A,B,Xn,kmax,TOL,bs,EL);

%
count_tRAKa = size(val_tRAKa, 2);
count_tAKSHBM = size(val_tAKSHBM, 2);
count_tAKSHBMII = size(val_tAKSHBMII, 2);

ssim_B=ssim(Xn,B);
ssim_tRAKa=ssim(Xn,X_tRAKa);
ssim_tAKSHBM=ssim(Xn,X_tAKSHBM);
ssim_tAKSHBMII=ssim(Xn,X_tAKSHBMII);

psnr_B=psnr(Xn,B);
psnr_tRAKa=psnr(Xn,X_tRAKa);
psnr_tAKSHBM=psnr(Xn,X_tAKSHBM);
psnr_tAKSHBMII=psnr(Xn,X_tAKSHBMII);

disp('==================================')
disp(['method', '     IT', '       CPU', '       lg(RSE)', '       SSIM', '       PSNR'])
disp(['tRAK_a', '    ', num2str(count_tRAKa), '     ', num2str(round(time_tRAKa(end),3)), '     ', num2str(round(val_tRAKa(end),3)), '        ', num2str(round(ssim_tRAKa,3)), '      ', num2str(round(psnr_tRAKa,3))])
disp(['tAKSHBM', '    ', num2str(count_tAKSHBM), '      ', num2str(round(time_tAKSHBM(end),3)), '    ', num2str(round(val_tAKSHBM(end),3)), '        ', num2str(round(ssim_tAKSHBM,3)), '      ', num2str(round(psnr_tAKSHBM,3))])
disp(['tAKSHBMII', '  ', num2str(count_tAKSHBMII), '      ', num2str(round(time_tAKSHBMII(end),3)), '   ', num2str(round(val_tAKSHBMII(end),3)), '        ', num2str(round(ssim_tAKSHBMII,3)), '      ', num2str(round(psnr_tAKSHBMII,3))])

figure(1)
subplot(221); imshow(Xn(:,:,20)); 
subplot(222); imshow(Xn(:,:,51));
subplot(223); imshow(Xn(:,:,72));
subplot(224); imshow(Xn(:,:,100));
figure(2)
subplot(221); imshow(B(:,:,20)); 
subplot(222); imshow(B(:,:,51));
subplot(223); imshow(B(:,:,72));
subplot(224); imshow(B(:,:,100));
figure(3)
subplot(221); imshow(X_tRAKa(:,:,20)); 
subplot(222); imshow(X_tRAKa(:,:,51));
subplot(223); imshow(X_tRAKa(:,:,72));
subplot(224); imshow(X_tRAKa(:,:,100));  
figure(4)
subplot(221); imshow(X_tAKSHBM(:,:,20)); 
subplot(222); imshow(X_tAKSHBM(:,:,51));
subplot(223); imshow(X_tAKSHBM(:,:,72));
subplot(224); imshow(X_tAKSHBM(:,:,100)); 
figure(5)
subplot(221); imshow(X_tAKSHBMII(:,:,20)); 
subplot(222); imshow(X_tAKSHBMII(:,:,51));
subplot(223); imshow(X_tAKSHBMII(:,:,72));
subplot(224); imshow(X_tAKSHBMII(:,:,100)); 

%%

legend_str={'tRAK\_a','tAKSHBM','tAKSHBM\_II'};

figure(6)
plot(val_tRAKa,linestyle{1},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tRAKa) / 5):length(val_tRAKa));
hold on
plot(val_tAKSHBM,linestyle{2},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBM) / 5):length(val_tAKSHBM));
hold on
plot(val_tAKSHBMII,linestyle{3},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBMII) / 5):length(val_tAKSHBMII));

LG=legend(legend_str,'Interpreter','latex');
LG.FontSize=13;
ylabel('lg(RSE)','Interpreter','latex','FontSize',13)
xlabel('Iteration','Interpreter','latex','FontSize',13)
grid on
xlim([0 650])

 

figure(7)
plot(time_tRAKa,val_tRAKa,linestyle{1},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tRAKa) / 5):length(val_tRAKa));
hold on
plot(time_tAKSHBM,val_tAKSHBM,linestyle{2},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBM) /5):length(val_tAKSHBM));
hold on

plot(time_tAKSHBMII,val_tAKSHBMII,linestyle{3},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBMII) / 5):length(val_tAKSHBMII));

LG=legend(legend_str,'Interpreter','latex');
LG.FontSize=13;
ylabel('lg(RSE)','Interpreter','latex','FontSize',13)
xlabel('CPU time','Interpreter','latex','FontSize',13)
grid on
xlim([0 60])
