function att = att_correlation(location,depth,uncorrected_power_dB,plotter);
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This calculates the attenuation based on a modification of Schroeder et
% al. (2016), which uses the correlation coefficient between depth and
% reflection power to determine the optimum value for N.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% location - the polar stereographic coordinates of the data
% depth - m below the surface (assuming ground data)
% uncorrected_power_dB - the picked reflection strength in dB
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Rename variables for efficiency
cice_import

d = depth;
up = uncorrected_power_dB;

original_ind = 1:length(d);
remove_inds = find(isnan(d) == 1);
d(remove_inds) = [];
up(remove_inds) = [];
location(remove_inds,:) = [];
original_ind(remove_inds) = [];

if exist('plotter') == 0
    plotter = 0;
end

%%%%%%%%%%%%%% Here we convert back to time to do the spherical spreading
%%%%%%%%%%%%%% correction
t = d*2/cice;
dt = 10^order(min(diff(t)));
t = round_to(t,dt);
picks = round(t/dt);
taxis = -dt:dt:max(t);

%%%%%%%%%%%%%% Here we compute the spherical spreading correction, based on
%%%%%%%%%%%%%% a surface density of 400 kg/m^3
disp('Performing Spherical Spreading Correction:')
    [Z P L theta_t theta_i true_time] = focusing_raytracing(0,0,taxis,0.400);
    spreading_effect = lp(L(picks)');
    
cp = up-spreading_effect';

att_rates = 0:0.01:30;
for i = 1:length(att_rates)
    p(i,:) = cp+2*d*att_rates(i)/1000;
end


clearvars -except d p location att_rates plotter up cp original_ind remove_inds




min_wind = 1000; %%%% The smallest window size to test (in m)
max_wind = 10000;
c0_thresh = 0.3; %%%%
Nh_thresh_height = 0.1;
Nh_thresh = 2.2;
cm_thresh = 0.01;


if plotter == 1
    figure(1)
    set(gcf,'Position',[248   386   958   295])
end


disp('Computing Local Attenuation Rates:')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Here we have a set of nested loops for:
%%%%%%%%%%  1) Identify the attenuation rate at each sample
%%%%%%%%%%  2) using a window size with the right constraints
for i = 1:length(d)
    dists = (location - location(i,:));
    dists = sqrt(dists(:,1).^2+dists(:,2).^2);
    
    window = min_wind;
    c0 = 0;
    Nh = Inf;
    cm = Inf;
   
    while (c0 < c0_thresh | Nh > Nh_thresh | cm > cm_thresh) & window < max_wind
        
        inds = find(dists < window);

        use_d = repmat(d(inds)',length(att_rates),1);
        use_p = p(:,inds);

        
        C = abs( ...
            sum((use_d-mean(use_d,2)).*(use_p - mean(use_p,2)),2) ./ ...
            (sqrt(sum((use_d-mean(use_d,2)).^2,2)) .* ...
            sqrt(sum((use_p-mean(use_p,2)).^2,2))) ...
            );
        
        c0 = C(1);  
        cm = min(C);
        Nh_inds = find(C < Nh_thresh_height);
        min_ind = find(min(C) == C);
        if length(Nh_inds) > 0
            Nh = max([abs(att_rates(min_ind) - att_rates(Nh_inds(end))) ...
                abs(att_rates(min_ind) - att_rates(Nh_inds(1)))]);
        else 
            Nh = Inf;
        end
        
        if plotter == 1
            
            subplot(1,3,1:2)
            hold off
            plot(att_rates,C,'Color','black')
            hold all
            ylim([0 1])
            plot_indicator_lines([c0_thresh,Nh_thresh_height],1,[0.5 0.5 0.5],1,':');
            if length(Nh_inds) > 0
                plot_indicator_lines(att_rates([Nh_inds(1) Nh_inds(end)]),2,[0.5 0.5 0.5],1,':');
            end
            text(0.8,0.8,['Nh = ',num2str(round_to(Nh,0.1))]);
            xlabel('Attenuation Rate (dB/km')
            ylabel('Correlation Coefficient')


            subplot(1,3,3)
            hold off
            plot(location(:,1)/1000,location(:,2)/1000,'.','Color','black','MarkerSize',2)
            hold all
            pi = 1:length(inds);
            if length(inds) > 100
                pi = 1:2:length(inds);
            end
            if length(inds) > 1000
                pi = 1:5:length(inds);
            end
            if length(inds) > 2500
                pi = 1:10:length(inds);
            end
            scatter(location(inds(pi),1)/1000,location(inds(pi),2)/1000,3,dists(inds(pi)),'filled')
            colormap(jet)
            axis equal
            pause(0.01)
            
        end
        window = window+50;
    end
    
    if window < max_wind
        att(original_ind(i)).window = window-50;
        att(original_ind(i)).rate = att_rates(find(min(C) == C));
        att(original_ind(i)).C = C;
    else
        att(original_ind(i)).window = NaN;
        att(original_ind(i)).rate = NaN;
        att(original_ind(i)).C = ones(size(C))*NaN;
    end
    
    if mod(i,100) == 0
        disp(['---- Completed sample ',num2str(i),' of ',num2str(length(original_ind))])
    end
    
end

for i = 1:length(remove_inds)
    att(remove_inds(i)).window = NaN;
    att(remove_inds(i)).rate = NaN;
    att(remove_inds(i)).C = ones(size(C))*NaN;
end

end
    







