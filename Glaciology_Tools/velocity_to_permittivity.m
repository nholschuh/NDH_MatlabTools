function output = velocity_to_permittivity(V)
%% Given a velocity in m/s, this computes an electric permittivity
cair_import

output = (cair./V).^2;

end