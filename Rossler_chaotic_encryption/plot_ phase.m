% 混沌系统相图
clear all;
close all;
n = 256^2;
options = odeset('RelTol',1e-3,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
% [T,Y] = ode45(@hyperchaos,[0 1000],[0 -40 2 -300],options);
[T,Y] = ode45(@Rossler,[0 800],[-50 -15 70 35],options);
figure(1)
subplot(2,2,1); 
plot3(Y(:,1),Y(:,2),Y(:,3))
xlabel('x');
ylabel('y');
zlabel('z');

subplot(2,2,2);
plot3(Y(:,1),Y(:,2),Y(:,4))
xlabel('x');
ylabel('y');
zlabel('w');

subplot(2,2,3);
plot3(Y(:,1),Y(:,3),Y(:,4))
xlabel('x');
ylabel('z');
zlabel('w');
subplot(2,2,4);
plot3(Y(:,2),Y(:,3),Y(:,4))
xlabel('y');
ylabel('z');
zlabel('w');

figure(2)
plot3(Y(:,1),Y(:,2),Y(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
