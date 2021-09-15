
clear all;
close all;
n = 256^2;
options = odeset('RelTol',1e-3,'AbsTol',[1e-4 1e-4 1e-4]);
[T,Y] = ode45(@Liu_new,[0 500],[0.18 1.05 0.11],options);
figure(1)
plot(Y(:,1),Y(:,2))
xlabel('x');
ylabel('y');
figure(2)
plot(Y(:,1),Y(:,3))
xlabel('x');
ylabel('z');
figure(3)
plot(Y(:,2),Y(:,3))
xlabel('y');
ylabel('z');
