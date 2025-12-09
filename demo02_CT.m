clc;clear;warning off
addpath(genpath(pwd))
PathName = './dataSet/c2';
Files = dir(strcat([PathName '\'   ],'*.dcm'));
for item=1:length(Files)
    FileName=Files(item).name;
    data(:,:,item)=imresize(double(dicomread(FileName)),0.5);
end

frames=randperm(size(data,3),10);
Xe=data(:,:,frames);

%
[N2,K,N3]=size(Xe);
N1           =         5000;
A            =         double(sptenrand([N1,N2,N3],0.1));
B            =         tprod(A,Xe);
Xn           =         Xe;
%
kmax         =         20000;

TOL          =         -4;
bs           =         7;
omega        =         1;
eta          =         1;

%
fprintf(1,'Perform kmax = %2.0f iterations with the tRAK_a method.\n',kmax);
[val_tRAKa,time_tRAKa,X_tRAKa] = tRAK_a(A,B,Xn,kmax,TOL,bs,omega);
fprintf(1,'Perform kmax = %2.0f iterations with the tAKSHBM method.\n',kmax);
[val_tAKSHBM,time_tAKSHBM,X_tAKSHBM,EL]= tAKSHBM(A,B,Xn,kmax,TOL,bs);
fprintf(1,'Perform kmax = %2.0f iterations with the tAKSHBM_II method.\n',kmax);
[val_tAKSHBMII,time_tAKSHBMII,X_tAKSHBMII]= tAKSHBM_II(A,B,Xn,kmax,TOL,bs,EL);


count_tRAKa = size(val_tRAKa, 2);
count_tAKSHBM = size(val_tAKSHBM, 2);
count_tAKSHBMII = size(val_tAKSHBMII, 2);


ssim_tRAKa = ssim(uint8(Xn),uint8(X_tRAKa));
ssim_tAKSHBM = ssim(uint8(Xn),uint8(X_tAKSHBM));
ssim_tAKSHBMII = ssim(uint8(Xn),uint8(X_tAKSHBMII));


psnr_tRAKa = psnr(uint8(Xn),uint8(X_tRAKa));
psnr_tAKSHBM = psnr(uint8(Xn),uint8(X_tAKSHBM));
psnr_tAKSHBMII = psnr(uint8(Xn),uint8(X_tAKSHBMII));

%%
disp('====================== Perform CT =================================')
disp(['method', '     IT', '       CPU', '        lg(RSE)', '      SSIM', '       PSNR'])
disp(['tRAK_a', '     ', num2str(count_tRAKa), '      ', num2str(round(time_tRAKa(end),4)), '    ', num2str(val_tRAKa(end)), '      ', num2str(ssim_tRAKa), '     ', num2str(psnr_tRAKa)])
disp(['tAKSHBM', '    ', num2str(count_tAKSHBM), '       ', num2str(round(time_tAKSHBM(end),4)), '     ', num2str(val_tAKSHBM(end)), '      ', num2str(ssim_tAKSHBM), '      ', num2str(psnr_tAKSHBM)])
disp(['tAKSHBMII', '  ', num2str(count_tAKSHBMII), '       ', num2str(round(time_tAKSHBMII(end),4)), '     ', num2str(val_tAKSHBMII(end)), '      ', num2str(ssim_tAKSHBMII), '    ', num2str(psnr_tAKSHBMII)])


%%
figure(1)
subplot(251);imagesc(Xn(:,:,1)); axis image off
subplot(252);imagesc(Xn(:,:,2)); axis image off
subplot(253);imagesc(Xn(:,:,3)); axis image off
subplot(254);imagesc(Xn(:,:,4)); axis image off
subplot(255);imagesc(Xn(:,:,5)); axis image off
subplot(256);imagesc(Xn(:,:,6)); axis image off
subplot(257);imagesc(Xn(:,:,7)); axis image off
subplot(258);imagesc(Xn(:,:,8)); axis image off
subplot(259);imagesc(Xn(:,:,9)); axis image off
subplot(2,5,10);imagesc(Xn(:,:,10)); axis image off

figure(2)
subplot(251);imagesc(X_tRAKa(:,:,1)); axis image off
subplot(252);imagesc(X_tRAKa(:,:,2)); axis image off
subplot(253);imagesc(X_tRAKa(:,:,3)); axis image off
subplot(254);imagesc(X_tRAKa(:,:,4)); axis image off
subplot(255);imagesc(X_tRAKa(:,:,5)); axis image off
subplot(256);imagesc(X_tRAKa(:,:,6)); axis image off
subplot(257);imagesc(X_tRAKa(:,:,7)); axis image off
subplot(258);imagesc(X_tRAKa(:,:,8)); axis image off
subplot(259);imagesc(X_tRAKa(:,:,9)); axis image off
subplot(2,5,10);imagesc(X_tRAKa(:,:,10)); axis image off

figure(3)
subplot(251);imagesc(X_tAKSHBM(:,:,1)); axis image off
subplot(252);imagesc(X_tAKSHBM(:,:,2)); axis image off
subplot(253);imagesc(X_tAKSHBM(:,:,3)); axis image off
subplot(254);imagesc(X_tAKSHBM(:,:,4)); axis image off
subplot(255);imagesc(X_tAKSHBM(:,:,5)); axis image off
subplot(256);imagesc(X_tAKSHBM(:,:,6)); axis image off
subplot(257);imagesc(X_tAKSHBM(:,:,7)); axis image off
subplot(258);imagesc(X_tAKSHBM(:,:,8)); axis image off
subplot(259);imagesc(X_tAKSHBM(:,:,9)); axis image off
subplot(2,5,10);imagesc(X_tAKSHBM(:,:,10)); axis image off


figure(4)
subplot(251);imagesc(X_tAKSHBMII(:,:,1)); axis image off
subplot(252);imagesc(X_tAKSHBMII(:,:,2)); axis image off
subplot(253);imagesc(X_tAKSHBMII(:,:,3)); axis image off
subplot(254);imagesc(X_tAKSHBMII(:,:,4)); axis image off
subplot(255);imagesc(X_tAKSHBMII(:,:,5)); axis image off
subplot(256);imagesc(X_tAKSHBMII(:,:,6)); axis image off
subplot(257);imagesc(X_tAKSHBMII(:,:,7)); axis image off
subplot(258);imagesc(X_tAKSHBMII(:,:,8)); axis image off
subplot(259);imagesc(X_tAKSHBMII(:,:,9)); axis image off
subplot(2,5,10);imagesc(X_tAKSHBMII(:,:,10)); axis image off

%
legend_str={'tRAK\_a','tAKSHBM','tAKSHBM\_II'};
linestyle={'bo-','kx-','m*-'};
figure(5)
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


figure(6)
plot(time_tRAKa,val_tRAKa,linestyle{1},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tRAKa) / 12):length(val_tRAKa));
hold on
plot(time_tAKSHBM,val_tAKSHBM,linestyle{2},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBM) / 8):length(val_tAKSHBM));
hold on

plot(time_tAKSHBMII,val_tAKSHBMII,linestyle{3},...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerIndices', 1:floor(length(val_tAKSHBMII) / 8):length(val_tAKSHBMII));

LG=legend(legend_str,'Interpreter','latex');
LG.FontSize=13;
ylabel('lg(RSE)','Interpreter','latex','FontSize',13)
xlabel('CPU time','Interpreter','latex','FontSize',13)
grid on



