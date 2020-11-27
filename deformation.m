function [xout] = deformation(xin)
    xout = [xin(1) + xin(1)^3, xin(2) + 0.1*sin(8*xin(1))];
end