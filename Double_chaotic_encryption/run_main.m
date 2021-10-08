clear all;
close all;
clc;
corr_plot_flag = 0;                 %是否画相邻像素点相关性分析图

% IMG = imread('./425gaopao.jpeg');
% IMG = imresize(IMG,[225,300]);
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
u2 = abs(sin(h * pi)/2) /10 + 0.8;
num = t0 + N;
[xk1,yk1] = Logistic_2D(u1,u2,x0,y0,num);
% t1 = mod(N,1000);
options = odeset('RelTol',1e-3,'AbsTol',[1e-4 1e-4 1e-4]);
[T1,Y1] = ode45(@Liu_new,[0 2000],[0.18 1.05 0.11],options);
% figure(1)
% plot(Y1(:,1),Y1(:,2))

Y_new(:,1) = xk1(t0+1 : t0 + N)';
Y_new(:,2) = yk1(t0+1 : t0 + N)';
Y_new(:,3:5) = Y1(t1+1:t1 + N,:);
figure(1)
imshow(uint8(IMG))


obj1 = image_encryption(IMG,m,n,Y_new);
blur_img1 = obj1.encryption();

% obj2 = image_encryption(IMG1,m,n,New_Y2);
% blur_img2 = obj2.encryption();

 deblur_img = obj1.decryption(blur_img1);

% [NPCR,UACI]= diff_attack (double(blur_img1),double(blur_img2))    % 分析差分攻击

figure(2)
imshow(uint8(blur_img1))

figure(3)
imshow(deblur_img)

% figure(4)
% imhist(uint8(IMG))
% xlabel({'','','   '})
% ylabel('像素点个数')
% figure(5)
% imhist(uint8(blur_img1))
% xlabel({'','','   '})
% ylabel('像素点个数')

near_point = double(obj1.near_pixel(blur_img1));   %相邻像素相关性分析
orig_img_shan = obj1.energy_shan(double(IMG))   % 计算明文图像信息熵
blur_img_shan = obj1.energy_shan(blur_img1)   % 计算密文图像信息熵
% [NPCR,UACI]= diff_attack (double(blur_img1),double(blur_img2))    % 分析差分攻击

if corr_plot_flag == 1
    figure(6)
    scatter(near_point(1000:2000,1),near_point(1000:2000,2),'*')
    xlabel('位置为(x,y)的像素点灰度值')
    ylabel('位置为(x,y+1)的像素点灰度值')
    title('水平方向相关性')
    h_corre = corrcoef(near_point(:,1),near_point(:,2))
    figure(7)
    scatter(near_point(1000:2000,1),near_point(1000:2000,3),'*')
    xlabel('位置为(x,y)的像素点灰度值')
    ylabel('位置为(x+1,y)的像素点灰度值')
    title('垂直方向相关性')
    v_corre = corrcoef(near_point(:,1),near_point(:,3))
    figure(8)
    scatter(near_point(1000:2000,1),near_point(1000:2000,4),'*')
    xlabel('位置为(x,y)的像素点灰度值')
    ylabel('位置为(x+1,y+1)的像素点灰度值')
    title('对角线方向相关性')
    diag_corre = corrcoef(near_point(:,1),near_point(:,4))
end

imwrite(IMG,'image\orignal_image.jpg')
imwrite(uint8(blur_img1),'image\blur_image.jpg')
