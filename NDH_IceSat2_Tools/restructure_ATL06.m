function output = restructure_ATL06(data,filt_flag,out_form,addfieldpairs);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This takes the typical ATL06 data structure and extracts just x,y,z,time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% data - an ATL06 file read by the normal ATL06 reader
% filt - Apply the ATL06 Quality Filter (1)
% out_form - Either as 6 beams (0) or as 1 vector (1) or specific beams [6x1 vector with binary flags];
% addfieldpairs - a cell containing the name for the field in the output
%                   data, and the name of the field in the ATL06 data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - rewritten data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('out_form') == 0
   out_form = 0; 
end
if exist('filt_flag') == 0
   filt_flag = 1; 
end
if exist('addfieldpairs') == 0
    addfieldpairs = {};
end

fopts = fields(data);
keep = [];
for i = 1:length(fopts)
    if fopts{i}(1) == 'g';
        keep = [keep i];
    end
end

true_opts = {'gt1l','gt1r','gt2k','gt2r','gt3l','gt3r'};

if length(out_form) > 1
    if length(keep) == 6
        keep = keep(find(out_form == 1));
    else
        true_keep = [];
        for i = 1:length(keep)
            [kflag kind] = strcmp_ndh(true_opts,fopts{keep(i)})
            if kflag == 1
                if out_form(kind) == 1
                    true_keep = [true_keep keep(i)];
                end
            end
        end
        keep = true_keep;
    end
    out_form = 1;
end

fs = fopts(keep);

tscaler1 = eval(['data.ancillary_data.start_delta_time']);
tscaler2 = eval(['data.ancillary_data.atlas_sdp_gps_epoch']);

%%%%%%%%%%%%%%%%%%%%% This section allows you to request custom fields from
%%%%%%%%%%%%%%%%%%%%% the incoming data structure
if length(addfieldpairs) > 0
    output_str = ['output = struct(''x'',[],''y'',[],''h'',[],''time'',[],'];
    for i = 1:length(addfieldpairs)/2
       output_str = [output_str,'''',addfieldpairs{i*2-1},''',[],']; 
    end
    output_str = [output_str(1:end-1),');'];
    eval(output_str);    
else
    output = struct('x',[],'y',[],'h',[],'time',[]);
end

for i = 1:length(fs);
    
    if isfield(eval(['data.',fs{i}]),'land_ice_segments')
        subdata = eval(['data.',fs{i},'.land_ice_segments']);
        [x y] = polarstereo_fwd(subdata.latitude,subdata.longitude);
        h = subdata.h_li;
        dt = subdata.delta_time;
        
        tval = datenum(1980,1,6,0,0,tscaler2+dt);
        %     tval2 = datevec(tval);
        %     tval3 = datetime(tval2(:,1),tval2(:,2),tval2(:,3),tval2(:,4),tval2(:,5),tval2(:,6));
        
        [trash trash years] = doy(tval);
        
        %     years = year(tval3);
        %     doy = day(tval3,'doy')/day(datetime(years(1),12,31),'doy');
        %     hours = (tval2(:,4)+tval2(:,5)/60+tval2(:,6)/60/60)/24/day(datetime(years(1),12,31),'doy');
        %
        if filt_flag == 1
            keeps = find(subdata.atl06_quality_summary == 0);
        else
            keeps = 1:length(subdata.atl06_quality_summary);
        end
        
        if out_form == 0
            output(i).x = x(keeps);
            output(i).y = y(keeps);
            output(i).h = h(keeps);
            %output(i).time = years(keeps)+doy(keeps)+hours(keeps);
            output(i).time = years(keeps);
        else
            output.x = [output.x; NaN; x(keeps)];
            output.y = [output.y; NaN; y(keeps)];
            output.h = [output.h; NaN; h(keeps)];
            %output.time = [output.time; NaN; years(keeps)+doy(keeps)+hours(keeps)];
            output.time = [output.time; NaN; years(keeps)];
        end
        
        for jjj = 1:length(addfieldpairs)/2
            if out_form == 0
                eval_str = ['output(i).',addfieldpairs{jjj*2-1},' = subdata.',addfieldpairs{jjj*2},'(keeps);'];
                eval(eval_str);
            else
                eval_str = ['output.',addfieldpairs{jjj*2-1},' = [output.',addfieldpairs{jjj*2-1},'; NaN; subdata.',addfieldpairs{jjj*2},'(keeps)];'];
                eval(eval_str);
            end
        end
        
    end
    
end
















