clear,clc;
warning off
PathName = './dataSet/feathers_ms';
Files = dir(strcat([PathName '/'   ],'*.png'));
for item=1:length(Files)
    FileName=Files(item).name;
    data(:,:,item)=imresize(double(imread(FileName)),.5859);
end

Xe=permute(data,[1,3,2]);
Xn             =           Xe;
K              =           size(Xe,2);
noiselevel     =           1e-3;
N              =           size(Xe,1);
sigma          =           1.8;
band           =           12;
A=tblur(N,sigma,band);
[N1,N2,N3]=size(A);
Bblur=tprod(A,Xe);

E=rand(N1,K,N3);
for k=1:N3
    Bnoise(:,:,k)=noiselevel*E(:,:,k)*(norm(Bblur(:,:,k),'fro')/norm(E(:,:,k),'fro'));
end

B=Bblur+Bnoise;



kmax         =         500;
TOL          =         -10;
bs           =         10;
omega        =         1;
eta          =         1;


fprintf(1,'Perform kmax = %2.0f iterations with the tRAK_a method.\n',kmax);
[val_tRAKa,time_tRAKa,X_tRAKa]= tRAK_a(A,B,Xn,kmax,TOL,bs,omega);
fprintf(1,'Perform kmax = %2.0f iterations with the tAKSHBM method.\n',kmax);
[val_tAKSHBM,time_tAKSHBM,X_tAKSHBM,EL]= tAKSHBM(A,B,Xn,kmax,TOL,bs);
fprintf(1,'Perform kmax = %2.0f iterations with the tAKSHBM_II method.\n',kmax);
[val_tAKSHBMII,time_tAKSHBMII,X_tAKSHBMII]= tAKSHBM_II(A,B,Xn,kmax,TOL,bs,EL);

%
Xn=permute(Xn,[1,3,2]);
B=permute(B,[1,3,2]);
X_tRAKa=permute(X_tRAKa,[1,3,2]);
X_tAKSHBM=permute(X_tAKSHBM,[1,3,2]);
X_tAKSHBMII=permute(X_tAKSHBMII,[1,3,2]);

%

count_tRAKa = size(val_tRAKa, 2);
count_tAKSHBM = size(val_tAKSHBM, 2);
count_tAKSHBMII = size(val_tAKSHBMII, 2);

ssim_B=ssim(uint16(Xn),uint16(B));
ssim_tRAKa=ssim(uint16(Xn),uint16(X_tRAKa));
ssim_tAKSHBM=ssim(uint16(Xn),uint16(X_tAKSHBM));
ssim_tAKSHBMII=ssim(uint16(Xn),uint16(X_tAKSHBMII));

psnr_B=psnr(uint16(Xn),uint16(B));
psnr_tRAKa=psnr(uint16(Xn),uint16(X_tRAKa));
psnr_tAKSHBM=psnr(uint16(Xn),uint16(X_tAKSHBM));
psnr_tAKSHBMII=psnr(uint16(Xn),uint16(X_tAKSHBMII));

disp('=========================MultiSpectralImage================================')
disp(['method', '     IT', '       CPU', '        lg(RSE)', '       SSIM', '       PSNR'])
disp(['tRAK_a', '     ', num2str(count_tRAKa), '      ', num2str(round(time_tRAKa(end),4)), '    ', num2str(val_tRAKa(end)), '      ', num2str(ssim_tRAKa), '    ', num2str(psnr_tRAKa)])
disp(['tAKSHBM', '    ', num2str(count_tAKSHBM), '      ', num2str(round(time_tAKSHBM(end),4)), '    ', num2str(val_tAKSHBM(end)), '      ', num2str(ssim_tAKSHBM), '    ', num2str(psnr_tAKSHBM)])
disp(['tAKSHBMII', '  ', num2str(count_tAKSHBMII), '      ', num2str(round(time_tAKSHBMII(end),4)), '     ', num2str(val_tAKSHBMII(end)), '      ', num2str(ssim_tAKSHBMII), '    ', num2str(psnr_tAKSHBMII)])


frame=[13,30,15];
figure(1)
imshow(uint16(Xn(:,:,frame))); 
figure(2)
imshow(uint16(B(:,:,frame))); 
figure(3)
imshow(uint16(X_tRAKa(:,:,frame))); 
figure(4)
imshow(uint16(X_tAKSHBM(:,:,frame))); 
figure(5)
imshow(uint16(X_tAKSHBMII(:,:,frame)));

%

legend_str={'tRAK\_a','tAKSHBM','tAKSHBM\_II'};
linestyle={'bo-','kx-','m*-'};
figure(6)
plot(val_tRAKa,linestyle{1},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tRAKa) / 8):length(val_tRAKa));
hold on
plot(val_tAKSHBM,linestyle{2},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBM) / 8):length(val_tAKSHBM));
hold on
plot(val_tAKSHBMII,linestyle{3},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBMII) / 8):length(val_tAKSHBMII));

LG=legend(legend_str,'Interpreter','latex');
LG.FontSize=13;
ylabel('lg(RSE)','Interpreter','latex','FontSize',13)
xlabel('Iteration','Interpreter','latex','FontSize',13)
grid on

 

figure(7)
plot(time_tRAKa,val_tRAKa,linestyle{1},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tRAKa) / 12):length(val_tRAKa));
hold on
plot(time_tAKSHBM,val_tAKSHBM,linestyle{2},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBM) / 15):length(val_tAKSHBM));
hold on

plot(time_tAKSHBMII,val_tAKSHBMII,linestyle{3},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBMII) / 15):length(val_tAKSHBMII));

LG=legend(legend_str,'Interpreter','latex');
LG.FontSize=13;
ylabel('lg(RSE)','Interpreter','latex','FontSize',13)
xlabel('CPU time','Interpreter','latex','FontSize',13)
grid on
