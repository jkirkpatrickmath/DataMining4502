%clearall
%dbstop if error
%Name = 'ESP';

%if ~isempty(regexpi(getenv('username'), 'Kirill'))
%    % code for user =  Kirill only
%    addpath E:\!Home\HMD\MPIMirror\Soft\Lexis
%    cd('E:\!Home\HMD\HMDWork\ESP\Matlab\');
%    cd('..\indb');
%end

indb_input('ESP');
load ESP;

deaths=selif(deaths, deaths(:, end)==1);
deaths=deaths(:,1:end-1);
p=selif(population, population(:, end)==1);
p=p(:,1:end-1);
births=selif(births, births(:, end)==1);
births=births(:,1:end-1);

d=d_s5x1(deaths);
disp('split RR');
d=d_s1x1tn(d, births, tadj);

disp('open age interval');
d=d_soainew(d);

disp('distribution of unknown');
d=d_unk(d);
d=d_long(d);
save rsd

disp('population');



%disp('Extinct cohort method');
p=selif(p,p(:,5)>1900 & (p(:,3)<80 | p(:,5)~=1960) & (p(:,3)<85 | p(:,5)~=1970));
p=p_ey2ny(p);
p=p_precensal(p, d, [1908, 1910]);
%p=p_postcensal(p, d, births, [2002, 2002]);
%py=unique(p(:,5));

p1=p_srecmt(p,d,tadj);
p1=selif(p1,((p1(:,3)>=80 & p1(:,5)==1961) | (p1(:,3)>=85 & p1(:,5)==1971)) & p1(:,3)<=130);
%%%Celeste and Tim add this line to remove the open age group at 85+ for
%%%1971 (which has been expanded into single age groups in the previous
%%%function call)
%%%p = delif(p,((p(:,3) == 85) & (p(:,4) == 0) & (p(:,5) == 1971)));
p=[p;p1];

p=p_ict(p, d, births, tadj);
p=p_srecmt(p,d,tadj);
ldb_outputt(d, p, 'mESP.txt', 'fESP.txt', births, tadj);
d_printRA('ESP','Spain');


%% move lexis databases
%for sexl = {'m' 'f'}
%    sexlc = char(sexl);
%    fname1 = [hmdpath(Name, 'indb') sexlc Name '.txt'];
%    fname2 = [hmdpath(Name, 'lxdb') sexlc Name '.txt'];
%   % cmd  = sprintf('xcopy "%s" "%s" /Y', fname1, fname2);
%    delete(fname2);  copyfile(fname1, fname2, 'f');  delete(fname1);
%end


%if ~isempty(regexpi(getenv('username'), 'Kirill'))
%    % code for user =  Kirill only
%    rmpath E:\!Home\HMD\MPIMirror\Soft\Lexis
%     cd('E:\!Home\HMD\HMDWork\DNK\Matlab\');
%     cd('..\indb');
%end

