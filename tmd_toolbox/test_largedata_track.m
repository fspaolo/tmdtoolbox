Model='DATA/Model_CATS2008a_opt';

% Path to TMD functions
addpath('FUNCTIONS')

N=100000;
SDtime_1=datenum(2016,1,1);
SDtime_2=SDtime_1+1;
dt=(SDtime_2-SDtime_1)/N;
SDtime=SDtime_1+(1:N)*dt;
lon=185+10*(1:N)/N;
lat=-80+10*(1:N)/N;

%figure(1); plot(lon,lat,'r');
%plot_moa(1,'k');

t0=cputime;

%[z,conList]=tmd_tide_pred(Model,SDtime,lat,lon,'z');
[z,conList]=tmd_tide_pred_par(Model,SDtime,lat,lon,'z');

disp([num2str(N) ': ' num2str(cputime-t0,'%10.1f')])

%x=[10000 50000 1000000];  % Number of predicted points
%y=[   21    68    1195];  % Time in seconds.
%
%pfit=polyfit(x,y,1);
%disp([num2str(pfit(1)) ', ' num2str(pfit(2))]);

% So, I get 9 seconds, + about 1 second per 1000 points (up to 1M points)
% About 3M/hour, or a day for 60M if it scales up.
