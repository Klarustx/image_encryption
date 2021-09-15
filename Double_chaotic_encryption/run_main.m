clear all;
close all;
clc;
corr_plot_flag = 0;                 %�Ƿ��������ص�����Է���ͼ

% IMG = imread('./425gaopao.jpeg');
% IMG = imresize(IMG,[225,300]);
IMGS = imread('./425gaopao.jpeg');
IMG = rgb2gray(IMGS);
IMG = imresize(IMG,[224,300]);   %�ü�ͼ��
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

% [NPCR,UACI]= diff_attack (double(blur_img1),double(blur_img2))    % ������ֹ���

figure(2)
imshow(uint8(blur_img1))

figure(3)
imshow(deblur_img)

% figure(4)
% imhist(uint8(IMG))
% xlabel({'','','   '})
% ylabel('���ص����')
% figure(5)
% imhist(uint8(blur_img1))
% xlabel({'','','   '})
% ylabel('���ص����')

near_point = double(obj1.near_pixel(blur_img1));   %������������Է���
orig_img_shan = obj1.energy_shan(double(IMG))   % ��������ͼ����Ϣ��
blur_img_shan = obj1.energy_shan(blur_img1)   % ��������ͼ����Ϣ��
% [NPCR,UACI]= diff_attack (double(blur_img1),double(blur_img2))    % ������ֹ���



if corr_plot_flag == 1
    figure(6)
    scatter(near_point(1000:2000,1),near_point(1000:2000,2),'*')
    xlabel('λ��Ϊ(x,y)�����ص�Ҷ�ֵ')
    ylabel('λ��Ϊ(x,y+1)�����ص�Ҷ�ֵ')
    title('ˮƽ���������')
    h_corre = corrcoef(near_point(:,1),near_point(:,2))
    figure(7)
    scatter(near_point(1000:2000,1),near_point(1000:2000,3),'*')
    xlabel('λ��Ϊ(x,y)�����ص�Ҷ�ֵ')
    ylabel('λ��Ϊ(x+1,y)�����ص�Ҷ�ֵ')
    title('��ֱ���������')
    v_corre = corrcoef(near_point(:,1),near_point(:,3))
    figure(8)
    scatter(near_point(1000:2000,1),near_point(1000:2000,4),'*')
    xlabel('λ��Ϊ(x,y)�����ص�Ҷ�ֵ')
    ylabel('λ��Ϊ(x+1,y+1)�����ص�Ҷ�ֵ')
    title('�Խ��߷��������')
    diag_corre = corrcoef(near_point(:,1),near_point(:,4))
end





imwrite(IMG,'image\orignal_image.jpg')
imwrite(uint8(blur_img1),'image\blur_image.jpg')




