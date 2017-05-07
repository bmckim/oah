% This mfile is called plot_ocean_acidification_bm_02.m and is used to plot
% 02 and pH data from the Mohwak and Arroyo Quemado Mooring

%NOTE THAT THIS FILE REQUIRES 2 FUNCTIONS: PAx_rotation.m and
%SB_windstress_fromFile

% COLUMN    DATA DESCRIPTION   INSTRUMENT
%(1)            Matlab serial time (GMT)		n/a
%(2)            Year					ADCP 
%(3)            Month					ADCP 
%(4)            Day					ADCP 
%(5)            Decimal Day  				ADCP 
%(6:21)       East Velocity  2m-17m bins		ADCP 
%(22:37)	 North Velocity 2m-17m bins		ADCP 
%(38:53)	 Mean Beam Intensity 2m-17m bins		ADCP 
%(54)	       Temperature				ADCP 
%(55-57)     Temperature(Top-Mid-Bottom)	      Tidbits
%(58- 73)     Percent Good, Field 3                   ADCP
%(74)           East Velocity (m/sec)                    S4
%(75)           North Velocity (m/sec)                   S4
%(76)           Depth (m)                                S4
%(77)           Pressure (db)                       SBE16 or SBE37
%(78)           Temperature (C)                     SBE16 or SBE37
%(79)           Conductivity (S/m)                  SBE16 or SBE37
%(80)           Salinity                            SBE16 or SBE37
%(81)           Density (sigma-theta)               SBE16 or SBE37
%(82)           Chl fluorescence (volts)                SBE37
%(83:86)      unused
%(87)           Depth (m)                               ADCP

%------------ Columns after this are only for the combined monster ---------

%(88)           Matlab serial time from pH monster
%(89)           pH (total scale unless uncalbrated set to pH=10)
%(90)           pH sensor temperature (C)
%(91)           Matlab_serial_time_gmt from DO sensor
%(92)           DO sensor temperature (C)
%(93)           DO sensor percent saturation (%)
%(94)           DO sensor O2 conc [mg/l]


% COLUMN    DATA DESCRIPTION   INSTRUMENT
%(1)             Matlab serial time (GMT)		n/a
%(2)             temp_C_nearSurface (C)
%(3)             DO_pcnt_sat_nearSurface
%(4)             DO_mg/l_nearSurface (mg/l)
%(5)             temp_C_nearBottom (C)
%(6)             DO_pcnt_sat_nearBottom
%(7)             Do_mg/l_nearBottom (mg/l)


% Wind stuff
% Here are some from regularly used buoys:
%  code  ndbc#        name
%  (23)  46011   Santa Maria Basin  
%  (24)  46023   Pt. Arguello
%  (25)  46054   W. SB Channel --> RED
%  (26)  46053   Mid SB Channel --> GREEN


% --------------------------------------- data inputs --------------------------------------------------------------------
addpath ..\mooring_data\
addpath ..\

site = {'arq', 'mko'} ;
year = {'2012','2013','2014','2015','2016'} ;
stn = [25 26] ;

load('C:\Users\Brett McKim\Box Sync\ocean_acidification\SB_Wind_subset.mat')
wind = sbwind;
clear sbwind % stupid variable name. too big and awkward

btime = zeros(1,length(year)) ;
etime = zeros(1,length(year)) ;

mfile='plot\_ocean\_acidification\_bm\_02.m';


for ii =1:length(site)
    for jj = 1:length(year)
        load(['..\mooring_data\',upper(site{ii}),'_monster_',year{jj},'.mat'])          % load data files
        if jj > 3                                                                                                             % since only do monsters are from 2015 and 2016
            load(['..\mooring_data\',upper(site{ii}),'_DOMonster_',year{jj},'.mat'])
            dodata.([site{ii},year{jj}]) = domon ;
            clear domon
        end
        if jj == 4                                                                                                           % since ony 2015 has ph data
            if ii == 1
            load(['..\mooring_data\',upper(site{ii}),'_combined_monster_',year{jj},'.mat'])
            phdata.([site{ii},year{jj}]) = arqmon ;
            clear arqmon
            end
            if ii == 2
            load(['..\mooring_data\',upper(site{ii}),'_combined_monster_',year{jj},'.mat'])
            phdata.([site{ii},year{jj}]) = mkomon ;
            clear mkomon
            end
        end
        if jj == 3 || jj == 5
            load(['..\mooring_data\',upper(site{ii}),'_pH_Monster_',year{jj},'.mat'])
            phmoddata.([site{ii},year{jj}]) = pH ;
            clear pH
        end
                
        btime(jj) = datenum(['1-jan-',year{jj},' 00:00:00']) ;        % define beginning time to plot data
        etime(jj) = datenum(['31-dec-',year{jj},' 23:40:00']) ;     % define ending time to plot data
        data.([site{ii},year{jj}]) = monster;                                  % create structure to store every mooring's data in
        clear monster                                                                   % we dont want this guy hanging around
    end
end


mtarq15 = find(data.arq2015(:,1) >= datenum('9-jul-2015 00:00:00') & data.arq2015(:,1) <= datenum('31-dec-2015 23:40:00')) ;
mtarq16 = find(data.arq2016(:,1) >= datenum('1-jan-2016 00:00:00') & data.arq2016(:,1) <= datenum('31-dec-2016 23:40:00')) ;
mtmko15 = find(data.mko2015(:,1) >= datenum('9-jul-2015 00:00:00') & data.mko2015(:,1) <= datenum('10-nov-2015 12:00:00')) ;
mtmko16 = find(data.mko2016(:,1) >= datenum('9-jan-2016 00:00:00') & data.mko2016(:,1) <= datenum('31-dec-2016 23:40:00')) ;

% pH Bottle sample dates
% Bottle sample dates
load('C:\Users\Brett McKim\Box Sync\ocean_acidification\mooring_data\phsample.mat')





% ----------------------------------- principal axis for currents -----------------------------------------------------------

for ii = 1:length(site)
    for jj = 1:length(year)
        north.ave.([site{ii},year{jj}]) = nanmean(data.([site{ii},year{jj}])(:,23:36)')' ;                                          % depth averaged north flow
        east.ave.([site{ii},year{jj}]) = nanmean(data.([site{ii},year{jj}])(:,7:20)')' ;                                               % depth averaged east flow
        
        north.bot.([site{ii},year{jj}]) = nanmean(data.([site{ii},year{jj}])(:,23:25)')' ;                                          % bot north flow
        east.bot.([site{ii},year{jj}]) = nanmean(data.([site{ii},year{jj}])(:,7:9)')' ;                                                % bot east 
        
        north.top.([site{ii},year{jj}]) = nanmean(data.([site{ii},year{jj}])(:,34:36)')' ;                                          % top north flow
        east.top.([site{ii},year{jj}]) = nanmean(data.([site{ii},year{jj}])(:,18:20)')' ;                                             % top east flow
        
        ra = PAx_rotation(site{ii}) ; % I think u is north and v is east???
        
        along.ave.([site{ii},year{jj}]) = east.ave.([site{ii},year{jj}]) .* cos(ra) - north.ave.([site{ii},year{jj}]) .* sin(ra) ;    % depth averaged cross shore flow
        cross.ave.([site{ii},year{jj}]) = east.ave.([site{ii},year{jj}]) .* sin(ra) + north.ave.([site{ii},year{jj}]) .* cos(ra) ;    % depth averaged along shore flow
        
        along.bot.([site{ii},year{jj}]) = east.top.([site{ii},year{jj}]) .* cos(ra) - north.top.([site{ii},year{jj}]) .* sin(ra) ;    % bot averaged cross shore flow
        cross.bot.([site{ii},year{jj}]) = east.top.([site{ii},year{jj}]) .* sin(ra) + north.top.([site{ii},year{jj}]) .* cos(ra) ;    % bot averaged along shore flow
        
        along.top.([site{ii},year{jj}]) = east.bot.([site{ii},year{jj}]) .* cos(ra) - north.bot.([site{ii},year{jj}]) .* sin(ra) ;    % top averaged cross shore flow
        cross.top.([site{ii},year{jj}]) = east.bot.([site{ii},year{jj}]) .* sin(ra) + north.bot.([site{ii},year{jj}]) .* cos(ra) ;    % top averaged along shore flow
        clear ra
        
    end
end


% --------------------------------------  plotting ------------------------------------------------------------------------
mtmko15oah = find(data.mko2015(:,1) >= datenum('1-jan-2015 00:00:00') & data.mko2015(:,1) <= datenum('10-mar-2015 00:00:00'));
mtmko16oah = find(data.mko2016(:,1) >= datenum('10-jan-2016 00:00:00') & data.mko2016(:,1) <= datenum('4-apr-2016 16:00:00')) ;
mt2mko16oah = find(data.mko2016(:,1) >= datenum('10-aug-2016 00:00:00') & data.mko2016(:,1) <= datenum('4-dec-2016 16:00:00')) ;
mt3mko16oah = find(data.mko2016(:,1) >= datenum('10-jan-2016 00:00:00') & data.mko2016(:,1) <= datenum('31-dec-2016 23:40:00')) ;
mtarq15oah = find(data.arq2015(:,1) >= datenum('1-jan-2015 00:00:00') & data.arq2015(:,1) <= datenum('9-jul-2015 12:00:00')) ;
mtarq16oah = find(data.arq2016(:,1) >= datenum('19-may-2016 16:00:00') & data.arq2016(:,1) <=datenum('29-jul-2016 22:00:00')) ;

%             ind = ~isnan(phscale) & ~isnan(o2scale) ;
%             phscale = phscale(ind) ;
%             o2scale = o2scale(ind) ;
% 
% for ii = 1:length(site)
%     for jj = 1:length(year)
%         if ii == 1 && jj == 4
%             x = phdata.([site{ii},year{jj}])(mtarq15oah,89) ; % enter your variable of choice
%             y = dodata.([site{ii},year{jj}])(mtarq15oah,4) ; % enter your variable of choice
%             
%             fit = polyfitn(x,y,1);
%             z = polyval(fit.Coefficients,x) ;           
%                 
%             figure
%             scatter(x,y,'m.')
%             hold on
%             plot(x,z,'k')
%             xlabel('ph')
%             ylabel('top o2')
%             title(strcat([num2str(site{ii}),num2str(year{jj}), '  R2 = ' ,num2str(fit.R2)]))
%         end
%     end
% end
%         if ii == 1 && jj == 5
%             x = phmoddata.([site{ii},year{jj}])(:,2) ; % enter your variable of choice
%             y = dodata.([site{ii},year{jj}])(:,4) ; % enter your variable of choice
%             
%             fit = polyfitn(x,y,1);
%             z = polyval(fit.Coefficients,x) ;           
%                 
%             figure
%             scatter(x,y,'m.')
%             hold on
%             plot(x,z,'k')
%             xlabel('ph')
%             ylabel('top o2')
%             title(strcat([num2str(site{ii}),num2str(year{jj}), '  R2 = ' ,num2str(fit.R2)]))
%         end
%         if ii == 2 && jj == 4
%             x = phdata.([site{ii},year{jj}])(mtmko15oah,89) ; % enter your variable of choice
%             y = dodata.([site{ii},year{jj}])(mtmko15oah,4) ; % enter your variable of choice
%             
%             fit = polyfitn(x,y,1);
%             z = polyval(fit.Coefficients,x) ;           
%                 
%             figure
%             scatter(x,y,'m.')
%             hold on
%             plot(x,z,'k')
%             xlabel('ph')
%             ylabel('top o2')
%             title(strcat([num2str(site{ii}),num2str(year{jj}), '  R2 = ' ,num2str(fit.R2)]))            
%         end     
%             
%         if ii == 2 && jj == 5
% 
%             x = phmoddata.([site{ii},year{jj}])(mtmko16oah,2) ; % enter your variable of choice
%             y = dodata.([site{ii},year{jj}])(mtmko16oah,4) ; % enter your variable of choice
%             
%             fit = polyfitn(x,y,1);
%             z = polyval(fit.Coefficients,x) ;           
%                 
%             figure
%             scatter(x,y,'m.')
%             hold on
%             plot(x,z,'k')
%             xlabel('ph')
%             ylabel('top o2')
%             title(strcat([num2str(site{ii}),num2str(year{jj}), '  R2 = ' ,num2str(fit.R2)]))
% 
%             
%             
%             x = dodata.([site{ii},year{jj}])(mt2mko16oah,4) ; % enter your variable of choice
%             y = data.([site{ii},year{jj}])(mt2mko16oah,78) ; % enter your variable of choice
%             
%             fit = polyfitn(x,y,1);
%             z = polyval(fit.Coefficients,x) ;           
%                 
%             figure
%             scatter(x,y,'r.')
%             hold on
%             plot(x,z,'k')
%             xlabel('top o2')
%             ylabel('sbe temp')
%             title(strcat([num2str(site{ii}),num2str(year{jj}), '  R2 = ' ,num2str(fit.R2)]))
%             
%             
%             
%             x = dodata.([site{ii},year{jj}])(mt2mko16oah,7) ; % enter your variable of choice      
%             y = dodata.([site{ii},year{jj}])(mt2mko16oah,5) ; % enter your variable of choice
%             
%             fit = polyfitn(x,y,1);
%             z = polyval(fit.Coefficients,x) ;           
%                 
%             figure
%             scatter(x,y,'b.')
%             hold on
%             plot(x,z,'k')
%             xlabel('bot o2')
%             ylabel('o2 sensor temp')
%             title(strcat([num2str(site{ii}),num2str(year{jj}), '  R2 = ' ,num2str(fit.R2)]))
%             
%             
%             
%             x = phmoddata.([site{ii},year{jj}])(mtmko16oah,2) ; % enter your variable of choice      
%             y = data.([site{ii},year{jj}])(mtmko16oah,55) ; % enter your variable of choice
%             
%             fit = polyfitn(x,y,1);
%             z = polyval(fit.Coefficients,x) ;           
%                 
%             figure
%             scatter(x,y,'r.')
%             hold on
%             plot(x,z,'k')
%             xlabel('ph')
%             ylabel('top temp')
%             title(strcat([num2str(site{ii}),num2str(year{jj}), '  R2 = ' ,num2str(fit.R2)]))
%         end
% 
% 
%     end
% end




%%
for ii = 1:length(site)
    for jj = 1:length(year)
        if jj > 2
        figure
        subplot(511)
        plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,55),'r') % plots top temp tidbit
        hold on
        plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,56),'g') % plots mid temp tidbit
        plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,57),'b') % plots bot temp tidbit
        plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,78),'k') % plots CTD temp
        plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,54),'k--') % plots ADCP bottom temp
        set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'),'ticklength',.5*get(gca,'ticklength'));
        ylabel('Temp','fontsize',12) % celsius
        ylim([10 24])
        title([upper(site{ii}),'   ',year{jj}])
        
        subplot(512)
        plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,80),'m') % plots salinity
        set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'),'ticklength',.5*get(gca,'ticklength'));
        ylabel('salinty','fontsize',12) % celsius
        if jj >3
            ylim([33.2 33.8])
        end
        
        subplot(513)
        plot([btime(jj) etime(jj)],[0 0],'k')                       % add zero line
        hold on
        plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,82),'g') % plots chlorophyl
        set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'),'ticklength',.5*get(gca,'ticklength'));
        ylabel('chlor','fontsize',12) % celsius
        ylim([0 15])
        
        subplot(514)
        if jj > 3
            plot(dodata.([site{ii},year{jj}])(:,1),dodata.([site{ii},year{jj}])(:,4),'r') % plots surface oxygen mg/l
            hold on
            plot(dodata.([site{ii},year{jj}])(:,1),dodata.([site{ii},year{jj}])(:,7),'b') % plots bottom oxygen mg/l    
            ylim([1 15])
        else
            plot([btime(jj) etime(jj)],[0 0],'k')                       % add zero line  
        end
        set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'),'ticklength',.5*get(gca,'ticklength'));
        ylabel('O2','fontsize',12) % mg/l
        
        subplot(515)
        plot([btime(jj) etime(jj)],[0 0],'k')                       % add zero line
        hold on
        for dd = 1:length(phsample.site)
            date = [char(string(phsample.mm(dd))) '-' char(string(phsample.dd(dd))) ...
                     '-' char(string(phsample.yyyy(dd))) ' ' char(string(phsample.HH(dd))) ':' char(string(phsample.MM(dd))) ':' ...
                    char(string(0)) char(string(0))] ;
            if string(phsample.site{dd}) == string(upper(site{ii})) && string(phsample.yyyy(dd)) == string(year{jj})
                plot(datenum(date),phsample.pH_adjusted(dd),'k*')
                hold on
            end
        end
        if jj == 3
            plot(phmoddata.([site{ii},year{jj}])(:,1),phmoddata.([site{ii},year{jj}])(:,2),'r')
        end
        if jj == 4
            plot(phdata.([site{ii},year{jj}])(:,1),phdata.([site{ii},year{jj}])(:,89),'r') % plots ph
            if ii ==1
                plot(phdata.([site{ii},year{jj}])(mtarq15,1),phdata.([site{ii},year{jj}])(mtarq15,89) - 2,'m') % plots modified ph data
           end
            if ii == 2
                plot(phdata.([site{ii},year{jj}])(mtmko15,1),phdata.([site{ii},year{jj}])(mtmko15,89) - 2,'m') % plots modified ph data                
            end
        end
        if jj == 5
            plot(phmoddata.([site{ii},year{jj}])(:,1),phmoddata.([site{ii},year{jj}])(:,2),'r')
            if ii == 1
                plot(phmoddata.([site{ii},year{jj}])(mtarq16,1),phmoddata.([site{ii},year{jj}])(mtarq16,2) - 2,'m') % plots modified ph data                
            end
            if ii == 2
                plot(phmoddata.([site{ii},year{jj}])(mtmko16,1),phmoddata.([site{ii},year{jj}])(mtmko16,2) - 2,'m') % plots modified ph data                
            end
        end
        set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'),'ticklength',.5*get(gca,'ticklength'));
        ylabel('ph','fontsize',12)
        if jj > 2
            ylim([7.8 8.2])
        end
        
%         subplot(915)
%         plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,77),'color',[.75 .75 .75]) % plots SBE 16 or 37 pressure
%         hold on
%         plot(data.([site{ii},year{jj}])(:,1),data.([site{ii},year{jj}])(:,87),'k') % plots adcp bottom pressure
%         set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'),'ticklength',.5*get(gca,'ticklength'));
%         ylabel('pressure','fontsize',12) % celsius
        
%         subplot(918)
%         plot(data.([site{ii},year{jj}])(:,1),along.ave.([site{ii},year{jj}]),'g') % plots depth ave along flow
%         hold on
%         plot(data.([site{ii},year{jj}])(:,1),along.top.([site{ii},year{jj}]),'r') % plots top along flow
%         plot(data.([site{ii},year{jj}])(:,1),along.bot.([site{ii},year{jj}]),'b') % plots bot along flow
%         set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'),'ticklength',.5*get(gca,'ticklength'));
%         ylabel('along','fontsize',12)
%         ylim([-.5 .5])
%         
%         subplot(919)
%         plot(data.([site{ii},year{jj}])(:,1),cross.ave.([site{ii},year{jj}]),'g') % plots depth ave cross flow
%         hold on
%         plot(data.([site{ii},year{jj}])(:,1),cross.top.([site{ii},year{jj}]),'r') % plots top cross flow
%         plot(data.([site{ii},year{jj}])(:,1),cross.bot.([site{ii},year{jj}]),'b') % plots bot cross flow
%         set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'),'ticklength',.5*get(gca,'ticklength'));
%         ylabel('cross','fontsize',12)
%         ylim([-.5 .5])

%         subplot(912)
%         color = ['r' , 'g'];
%         for kk = 1:length(stn)
%             plot(wind(stn(kk)).mtime,wind(stn(kk)).Utau,color(kk));    % 46054 and 46053
%             text('units','normalized','position',[.10,.80+(kk-1)*.35],'string',[wind(stn(kk)).abb],'color',color(kk));
%             hold on;
%         end
%         set(gca,'xtick',btime(jj):1:etime(jj),'XTickLabel',datestr(btime(jj):1:etime(jj),'mm/dd'),'ticklength',.5*get(gca,'ticklength'));
%         ylabel('u wind','FontSize',12) % wind stress (pascal)
%         xlim([btime(jj) etime(jj)])
%         ylim([-1 1])
%         plot([btime(jj) etime(jj)],[0 0],'k')                       % add zero line
        
        
        h(1)=subplot(511);
        h(2)=subplot(512);
        h(3)=subplot(513);
        h(4)=subplot(514);
        h(5)=subplot(515);
%         h(6)=subplot(616);
%         h(7)=subplot(917);
%         h(8)=subplot(918);
%         h(9)=subplot(919);
        linkaxes(h,'x');
        text('units','normalized','position',[.5,0],'string',['mfile: ' mfile]);
        end
    end
end
