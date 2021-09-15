clear all;
close all;
clc;
corr_plot_flag = 0;                 %是否画相邻像素点相关性分析图

IMGS = imread('./425gaopao.jpeg');
IMG = rgb2gray(IMGS);
IMG = imresize(IMG,[224,300]);   %裁剪图像
IMG1 = IMG;
IMG1(32,56) = IMG(32,56) + 1;
t1 = mod(sum(sum(IMG)),256);
[m,n] = size(IMG);
N = m * n;
N0 = N /2;
aver =  mean(sum(sum(IMG)));
x0 = aver / m;
y0 = aver / n;
h = mod(sum(sum(IMG)),N);
t0 = mod(sum(sum(IMG)),256);
u1 = 0.995;
u1_sp = 0.995;
u2 = abs(sin(h * pi)/2) /10 + 0.8;
num = t0 + N;
[xk1,yk1] = Logistic_2D(u1,u2,x0,y0,num);
[xk1_sp,yk1_sp] = Logistic_2D(u1_sp,u2,x0,y0,num);
% t1 = mod(N,1000);
options = odeset('RelTol',1e-3,'AbsTol',[1e-4 1e-4 1e-4]);
[T1,Y1] = ode45(@Liu_new,[0 2000],[0.18 1.05 0.11],options);
[T1_sp,Y1_sp] = ode45(@Liu_new,[0 2000],[0.18001 1.05 0.11],options);
% figure(1)
% plot(Y1(:,1),Y1(:,2))

Y_new(:,1) = xk1(t0+1 : t0 + N)';
Y_new(:,2) = yk1(t0+1 : t0 + N)';
Y_new(:,3:5) = Y1(t1+1:t1 + N,:);

Y_new1(:,1) = xk1_sp(t0+1 : t0 + N)';
Y_new1(:,2) = yk1_sp(t0+1 : t0 + N)';
Y_new1(:,3:5) = Y1_sp(t1+1:t1 + N,:);
figure(1)
imshow(uint8(IMG))

obj1 = image_encryption(IMG,m,n,Y_new);
blur_img1 = obj1.encryption();

obj2 = image_encryption(IMG,m,n,Y_new1);
% blur_img2 = obj2.encryption();

 deblur_img1 = obj1.decryption(blur_img1);
 deblur_img2 = obj2.decryption(blur_img1);
[NPCR,UACI]= diff_attack (double(deblur_img1),double(deblur_img2))    % 分析差分攻击


% imwrite(IMG,'image\orignal_image.jpg')
imwrite(uint8(deblur_img2),'image\key2.jpg')




