%%%一种新的超混沌系统%%%
function dy = hyperchaos(t,y)
    a = 13;
    b = 36;
    c = 6;
    d = 0.9;
    e=0.5;

    dy = zeros(4,1);
    dy(1) = a * y(1) - 10 * y(2);
    dy(2) = - b* y(2) + y(1) * y(3) + e * y(4);
    dy(3) = y(1)^2 - c * y(3);
    dy(4) = y(1) * y(3) + d * y(4);
end
