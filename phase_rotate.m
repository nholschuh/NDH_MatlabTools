function result = phase_rotate(series,rotation)
% Rotate a given wavelet by a certain rotation angle (degrees)


x_f1 = fft(series);
%transform

R1 = [cos(deg2rad(rotation)) -sin(deg2rad(rotation)); sin(deg2rad(rotation)) cos(deg2rad(rotation))];
R2 = [cos(deg2rad(-rotation)) -sin(deg2rad(-rotation)); sin(deg2rad(-rotation)) cos(deg2rad(-rotation))];
for i = 1:length(x_f1)
    if imag(x_f1(i)) < 0
        R = R1;
    else
        R = R2;
    end
    x_f_temp(i,:) = [R*[real(x_f1(i)); imag(x_f1(i))]]';
end
x_f = x_f_temp(:,1) + sqrt(-1)*x_f_temp(:,2);

result = real(ifft(x_f));

end