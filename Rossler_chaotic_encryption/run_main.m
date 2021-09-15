clear all;
close all;
clc;
% IMG = imread('./lena.jpg');
IMGS = imread('./gaopao.jpeg');
IMG = rgb2gray(IMGS);
IMG1 = IMG;
IMG(416,322)
IMG1(416,322) = IMG(416,322)+1;
% IMG = imresize(IMG,[256,256]);   %²Ã¼ôÍ¼Ïñ
t1 = mod(sum(sum(IMG)),256);
t2 = mod(sum(sum(IMG1)),256);
[m,n] = size(IMG);
N = m * n;
N0 = N /2;
figure(1)
imshow(IMG)
imwrite(IMG,'image\original_image.png');
options = odeset('RelTol',1e-3,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
% [T,Y] = ode45(@hyperchaos,[0 1000],[0 -40 2 -300],options);
% [T,Y] = ode45(@Lorenz,[0 5000],[0 -40 2 -300],options);
[T1,Y1] = ode45(@Rossler,[0 3000],[-50 -15 70 35],options);
[T2,Y2] = ode45(@Rossler,[0 4000],[-50 -15 70 35.00001],options);

New_Y1 =  Y1(t1:end,:);
New_Y2 =  Y1(t2:end,:);
obj1 = image_encryption(IMG,m,n,New_Y1);
blur_img1 = obj1.encryption();

obj2 = image_encryption(IMG1,m,n,New_Y2);
blur_img2 = obj2.encryption();


deblur_img = obj2.decryption(blur_img1);
[NPCR,UACI]= diff_attack (blur_img1,blur_img2)    % ·ÖÎö²î·Ö¹¥»÷

figure(2)
imshow(uint8(deblur_img))

near_point = obj1.near_pixel(IMG);   %ÏàÁÚÏñËØÏà¹ØÐÔ·ÖÎö
orig_img_shan = obj1.energy_shan(double(IMG))   % ¼ÆËãÃ÷ÎÄÍ¼ÏñÐÅÏ¢ìØ
blur_img_shan = obj1.energy_shan(blur_img1)   % ¼ÆËãÃÜÎÄÍ¼ÏñÐÅÏ¢ìØ
[NPCR,UACI]= diff_attack (blur_img1,blur_img2)    % ·ÖÎö²î·Ö¹¥»÷