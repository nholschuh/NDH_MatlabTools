function output = gauss_window(square_dim,sd)

if exist('sd') == 0
    sd = 2;
end

gauss_a = normpdf(-sd:sd*2/(square_dim-1):sd);
gauss_b = normpdf(-sd:sd*2/(square_dim-1):sd);
output = gauss_b'*gauss_a;
output(find(output < 0.01)) = 0;

if square_dim == 1
    output = 1;
end

end