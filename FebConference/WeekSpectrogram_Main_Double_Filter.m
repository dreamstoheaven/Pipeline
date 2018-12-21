% Filling One Week's Data 
% Written by Tianrui Zhu, Final update: 2018-07-16

% Main Script for plotting one week's data. Will not work for babies whom
% moved beds throughout the first week. Specify the NeoID, bednumber,
% startime (the time which record started for that baby at that bed) and
% birth time. These times should be specified in seconds since 2009-01-01.
% This main script calls only one fumction Weekplotting, which is
% responsable for gathering data. Remember to adjust the paths and
% directories hard-coded in these scripts for them to work properly. This
% script will only work on Matlab R2016b and later. 



% Initiation
w_s = [];
w_m = [];
w_d = [];
w_T_s = [];
w_T_m = [];
w_T_d = [];
% w_HR = [];
% w_T_HR = [];
% w_O2 = [];
% w_T_O2 = [];

% INPUT REQUIRED INFORMATION HERE!
NeoID = 1127;
bednumber = 17;
birthtime = 2488440;
starttime = 2502300;
endtime = 3438900;

% Recursively generate filtered data for the baby's first seven days.
for i = floor(starttime/86400):(floor(starttime/86400))+6
    disp(i)
    bednumber = num2str(bednumber,'%02d');
    i = num2str(i,'%04d');
    v = num2str(floor(endtime/86400),'%04d');
    try
    if strcmp(i,'0028') == 1 && strcmp(i,v) == 0
    [s,m,d,T_s,T_m,T_d] = WeekPlotting_Double_Filter(bednumber,i,birthtime,(starttime-floor(starttime/86400)*86400),86400);
    elseif  strcmp(i,'0028') == 1 && strcmp(i,v) == 1
    [s,m,d,T_s,T_m,T_d] = WeekPlotting_Double_Filter(bednumber,i,birthtime,(starttime-floor(starttime/86400)*86400),endtime - floor(endtime/86400)*86400);
    elseif strcmp(i,'0028') == 0 && strcmp(i,v) == 0
    [s,m,d,T_s,T_m,T_d] = WeekPlotting_Double_Filter(bednumber,i,birthtime,1,86400);
    else
    [s,m,d,T_s,T_m,T_d] = WeekPlotting_Double_Filter(bednumber,i,birthtime,1,endtime - floor(endtime/86400)*86400);
    end
    catch
        s = [];
        T_s = [];
        m = [];
        T_m = [];
        d =[];
        T_d = [];
        HR = [];
        T_HR = [];
        O2 = [];
        T_O2 = [];
    end     
    w_s = [w_s,s'];
    %length(w_s)
    w_T_s = [w_T_s,T_s'];
    %length(w_T_s)    
    
    w_m = [w_m,m'];
    %length(w_m)
    w_T_m = [w_T_m,T_m'];
    %length(w_T_m)    
    
    w_d = [w_d,d'];
    %length(w_d)
    w_T_d = [w_T_d,T_d'];
    %length(w_T_d)

% 
%     w_HR = [w_HR,HR'];
%     %length(w_HR)
%     w_T_HR = [w_T_HR,T_HR'];
%     %length(w_T_HR)
%     w_O2 = [w_O2,O2'];
%     %length(w_O2)
%     w_T_O2 = [w_T_O2,T_O2'];
%     %length(w_T_O2)
end

[w_s,w_m,w_d,w_T_s,w_T_m,w_T_d,pulse] = outlier_Double_Filter(w_s,w_m,w_d,w_T_s,w_T_m,w_T_d);

if isnan(w_m(1,length(w_m(1,:)))) 
for i = 0:86399
    if isnan(w_m(1,length(w_m(1,:)) - i))
    else
        w_m(1,length(w_m(1,:))) = w_m(1,length(w_m(1,:)) - i);
        break
    end
end
end

if isnan(w_m(1,1))
    for i = 2:86400
        if isnan(w_m(1,i))
        else
            w_m(1,1) = w_m(1,i);
            break
        end
    end
end

 w_s(1,:) = fillmissing(w_s(1,:),'linear');
 w_m(1,:) = fillmissing(w_m(1,:),'linear');
 w_d(1,:) = fillmissing(w_d(1,:),'linear');

 
figure
plot(w_T_m*24,w_m(1,:));
axis([0, inf, 0, 150]);
xlabel('Time Since Birth in Hours', 'FontSize', 16);
title(strcat('Baby ', num2str(NeoID, '%04d'), ' First Week of Life'), 'FontSize',16);



% figure
%  
% ax1 = subplot(2,1,1);
% [spect,f,t,ps] = spectrogram(w_m - mean(w_m),3600,1800,[],0.5,'yaxis');
% spectrogram(w_m - mean(w_m),3600,1800,[],0.5,'yaxis');
% axis([0,7,-inf,inf]);
% title('Sine Window')
% 
% 
% ax2 = subplot(2,1,2);
% plot(w_T_m - w_T_m(1),w_m);
% axis([t(1)/86400,t(length(t))/86400,-inf,inf]);