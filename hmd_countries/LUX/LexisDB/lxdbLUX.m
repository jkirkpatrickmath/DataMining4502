% Date: 06-Nov-2010
clearall
dbstop if error
Name = 'LUX';

% code for user =  Kirill only
if ~isempty(regexpi(getenv('username'), 'Kirill'))
    workfolder = hmdpath(Name, 'root');
    % code for user =  Kirill only
    addpath( hmdglobalsf('LexisSoftwareFolder'));
    addpath(hmdpath(Name, 'matlab'));
    %cd(hmdpath(Name, 'matlab'));
    cd(hmdpath(Name, 'indb'));
end

%% run
disp('Read...');

% MPIDR script
indb_input('LUX');
load LUX;

d=selif(deaths, deaths(:, end)==1);
d=d(:,1:end-1);
p=selif(population, population(:, end)==1);
p=p(:,1:end-1);
births=selif(births, births(:, end)==1);
births=births(:,1:end-1);

d=d_ma0(d,0);
d=d_s1x1(d, births);
d=d_soainew(d);
d=d_long(d);

d=d_unk(d);   

disp('population');

clear population;

p=p_movedata(p);
%p1=selif(p,p(:,5)==1978 | p(:,5)==1979);
%p1=p_movedata(p1);
%p=p_postcensal(p,d,births,[2002 2002]);
disp('Intercensal');
save rsd
%p1=p_srecm(p, d);
%p1=selif(p,p(:,3)>=100 & p(:,5)==2001);
%p=delif(p,p(:,3)>=100 & p(:,5)==2001);
%p=[p;p1];

p=p_ic(p, d, births);
save rsp
p=p_precensal(p,d,[1960, 1960]);
disp('Extinct cohort method');
%p=[p;p1];
p=p_srecm(p, d);
%p=p_ecm_area(p,d,1982:1982,79:79);      %!!! KA
%p=p_ecm_area(p,d,1972:1974,76:79);      %!!! KA

ldb_output(d, p, 'mLUX.txt', 'fLUX.txt', births);
d_printRA('lux','Luxembourg');

%% move lexis databases
for sexl = {'m' 'f'}
    sexlc = char(sexl);
    fname1 = [hmdpath(Name, 'indb') sexlc Name '.txt'];
    fname2 = [hmdpath(Name, 'lxdb') sexlc Name '.txt'];
    % cmd  = sprintf('xcopy "%s" "%s" /Y', fname1, fname2);
    delete(fname2);  copyfile(fname1, fname2, 'f');  delete(fname1);
end

%% code for user =  Kirill only
if ~isempty(regexpi(getenv('username'), 'Kirill'))
    rmpath(hmdglobalsf('LexisSoftwareFolder'));
    rmpath(hmdpath(Name, 'matlab'));
%     cd('E:\!Home\HMD\HMDWork\DNK\Matlab\');
%     cd('..\indb');
end

% ---------------------------
% 
% clearall
% dbstop if error
% Name = 'LUX';
% 
% % code for user =  Kirill only
% if ~isempty(regexpi(getenv('username'), 'Kirill'))
%     workfolder = ['E:\!Home\HMD\HMDWork\' Name '\'];
%     % code for user =  Kirill only
%     addpath E:\!Home\HMD\MPIMirror\Soft\Lexis
%     addpath(['E:\!Home\HMD\HMDWork\' Name '\Matlab']);
%     cd([workfolder 'Matlab']);
%     cd('..\indb');
% end
% 
% % MPIDR script
% flgError = true;
% ldb_lux;
% % try
% %     scrname = ['ldb_' lower(Name)];
% %     eval(scrname);
% % catch
% %     flgError = false;
% %     % continue with re-seting paths
% % end
% 
% 
% % code for user =  Kirill only
% if ~isempty(regexpi(getenv('username'), 'Kirill'))
%     rmpath E:\!Home\HMD\MPIMirror\Soft\Lexis
%     rmpath(['E:\!Home\HMD\HMDWork\' Name '\Matlab']);
% %     cd('E:\!Home\HMD\HMDWork\DNK\Matlab\');
% %     cd('..\indb');
% end
% 
% % if flgError
% %     error('Cannot run script');
% % end