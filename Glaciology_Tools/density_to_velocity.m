function output = density_to_velocity(rho_p,method)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% This function uses one of three mixing models to compute the
% electromagnetic wave speed for snow/firn, based on its density. Density
% should be provided in g/cc (0.917 being the value for ice).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% rho_p - Density (or densities) used to calculate velocity
% method - [1] Robin (1975), [2] Drews et al (2016), [3] Glen and Peren
%          (1975)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('method') == 0
    method = 1;
end


%%%%%%%%%%%%%% This section initiates a testing component, that compares
%%%%%%%%%%%%%% the different methods
if 0
    test_plot = 1;
    rho_p = 0.350:0.01:0.91;
    method = 1:3;
else
    test_plot = 0;
end

%%
%%%%%%%%%%%%%% Here we do the actual permittivity calculation
for i = 1:length(method)
    if method(i) == 1
        %%%%% Given a density (in grams/cc), this computes the electromagnetic wave speed from (Robin 1975)
        cair_import
        output(:,i) = cair./(1+0.851*rho_p);
    elseif method(i) == 2
        %%%%% Complex refractive index method from (Drews et al 2016)
        cair_import
        cice_import
        output(:,i) = 1./(((rho_p./0.917).*(cair/cice-1)+1)./cair);
    elseif method(i) == 3
        %%%%% Dielectric mixing model from (Glen and Paren, 1975)
        cice_import
        output(:,i) = cair./sqrt((1+0.469*rho_p./0.917).^3);
    end
end


%%%%%%%%%%%%%% Here we produce the test plot if requested
if test_plot == 1
    colors = parula(length(method)+2);
    hold off
    for i = 1:length(method)
        plot(output(:,i)/10^6,rho_p,'Color',colors(i+1,:))
        hold all
    end
    ylabel('Density (g/cc)')
    xlabel('Speed of Light (m/micros)')
    title('Density vs. Speed')
    grid on
    set(gca,'YDir','reverse')
    legend({'Robin (1975)','Drews et al (2016)','Glen and Paren (2016)'})
    NDH_Style()
end
        


end