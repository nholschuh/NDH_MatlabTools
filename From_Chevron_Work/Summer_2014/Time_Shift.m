function results = Time_Shift(seis0,time_axis0,seis1,time_axis1,plotter,method,stretch_restriction_mat)
% (C) Nick Holschuh - Chevron Corporation - 2014 (Nick.Holschuh@gmail.com)
% This code performs adaptive time warping a la Hale 2013, using different
% modifications designed by Nick Holschuh. The different warping methods
% are detailed below according to the method number in the code.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Index %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% seis0 - Seismic amplitudes for the baseline trace
% time_axis0 - The corresponding time scale
% seis1 - Seismic amplitudes for the monitor trace
% time_axis1 - The corresponding time scale
%
% plotter - 0 (for no results plotting) or 1 (for results plotting)
%
% method - Integer 1-6, with the corresponding methods defined below
%
% stretch_restriction_mat - a 5 value vector, defining
%          1 - Distance Constraint for amplitude error search (percentage)
%          2 - Distance Constraint for 1st Deriv. error search (percentage)
%          3 - Distance Constraint for 2nd Deriv. errir search (percentage)
%          4 - Distance Constraint for the Inst. Phase search (percentage)
%          5 - Supersample rate (Integer)
%
%%%%%%%%%%%%%%%%% Method Number Reference%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 1 - Dynamic Time Warp - Original Data Only - Forward Distance Accumulation
%%% 2 - Dyanimc Time Warp - Original Data Only - Forward and Backward Distance Accumulation
%%% 3 - Dynamic Time Warp v2 - Original Data and First Derivative
%%% 4 - Dynamic Time Warp v3 - Original Data and First and Second Derivative
%%% 5 - Dynamic Time Warp v4 - Instantaneous Phase
%%% 6 - Dyanmic Time Warp v4.5 - Original Data and Instantaneous Phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%% results Breakdown
%
% nx4 matrix
% column 1 - Shifted Monitor Amplitudes
% column 2 - Time Shifts (in proper units)
% column 3 - Time Shifts (in sample numbers)
% column 4 - Time Axis for Trace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tic

% Performs some initial exception handling to ensure the input vectors are
% appropriate.

if exist('method') == 0
    method = 1;
end

if length(seis0(1,:)) > 1
    seis0 = seis0';
    seis1 = seis1';
end
if length(time_axis1(1,:)) > 1 
    time_axis0 = time_axis0';
    time_axis1 = time_axis1';
end

if exist('plotter') == 0
    plotter = 0;
end

downsample = 1;
error_function = 1;

if exist('stretch_restriction_mat') == 0
    stretch_restriction_mat = [9 5 5 5 10];
elseif stretch_restriction_mat == 0
    stretch_restriction_mat = [9 5 5 5 10];
end
resolution = stretch_restriction_mat(end); % The scale at which you can specify the constraint
stretch_restriction1 = round(stretch_restriction_mat(1)/100*resolution); % Integer between 1-resolution, 1/resloution % stretch increments
stretch_restriction2 = round(stretch_restriction_mat(2)/100*resolution);
stretch_restriction3 = round(stretch_restriction_mat(3)/100*resolution);
stretch_restrictionip = round(stretch_restriction_mat(4)/100*resolution);

start_val = 0.1;
start_val_ip = 10;

seis0 = seis0(1:downsample:end);
ta0 = time_axis0(1:downsample:end);

seis1 = seis1(1:downsample:end);
ta1 = time_axis1(1:downsample:end);

dt = ta1(2)-ta1(1);

    ta1 = ta1(1:length(ta1));
    seis1 = seis1(1:length(ta1));


%% Upsampling for restriction
ta0_compare = min(ta0):(ta0(2)-ta0(1))/resolution:max(ta0);
ta1_compare = min(ta1):(ta1(2)-ta1(1))/resolution:max(ta1);
seis0_compare = interp1(ta0,seis0,ta0_compare,'spline');
seis1_compare = interp1(ta1,seis1,ta1_compare,'spline');


%%Computing the Error Functions
lagrange = -round(length(ta1_compare)/60)*resolution:1:round(length(ta1_compare)/60)*resolution;
%lagrange = -10:1:10;

lagdt = ta0_compare(2)-ta0_compare(1);
lagtimes = lagrange*lagdt;


if method == 1 | method == 2 | method == 3 | method == 4 | method == 5 | method == 6
    error = ones(length(lagrange),length(ta1))*start_val;
    start_index = 1:resolution:length(ta1_compare);
    seismograms = zeros(length(lagrange),length(ta1));
    
    for i = 1:length(lagrange);
        new_ind = start_index+lagrange(i);
        if max(new_ind) > length(seis0_compare)
            new_ind = new_ind(find(new_ind < length(seis0_compare)));
            seismograms(i,:) = [seis1_compare(new_ind) ones(1,length(seis0)-length(new_ind))*0.01];
            error_ind = (1:length(seismograms(i,:))-(length(seis0)-length(new_ind))-1);
        elseif min(new_ind) < 1
            new_ind = new_ind(find(new_ind > 0));
            seismograms(i,:) = [ ones(1,length(seis0)-length(new_ind))*0.01 seis1_compare(new_ind)];
            error_ind = (length(seis0)-length(new_ind))+1:length(seismograms(i,:));
        else
            seismograms(i,:) = [seis1_compare(new_ind)];
            error_ind = 1:length(seismograms(i,:));
        end
        error(i,error_ind) = (seis0(error_ind)'-seismograms(i,error_ind)).^2;
    end
end
    
if method == 1 | method == 2 | method == 3 | method == 4 | method == 6
    %% Computing the Distance function (forward) for minimization

    Distance = ones(length(lagrange),length(ta1))*start_val;
    
    Distance(:,1) = error(:,1);
    for i = 2:length(Distance(1,:))
        for j = 1:stretch_restriction1;
            Distance(j,i) = error(j,i) + min(Distance(j:j+stretch_restriction1,i-1));
        end
        for j = (length(Distance(:,1))-stretch_restriction1):length(Distance(:,1));
            Distance(j,i) = error(j,i) + min(Distance(j-stretch_restriction1:j,i-1));
        end
        for j = (stretch_restriction1+1):(length(Distance(:,1))-stretch_restriction1-1)
            
            Distance(j,i) = error(j,i) + min(Distance(j-stretch_restriction1:j+stretch_restriction1,i-1));
        end
        
        %     if mod(i,percentage_index) == 0
        %         i/length(ta1)
        %     end
    end
    
end
%% Computing the Distance function (backward) for minimization
if method == 2 | method == 3 | method == 4
Distance2 = ones(length(lagrange),length(ta1))*start_val;

Distance2(:,1) = error(:,end);
for i = fliplr(2:length(Distance2(1,:)))
    for j = 1:stretch_restriction1;
        Distance2(j,i-1) = error(j,i-1) + min(Distance2(j:j+stretch_restriction1,i));
    end
    for j = (length(Distance2(:,1))-stretch_restriction1):length(Distance(:,1));
        Distance2(j,i-1) = error(j,i-1) + min(Distance2(j-stretch_restriction1:j,i));
    end
    for j = (stretch_restriction1+1):(length(Distance2(:,1))-stretch_restriction1-1)
        
        Distance2(j,i-1) = error(j,i-1) + min(Distance2(j-stretch_restriction1:j+stretch_restriction1,i));
    end
    
%     if mod(i,percentage_index) == 0
%         i/length(ta1)
%     end

end
end

%% Calculate the curvature differences.
if method == 3 | method == 4 
    error_method = 2;
    
    % Compute the first derivative series
    deriv1_series0 = (seis0_compare(3:end)-seis0_compare(1:end-2))/2;
    d1_series0 = deriv1_series0([1 resolution:resolution:length(deriv1_series0) length(deriv1_series0)]); 
    deriv1_series1 = (seis1_compare(3:end)-seis1_compare(1:end-2))/2;
    t0_d1 = ta0_compare(2:end-1);
    
    sindex2 = [1 resolution:resolution:length(deriv1_series0) length(deriv1_series0)];

    % Compute the errors for the first derivative series
    error_d1 = ones(length(lagrange),length(d1_series0))*start_val;
    for i = 1:length(lagrange);
        new_ind = sindex2+lagrange(i);
        if max(new_ind) > length(deriv1_series1)
            new_ind = new_ind(find(new_ind < length(deriv1_series1)));
            seismograms(i,:) = [deriv1_series1(new_ind) ones(1,length(d1_series0)-length(new_ind))*0.01];
            error_ind = (1:length(seismograms(i,:))-(length(d1_series0)-length(new_ind))-1);
        elseif min(new_ind) < 1
            new_ind = new_ind(find(new_ind > 0));
            seismograms(i,:) = [ ones(1,length(d1_series0)-length(new_ind))*0.01 deriv1_series1(new_ind)];
            error_ind = (length(d1_series0)-length(new_ind))+1:length(seismograms(i,:));
        else
            seismograms(i,:) = [deriv1_series1(new_ind)];
            error_ind = 1:length(seismograms(i,:));
        end
        error_d1(i,error_ind) = (d1_series0(error_ind)-seismograms(i,error_ind)).^2;
    end
    
    if error_method == 2
        error_d1a=  error/max(max(error)) + error_d1/max(max(error_d1));
    end
    
    Distance_d1 = ones(length(lagrange),length(ta1))*start_val;
    Distance_d1(:,1) = error_d1(:,1);
    for i = 2:length(Distance(1,:))
        for j = 1:stretch_restriction2;
            Distance_d1(j,i) = error_d1(j,i) + min(Distance_d1(j:j+stretch_restriction2,i-1));
        end
        for j = (length(Distance_d1(:,1))-stretch_restriction2):length(Distance_d1(:,1));
            Distance_d1(j,i) = error_d1(j,i) + min(Distance_d1(j-stretch_restriction2:j,i-1));
        end
        for j = (stretch_restriction2+1):(length(Distance_d1(:,1))-stretch_restriction2-1)
            Distance_d1(j,i) = error_d1(j,i) + min(Distance_d1(j-stretch_restriction2:j+stretch_restriction2,i-1));
        end
        %     if mod(i,percentage_index) == 0
        %         i/length(ta1)
        %     end
    end
end


%% Compute the second derivative series
if method == 4
    deriv2_series0 = ((seis0_compare(5:end)-seis0_compare(3:end-2))/2-(seis0_compare(3:end-2) - seis0_compare(1:end-4))/2)/2;
    d2_series0 = deriv2_series0([1 (resolution-1):resolution:length(deriv2_series0) length(deriv2_series0)]);
    deriv2_series1 = ((seis1_compare(5:end)-seis1_compare(3:end-2))/2-(seis1_compare(3:end-2) - seis1_compare(1:end-4))/2)/2;
    t0_d2 = ta0_compare(3:end-2);
    error_d2 = ones(length(lagrange),length(d2_series0))*start_val;
    sindex2 = [1 (resolution-1):resolution:length(deriv2_series0) length(deriv2_series0)];
    
    for i = 1:length(lagrange);
        new_ind = sindex2+lagrange(i);
        if max(new_ind) > length(deriv2_series1)
            new_ind = new_ind(find(new_ind < length(deriv2_series1)));
            seismograms(i,:) = [deriv2_series1(new_ind) ones(1,length(d1_series0)-length(new_ind))*0.01];
            error_ind = (1:length(seismograms(i,:))-(length(d1_series0)-length(new_ind))-1);
        elseif min(new_ind) < 1
            new_ind = new_ind(find(new_ind > 0));
            seismograms(i,:) = [ ones(1,length(d1_series0)-length(new_ind))*0.01 deriv2_series1(new_ind)];
            error_ind = (length(d1_series0)-length(new_ind))+1:length(seismograms(i,:));
        else
            seismograms(i,:) = [deriv2_series1(new_ind)];
            error_ind = 1:length(seismograms(i,:));
        end
        error_d2(i,error_ind) = (d2_series0(error_ind)-seismograms(i,error_ind)).^2;
    end
    
    Distance_d2 = ones(length(lagrange),length(ta1))*start_val;
    Distance_d2(:,1) = error_d2(:,1);
    for i = 2:length(Distance(1,:))
        for j = 1:stretch_restriction3;
            Distance_d2(j,i) = error_d2(j,i) + min(Distance_d2(j:j+stretch_restriction3,i-1));
        end
        for j = (length(Distance_d2(:,1))-stretch_restriction3):length(Distance_d2(:,1));
            Distance_d2(j,i) = error_d2(j,i) + min(Distance_d2(j-stretch_restriction3:j,i-1));
        end
        for j = (stretch_restriction3+1):(length(Distance_d2(:,1))-stretch_restriction3-1)
            Distance_d2(j,i) = error_d2(j,i) + min(Distance_d2(j-stretch_restriction3:j+stretch_restriction3,i-1));
        end
        %     if mod(i,percentage_index) == 0
        %         i/length(ta1)
        %     end
    end
end



%% If we use the instantantaneous phase method:
if method == 5 | method == 6
    % Compute the first derivative series
    Instant_Phase0 = signal_attributes(seis0_compare);
    Instant_Phase0 = abs(real(Instant_Phase0(:,4)'));
    ip_series0 = Instant_Phase0([1 resolution:resolution:length(Instant_Phase0)]); 
    Instant_Phase1 = signal_attributes(seis1_compare);
    Instant_Phase1 = abs(real(Instant_Phase1(:,4)'));
    t0 = ta0_compare;
    
    sindex2 = [1 resolution:resolution:length(Instant_Phase0)];
    seismograms = zeros(length(lagrange),length(ta1));
    % Compute the errors for the first derivative series
    error_ip = ones(length(lagrange),length(ip_series0))*start_val;
    for i = 1:length(lagrange);
        new_ind = sindex2+lagrange(i);
        if max(new_ind) > length(Instant_Phase1)
            new_ind = new_ind(find(new_ind < length(Instant_Phase1)));
            seismograms(i,:) = [Instant_Phase1(new_ind) ones(1,length(ip_series0)-length(new_ind))*0.01];
            error_ind = (1:length(seismograms(i,:))-(length(ip_series0)-length(new_ind))-1);
        elseif min(new_ind) < 1
            new_ind = new_ind(find(new_ind > 0));
            seismograms(i,:) = [ ones(1,length(ip_series0)-length(new_ind))*0.01 Instant_Phase1(new_ind)];
            error_ind = (length(ip_series0)-length(new_ind))+1:length(seismograms(i,:));
        else
            seismograms(i,:) = [Instant_Phase1(new_ind)];
            error_ind = 1:length(seismograms(i,:));
        end
        error_ip(i,error_ind) = (ip_series0(error_ind)-seismograms(i,error_ind)).^2;
    end
    
    Distance_ip = ones(length(lagrange),length(ta1))*start_val_ip;
    Distance_ip(:,1) = error_ip(:,1);
    for i = 2:length(Distance_ip(1,:))
        for j = 1:stretch_restrictionip;
            Distance_ip(j,i) = error_ip(j,i) + min(Distance_ip(j:j+stretch_restrictionip,i-1));
        end
        for j = (length(Distance_ip(:,1))-stretch_restrictionip):length(Distance_ip(:,1));
            Distance_ip(j,i) = error_ip(j,i) + min(Distance_ip(j-stretch_restrictionip:j,i-1));
        end
        for j = (stretch_restrictionip+1):(length(Distance_ip(:,1))-stretch_restrictionip-1)
            Distance_ip(j,i) = error_ip(j,i) + min(Distance_ip(j-stretch_restrictionip:j+stretch_restrictionip,i-1));
        end
        %     if mod(i,percentage_index) == 0
        %         i/length(ta1)
        %     end
    end

end

%% here we find the optimum path 
if method < 5
    Distance = Distance/max(max(Distance));
    Distance(find(Distance == 0)) = 1;
end

    if method == 1
        optimizer = Distance;
    elseif method == 2
        Distance2 = Distance2/max(max(Distance2));
        Distance2(find(Distance2 == 0)) = 1;
        optimizer = Distance + Distance2;
    elseif method == 3
        Distance2 = Distance2/max(max(Distance2));
        Distance2(find(Distance2 == 0)) = 1;
        Distance_d1 = Distance_d1/max(max(Distance_d1));
        Distance_d1(find(Distance_d1 == 0)) = 1;
        if error_method == 1
            optimizer = Distance + Distance_d1;
        else
            optimizer = Distance;
        end
    elseif method == 4
        Distance2 = Distance2/max(max(Distance2));
        Distance2(find(Distance2 == 0)) = 1;
        Distance_d1 = Distance_d1/max(max(Distance_d1));
        Distance_d1(find(Distance_d1 == 0)) = 1;
        Distance_d2 = Distance_d2/max(max(Distance_d2));
        Distance_d2(find(Distance_d2 == 0)) = 1;
        optimizer = Distance + Distance_d1 + Distance_d2;
    elseif method == 5
        optimizer = Distance_ip;
    elseif method == 6
        Distance_ip = Distance_ip/max(max(Distance_ip));
        optimizer = 0.1*Distance + Distance_ip;
    end



% Backward Optimization -    
    
    result = zeros(1,length(optimizer(1,:)));
    temp = find(min(optimizer(:,end)) == optimizer(:,end));
    result(1) = temp(1);
    if result(1) > round(length(optimizer(:,1))/2)
        result(1) = round(length(optimizer(:,1))/2);
    end

    
   for i = 2:length(optimizer(1,:))
       range = (result(i-1)-stretch_restriction1):(result(i-1)+stretch_restriction1);
       % This set of logical statements ensures the possible lags lie
       % within the total number of lags
       if max(range) > length(optimizer(:,1))
           range = range(1:stretch_restriction1+1);
       elseif min(range) < 1
           range = range((stretch_restriction1+1):(2*stretch_restriction1+1));
       end
       
       maxl = length(ta0_compare);
       indexes = ([1:resolution:length(ta1_compare)]);

       % This set of logical statements ensures that the selected lag
       % doesn't force a sample to exceed the maximum original time or
       % minimum original time
       if indexes(i-1) - min(lagrange(range)) > maxl 
           range = range(find(indexes(i-1) - lagrange(range) == maxl)):max(range);
           if length(range) == 0
               range = round(length(lagrange)/2);
           end
       elseif indexes(i-1) - max(lagrange(range)) < 1
           range = min(range):range(find(indexes(i-1) - lagrange(range) == 1));
       end

       % Here we select the optimal lag
       temp = find(min(optimizer(range,end+1-i)) == optimizer(range,end+1-i))+min(range)-1;
       if length(temp) > 1
           if length(find(temp == round(length(lagrange)/2))) > 0
               result(i) = temp(find(temp == round(length(lagrange)/2)));
           else
               result(i) = temp(round(length(temp)/2));
           end
       else
           result(i) = temp;
       end   
   end
   
   
   for i = 2:length(result)
       optimal_lag(i) = lagrange(result(end+2-i));
   end
   
   
% Forward Optimization -    
    
    result = zeros(1,length(optimizer(1,:)));
    temp = find(min(optimizer(:,1)) == optimizer(:,1));
    result(1) = temp(1);
    if result(1) > round(length(optimizer(:,1))/2)
        result(1) = round(length(optimizer(:,1))/2);
    end

    
   for i = 2:length(optimizer(1,:))
       range = (result(i-1)-stretch_restriction1):(result(i-1)+stretch_restriction1);
       % This set of logical statements ensures the possible lags lie
       % within the total number of lags
       if max(range) > length(optimizer(:,1))
           range = range(1:stretch_restriction1+1);
       elseif min(range) < 1
           range = range((stretch_restriction1+1):(2*stretch_restriction1+1));
       end
       
       maxl = length(ta0_compare);
       indexes = ([1:resolution:length(ta1_compare)]);

       % This set of logical statements ensures that the selected lag
       % doesn't force a sample to exceed the maximum original time or
       % minimum original time
       if indexes(i-1) - min(lagrange(range)) > maxl 
           range = range(find(indexes(i-1) - lagrange(range) == maxl)):max(range);
           if length(range) == 0
               range = round(length(lagrange)/2);
           end
       elseif indexes(i-1) - max(lagrange(range)) < 1
           range = min(range):range(find(indexes(i-1) - lagrange(range) == 1));
       end

       % Here we select the optimal lag
       temp = find(min(optimizer(range,i)) == optimizer(range,i))+min(range)-1;
       if length(temp) > 1
           if length(find(temp == round(length(lagrange)/2))) > 0
               result(i) = temp(find(temp == round(length(lagrange)/2)));
           else
               result(i) = temp(round(length(temp)/2));
           end
       else
           result(i) = temp;
       end      
   end

    


   for i = 2:length(result)
       f_optimal_lag(i) = lagrange(result(i-1));
   end
%% Shift the seismogram

%Backward Optimum
start_index = [1:resolution:length(ta1_compare)];

o_index = start_index-optimal_lag;
for i = 1:length(o_index)-1
    if o_index(i+1) <= o_index(i)
        o_index(i+1) = o_index(i) + 1;
    end
end

for i = 2:length(o_index)
    if o_index(i) > length(ta0_compare)
        break
    end
    newtimes(i) = ta0_compare(o_index(i));
end

newtimes(1) = newtimes(2)-(ta0_compare(2)-ta0_compare(1));
shifted_seis1 = interp1(newtimes,seis1(1:length(newtimes)),ta0,'spline');
shifted_seis1 = shifted_seis1';

%Forward Optimum
newtimes = [];
o_index_f = start_index-f_optimal_lag;
for i = 1:length(o_index_f)-1
    if o_index_f(i+1) <= o_index_f(i)
        o_index_f(i+1) = o_index_f(i) + 1;
    end
end

for i = 2:length(o_index_f)
    if o_index_f(i) > length(ta0_compare)
        break
    end
    newtimes(i) = ta0_compare(o_index_f(i));
end

newtimes(1) = newtimes(2)-(ta0_compare(2)-ta0_compare(1));
shifted_seis1_f = interp1(newtimes,seis1(1:length(newtimes)),ta0,'spline');
shifted_seis1_f = shifted_seis1_f';


%% Determine whether forward or backward optimum performed better:

rms1 = sum((seis0 - shifted_seis1').^2);
rms2 = sum((seis0 - shifted_seis1_f').^2);

if rms2 < rms1
    shifted_seis1 = shifted_seis1_f;
    optimal_lag = f_optimal_lag;
end


%% The plotting of Results
if plotter == 1
figure()

columns = 6;
if method == 1
    rows_num = 4;
end
if method == 2
    rows_num = 4;
end
if method > 2
    rows_num = 4;
end


a = subplot(rows_num,columns,1:3);
plot(ta0,seis0,'Color','black','LineWidth',2)
hold all
plot(ta1,seis1,'Color','blue','LineWidth',2)
xlabel('Two-way Travel Time (s)')
ylabel('Amplitude (normalized to source)')


b = subplot(rows_num,columns,columns + (1:3));

if method == 1 | method == 2
    error_plot = error;
elseif method == 3 | method == 4
    error_plot = error_d1;
elseif method == 5 | method == 6
    error_plot = error_ip;
end


imagesc(ta0,lagtimes,error)
caxis([0 mean(mean(error))])
hold all
plot(ta1,optimal_lag'/resolution*dt,'Color','white','LineWidth',2)
xlabel('Two-way Travel Time (s)')
ylabel('Time Lag (s)')
colormap(gray)
set(gca,'YDir','normal')


c = subplot(rows_num,columns,2*columns + (1:3));
imagesc(ta0,lagtimes,optimizer)
caxis([0 mean(mean(optimizer))])
hold all
plot(ta1,optimal_lag'/resolution*dt,'Color','white','LineWidth',2)
xlabel('Two-way Travel Time (s)')
ylabel('Time Lag (s)')
colormap(gray)
set(gca,'YDir','normal')

fitrow = 3;

d = subplot(rows_num,columns,fitrow*columns + (1:3));
plot(ta0,shifted_seis1,'o','Color','blue')
hold all
plot(ta0,seis0,'Color','black','LineWidth',4)
plot(ta0,seis0,'Color','white','LineWidth',1)
xlabel('Two-way Travel Time (s)')
ylabel('Amplitude (normalized to source)')


linkaxes([c b],'xy')
linkaxes([a c b d],'x')
if rows_num == 5
    linkaxes([c b c2],'xy')
    linkaxes([a c c2 b d],'x')
elseif rows_num == 6
    linkaxes([c b c2 c3],'xy')
    linkaxes([a c c2 c3 b d],'x')    
elseif rows_num == 7
    linkaxes([c b c2 c3 c4],'xy')
    linkaxes([a c c2 c3 c4 b d],'x')    
end

colorscaler = 1;

shifted_seis1 = shifted_seis1';
cmap = b2r(-1e6,1e6);

if length(seis1) > length(seis0)
    colorscaler = max(seis1(1:length(seis0))-seis0);
else
colorscaler = max(seis1-seis0(1:length(seis1)));
end
        

subplot(rows_num,columns,[columns*(1:rows_num)-2]);
imagesc(0,ta0,shifted_seis1-seis0)
caxis([-colorscaler colorscaler])
colormap(cmap)
title('Amp Differences - Time-Shifted')

subplot(rows_num,columns,[columns*(1:rows_num)-1]);
if length(seis1) > length(seis0)
    imagesc(0,ta1,seis1(1:length(seis0))-seis0)
    caxis([-colorscaler colorscaler])
    colormap(cmap)
    title('Amp Differences - raw')
else
    imagesc(0,ta1,seis1-seis0(1:length(seis1)))
    caxis([-colorscaler colorscaler])
    colormap(cmap) 
    title('Amp Differences - raw')
end

subplot(rows_num,columns,[columns*(1:rows_num)]);
    plot(optimal_lag/resolution*dt,ta0,'LineWidth',2,'Color','black')
    set(gca,'YDir','reverse')
    title('Time Shift (s)')
end


pause(0.01)
%% Ouput the results
if length(shifted_seis1(1,:)) > 1
    shifted_seis1 = shifted_seis1';
end
results = [shifted_seis1 -1*optimal_lag'/resolution*dt -1*optimal_lag' ta0];

toc
end
