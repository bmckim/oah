function [w] = SB_windstress_fromFile(t_min,t_max,stn)
%
% This function generates a signed principal axes wind stress for a desired
% time range and for a list of sites.
% (Wind sensor height fixed at 10 meters above sea surface)
% 
% INPUTS
% t_min, t_max      in matlab format and GMT
% stn,              codes used in SB_Aeolus.mat
% 
% Here are some from regularly used buoys:
%  code  ndbc#        name
%  (23)  46011   Santa Maria Basin  
%  (24)  46023   Pt. Arguello
%  (25)  46054   W. SB Channel
%  (26)  46053   Mid SB Channel
% 
% OUTPUT
% Structure 'w' with as many members (n) as there are input stations
%
%     w(n).V      along-shore principal axes wind stress
%     w(n).U      cross-shore principal axes wind stress
%     w(n).mtime  matlab serial time (gmt, hourly)
%     w(n).abb    station name
%     w(n).code   SB_Aeolus station code


% % % % uncomment this section for testing -----------------------
% clear all
% close all
% clc
% t_min = datenum(2010,4,1);
% t_max = datenum(2010,7,1);
% stn = [23 24 25 26]; % can be single value or vector of stn codes
% % % % ---------------------------------------------


% addpath /data02/transfer/Chris/mfile_library/ % path to PAx_rotation.m
% %addpath /data02/transfer/Chris/mfile_library/air_sea/  % path to wind stress function (stresstc.m)


%     load the NDBC buoy data
% load('/data01/pisco/ucsb/data/physical-files/SBwinds/annual_files/SB_Aeolus.mat')
load('C:\Users\Brett McKim\Box Sync\ocean_acidification\SB_Wind_subset.mat')
wind = sbwind;
clear sbwind % stupid variable name. too big and awkward

for ii = 1:length(stn)  % loop through each station
   
        idx = wind(stn(ii)).mtime>=t_min & wind(stn(ii)).mtime<=t_max; % get the index for times within our time range
        mtime = wind(stn(ii)).mtime(idx); % isolate these data
        u = wind(stn(ii)).Utau(idx);
        v = wind(stn(ii)).Vtau(idx);
        
        if sum(isfinite(u+v))~=0 % if data exist within this time range
            
            ra = PAx_rotation(wind(stn(ii)).abb); % rotate U and V into principal axes
%             sU = ((u.* cos(ra)) - (v.* sin(ra))); 
%             sV = ((u.* sin(ra)) + (v.* cos(ra)));
            


            % note that new SB_Aeolus already has tau calculated
            w(ii).V = (((u.* cos(ra)) - (v.* sin(ra)))).*-1; 
            w(ii).U = ((u.* sin(ra)) + (v.* cos(ra)));
            
%             wind_stress = stresstc(abs(complex(sU,sV)),10).*complex(sU,sV)./abs(complex(sU,sV));
%         
%             % note: this is confusing
%             % typically U and V are eastward and northward resp.
%             % and also typically U would be the 'real' part and V the
%             % 'imaginary' part.
%             % After PAx rotation we call alongshore V and across shore U
%             % V is poleward positive requiring a sign change below
%             % U is positive toward shore, requires no sign change
%             w(ii).V = real(wind_stress).*-1; 
%             w(ii).U = imag(wind_stress);
        
        else % if no data fill with nans
            
            w(ii).V = nan(length(mtime),1); 
            w(ii).U = nan(length(mtime),1);        
            w(ii).mtime = nan(length(mtime),1);  
            
        end
        
            w(ii).mtime = mtime;
            w(ii).abb = wind(stn(ii)).abb;
            w(ii).code = stn(ii);
            
            clear sU sV mtime idx wind_stress ra        
    
end    
    
return   
    
    
    
    
