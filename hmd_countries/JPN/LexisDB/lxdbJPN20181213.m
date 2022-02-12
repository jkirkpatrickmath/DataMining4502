% Date: 24 Oct, 2017
%clearall

%dbstop if error
Name = 'JPN';

% code for user =  Kirill only
%if ~isempty(regexpi(getenv('username'), 'Kirill'))
%    workfolder = hmdpath(Name, 'root');
%    % code for user =  Kirill only
%    addpath( hmdglobalsf('LexisSoftwareFolder'));
%    addpath( hmdpath(Name, 'matlab'));
%    %cd(hmdpath(Name, 'matlab'));
%    cd(hmdpath(Name, 'indb'));
%end

%addpath('/data/hg/HMD/Lexis_Scripts/Lexis.hg')
%cd('/data/commons/triffe/git/HMD_CS/HMDwork/C_JPN/Fix2003/InputDB')
%% run
disp('Read...');
%indb_input('JPN');
load('JPN.mat');
disp('select LDB = 1');
  deaths     = selif(deaths, deaths(:, end)==1);
deaths     = deaths(:,1:end-1);
population = selif(population, population(:, end)==1);
population = population(:,1:end-1);
births     = selif(births, births(:, end)==1);
births     = births(:,1:end-1);

disp('deaths: extend to age 130')
d          = d_long(deaths);

% old code, for 1947-1949 prior to obtaining triangles
%ind        = find(d(:,4)<5);
%d(ind,7)=1;
%d=d_s5x1(d);

%disp('split by triangles');
%d=d_s1x1(d, births);

% no longer open age intervals in data
%disp('open age interval');
%d=d_soainew(d,1950);
disp('deaths: impute 0s for missing classes')
d  = d_ma0(d);
 disp('deaths: redistribute of unknowns');
d  = d_unk(d);

save rsd

%% population 
disp('population');
disp('read...');


%p=selif(population, population(:,5)>=1950);
p = population;


p = p_movedata(p);
%p_move = p;

p = p_unk(p);
%p_unk = p;

save rsp
disp('Intercensal');
%p=p_sr(p, d);
save rs1
p = p_ict(p,d,births,tadj);
%p_ict = p;

p = p_precensal(p, d,[1947, 1947]);
%p_prec = p;

p = p_postcensal(p, d, births,[2018, 2018]); %change 12.13.2018
%p_post = p;

disp('Extinct cohort method');
p = p_srecmt(p,d,tadj);
%p_srecmt = p;

save rsp

% ldb_output(d, p, 'mJPN.txt', 'fJPN.txt', births);
ldb_outputt(d, p, 'mJPN.txt', 'fJPN.txt', births, tadj); 
d_printRA('JPN','JPN');

%% move lexis databases
%for sexl = {'m' 'f'}
%    sexlc = char(sexl);
%    fname1 = [hmdpath(Name, 'indb') sexlc Name '.txt'];
%    fname2 = [hmdpath(Name, 'lxdb') sexlc Name '.txt'];
%    % cmd  = sprintf('xcopy "%s" "%s" /Y', fname1, fname2);
%    delete(fname2);  copyfile(fname1, fname2, 'f');  delete(fname1);
%end

%% code for user =  Kirill only
%if ~isempty(regexpi(getenv('username'), 'Kirill'))
%    rmpath(hmdglobalsf('LexisSoftwareFolder'));
%    rmpath(hmdpath(Name, 'matlab'));
%     cd('E:\!Home\HMD\HMDWork\DNK\Matlab\');
%     cd('..\indb');
%end

% if flgError
%     error('Cannot run script');
% end
