%%% Lorenz超混沌系统%%%
function dy = Lorenz(t,y)
    a = 10;
    b = 8/3;
    c = 28;
    r = -1;
   
    dy = zeros(4,1);
    dy(1) = a *( y(2)-y(1)) + y(4);
    dy(2) = c * y(1) - y(1) * y(3) - y(2);
    dy(3) = y(1) * y(2) - b * y(3);
    dy(4) = r * y(4) - y(2) * y(3);
end
