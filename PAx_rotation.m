function [rot_ang] = PAx_rotation(site_abb)
% 
% This function takes a pisco/sbclter mooring or sb meteorological station
% site code and returns the principal axes rotation applicable to that
% site. This angle (ra) is what you need to apply to the raw data in geographic 
% coordinates to convert them to pricipal axes using the equation:
%
%  Upax = ((Ugeog.* cos(ra)) - (Vgeog.* sin(ra))); 
%  Vpax = ((Ugeog.* sin(ra)) + (Vgeog.* cos(ra)));
%
% rot_ang is returned in + or - pi radians.  Zero is centered on the
% positive x axis  
%
% rotation angles were calculated for all available pisco, sbclter current data
% and sb_aeolus wind data 

% note: set bins to [2:11] in pax_plotter.m do calculate angels

if logical(iscell(site_abb))
        site_abb = strtrim(lower(cell2mat(site_abb)));  % mooring sites are cell
else
        site_abb = strtrim(lower(site_abb));            % wind sites are characters
end

% list updated from PAx-stats.txt on 20110211

junk = {'pts',      '0.6812';
        'pur',      '0.7106';
        'arg',      '-0.0023';
        'jal',      '0.996';
        'ale',      '-0.0382';
        'arq',      '0.2404';
        'nap',      '0.3630';
        'ell',      '0.212';
        'arb',      '0.252';
        'mko',      '0.2931';
        'car',      '0.2866';
        'cuy',      '0.2875';
        'bay',      '0.651';
        'ctn',      '0.0151';
        'bea',      '1.3095';
        'pro',      '0.3675';
        'haz',      '0.7244';
        'pel',      '0.6427';
        'scp',      '0.6161';
        'win',      '-0.1122';
        'sms',      '0.0775';
        'srs',      '0.6102';
        'trl',      '0.4623';
        'mor',      '0.6785';
        'val',      '-0.3570';
        'ans',      '-0.2322';
        'cc',       '0.307';
        'e1',       '1.144';
        'wc',       '-0.152';
        'se',       '0.601';
        'sy',       '0.005';
        'sl',       '0.340';
        'vs',       '1.124';
        'lo',       '1.443';
        'sg',       '-1.130';
        'ip',       '-0.045';
        'ih',       '-0.054';
        'gp',       '-1.110';
        'oe',       '0.864';
        'ow',       '1.163';
        'sb',       '0.332';
        'sm',       '0.280';
        'scz',      '0.199';
        'dln',      '0.420';
        'ros',      '0.691';
        'anic1',    '-0.483';
        'ar320',    '0.872';
        '46062',    '0.8395';
        '46011',    '0.9007';
        '46023',    '0.9330';
        '46054',    '0.6486';
        '46053',    '0.1398';
         '3369',    '0.9195'; % added for NARR analysis
         '3241',    '0.8995';
         '2992',    '0.648';  % near 46054
         '111823',  '0.9595';   % near 46054% qwikscat points
         '110308',  '1.0655;'
         '109931',  '0.9927'};

ii = find(ismember(char(junk(:,1)),site_abb,'rows'));

if length(ii) < 1
    disp('Error -> No matching sites in PAx_rotation.m')
    rot_ang = -999;
    return
elseif length(ii) > 1
    disp('Error -> Somehow there was more than one matching site in PAx_rotation.m')
    return
end

rot_ang = str2num((cell2mat(junk(ii,2))));

clear site_abb junk ii
 

return