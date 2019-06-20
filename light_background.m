function outimage = light_background(ingrid,orientation,center_dist);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function generates a matrix showing the direction light is being
% cast on an object (kind of like a flashlight)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ingrid - 
% orientation - 
% center_dist - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%
if exist('center_dist') == 0
    center_dist = 0.5;
end

if exist('size_frac') == 0
    size_frac = 0.5;
end


    orientation = orientation/sqrt(orientation(1).^2+orientation(2).^2);


%%
sz = size(ingrid);
light_size = round(sz(1)*size_frac);

if exist('lightbackground_precalc.mat') ~= 0
    load lightbackground_precalc.mat
    
    ar = sz(2)/sz(1);
    if ar > 1
        num_rows = 1000/ar;
        ri = (500-floor(num_rows/2)):(500+floor(num_rows/2));
        ci = 1:1000;
    else
        num_cols = 1000*ar;
        ri = 1:1000;
        ci = (500-floor(num_cols/2)):(500+floor(num_cols/2));
    end
    
    orientation_angle = rad2deg(atan2(orientation(2),orientation(1)));
    if orientation_angle < 0
        orientation_angle = orientation_angle+360;
    end
    
    extract_ind = find_nearest(0:360,orientation_angle);
    outimage(:,:,1) = single(outimage_precalc(ri,ci,extract_ind))/255;
    outimage(:,:,2) = outimage(:,:,1);
    outimage(:,:,3) = outimage(:,:,1);
    
    
else
    cx = [round(sz(2)/2) round(sz(1)/2)];
    
    outimage = zeros(size(ingrid));
    start = round(center_dist*cx(2));
    
    for i = start:cx(1)
        cx(i+1,:) = round(cx(1,:) + orientation*i);
        if cx(i+1,1) > sz(2) | cx(i+1,2) > sz(1) | cx(i+1,1) < 1 | cx(i+1,2) < 1
            break
        end
        outimage(cx(i+1,2),cx(i+1,1)) = light_size*(cx(1)-i)/cx(1);
    end
    
    
    outimage2 = smooth_ndh(outimage,light_size,1)-0.15;
    outimage2(find(outimage2 < 0)) = 0;
    outimage2 = outimage2/max(max(outimage2));
    
    outimage2(:,:,2) = outimage2;
    outimage2(:,:,3) = outimage2(:,:,1);
    
    outimage = outimage2;
end


% subplot(1,2,1)
% imagesc(outimage2)
% axis equal
% 
% subplot(1,2,2)
% imagesc(outimage)
% caxis([.15 1])
% axis equal





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Precalculate_outimage - run this once when the code 
%%%%%%%%%%%%%%%%%%%%% is first set up on your machine in order to
%%%%%%%%%%%%%%%%%%%%% precompute the matrix that will be used in most
%%%%%%%%%%%%%%%%%%%%% cases.

precalc_flag = 0;

if precalc_flag == 1
    azimuth = 0:1:359;
    outimage3 = zeros(1000,1000,length(azimuth));
    outimage4 = zeros(1000,1000,length(azimuth));
    
    for j = 1:181
        orientation = [cos(deg2rad(azimuth(j))) sin(deg2rad(azimuth(j)))];
        
        orientation = orientation/sqrt(orientation(1).^2+orientation(2).^2);
        
        
        outimage = zeros(1000);
        sz = size(outimage);
        cx = round(size(outimage)/2);
        start = round(center_dist*cx(2));
        light_size = round(sz(1)*size_frac);
        
        for i = start:cx(1)
            cx(i+1,:) = round(cx(1,:) + orientation*i);
            if cx(i+1,1) > sz(2) | cx(i+1,2) > sz(1) | cx(i+1,1) < 1 | cx(i+1,2) < 1
                break
            end
            outimage(cx(i+1,2),cx(i+1,1)) = light_size*(cx(1)-i)/cx(1);
        end
        
        
        outimage2 = smooth_ndh(outimage,light_size,1)-0.15;
        outimage2(find(outimage2 < 0)) = 0;
        outimage3(:,:,j) = outimage2/max(max(outimage2));
        
        disp(['Completed Azimuth ',num2str(j),' of 360'])
    end
    
    for j = 1:360
        if j < 182
            outimage4(:,:,j) = outimage3(:,:,j);
        else
            outimage4(:,:,j) = flipud(outimage3(:,:,361-j));
        end
        imagesc(outimage4(:,:,j))
        pause(0.0001)
    end
    
    outimage_precalc = uint8(outimage4*255);
    save('lightbackground_precalc.mat','outimage_precalc')
end
    

 

end




