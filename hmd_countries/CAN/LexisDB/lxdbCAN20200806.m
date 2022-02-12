% CANADA
% ------

%%ssh galton
%%cd HMDWORK/CAN
%% %rm STAGE.*
%% rm *.mat

% Do not forget to copy InputDB files into the main CAN folder
%% matlab&

addpath('/data/hg/HMD/Lexis_Scripts/Lexis.hg/');

[deaths, population, births, tadj]=indb_input('CAN');
%% whos -file CAN.mat
% size births : 182x11
% size deaths : 44120x15
% size population : 16984x15
% size trajectoires : 304x12

load('CAN.mat')
checkb(births)
checkp(population)
checkd(deaths)

d=selif(deaths, deaths(:, end)==1);
d=d(:,1:end-1);
size(d)
% size d : 44120x14

p=selif(population, population(:, end)==1);
p=p(:,1:end-1);
size(p)
% size p : 16984x14

births=selif(births, births(:, end)==1);
births=births(:,1:end-1);
size(births)
% size births : 182x10

clear population
clear deaths

disp('long');
d=d_long(d);

% nouvelle commande!
d=d_ma0(d);

disp('split 1x1');
d1=selif(d,d(:,5)>2 & d(:,4)~=0);
d2=selif(d,d(:,5)<=2  & d(:,4)~=0);
d3=selif(d, d(:,4)==0);
for i=min(d(:,3)):max(d(:,3))
    for sex=1:2
    d31=selif(d3, d3(:,3)==i & d3(:,5)>2 & d3(:,2)==sex);
    d32=selif(d3, d3(:,3)==i & d3(:,5)<=2 & d3(:,2)==sex);
    if isempty(d31)
        d1=[d1;d32];
    else
        d2=[d2;d32];
        d1=[d1;d31];
    end
    end
end
    
d1=d_s1x1tn(d1, births, tadj);
d=d_sum(d1,d2);

disp('open age interval');
d=d_soainew(d);

p=p_movedatat(p, tadj);

disp('Extinct cohort method');
p=p_srecmt(p, d, tadj);

p=p_precensal(p, d, [1921,1921]);

ldb_outputt(d, p, 'mCAN.txt', 'fCAN.txt', births, tadj);
