% USA LexisDB "cocktail script" edited by Celeste & Tim
% Modified June 3, 2015
% Tested - TBD
%
% 2017-02-15
%
% inputs include deaths through 2015, births through 2015, 
% pop through July 1, 2015 (intercensal estimates)
% post-censal estimates needed for Jan 1 2016 pop
% there are 5yr- and open age groups in the deaths

%addpath '/data/commons/boe/Triffe_git/HMDLexis/HMDLexis/MATLAB.hg'
%addpath '/hdir/0/hmd/HMDWORK/USA/InputDB'



%clear all
%dbstop if error
%Name = 'USA';

%% 

%indb_input('USA');  %!!!

%indb_diagram('USA',  'USA');

load USA;
d = deaths(deaths(:, end)==1 &deaths(:,4)<=130,:);
d = d(:,1:end-1);
p = population(population(:, end)==1 & population(:,2)~=3,:);
p = p(:,1:end-1);
births = selif(births, births(:, end)==1);
births = births(:,1:end-1);

% adds missing ages in deaths (data in the InputDB format) with deaths number 0
d = d_ma0(d);

disp('split by rectangles');
d=d_s5x1(d);

disp('split by triangles');
d=d_s1x1tn(d, births,tadj);

disp('open age interval');
d=d_soainew(d);

disp('long');
d=d_long(d);

disp('distribution of unknown');
d=d_unk(d);

disp('population');

%p=selif(p,p(:,5)<1981 | p(:,6)==1); 

%The previous sequence
%p=p_precensal(p,d,[1933 1933],1);
%p=p_postcensal(p,d,births,[2011 2011]);
%p=p_movedatat(p,tadj);
%p=p_ict(p, d, births,tadj);

%Tim's suggested sequence


p = p_precensal(p,d,[1933 1933],1); % the last argument, 1, 
                                  % of Mila's code is needed
                                  % given that populations for 1933 & 1934
                                  % are from mid-year estimates 
% p = p_postcensal(p,d,births,[2017 2017]); %Extend postcensal
                                          %estimates to one year
                                          %beyond last year of pop-data
p = p_movedatat(p,tadj);
p = p_ict(p, d, births,tadj);

%Lower ceiling of p_scremtA() is age 70, but we only want
%the routine to affect ages 80 and above

% Survivor Ratio & Extinct Cohort Method
p1=p(p(:,3)<80,:);
%p = p_srecmtA(p, d, tadj, 85);
%Tim suggests changing the start-age from 85 to 89
%Age can be adjusted back from 89 to 90 once we have 2014 deaths, births, pop
%Which means we can move to p_scremt() function  
% Feb 15, 2017 - experiment with moving SR/ECM date back the the HMD
% default, A = 90
p = p_srecmtA(p, d, tadj, 90);
p=p(p(:,3)>=80,:);
p=[p1;p];

ldb_outputt(d, p, 'mUSA.txt', 'fUSA.txt', births, tadj); 

d_printRA('USA','USA');

