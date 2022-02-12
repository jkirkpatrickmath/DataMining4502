% DNK
clearall
dbstop if error
Name = 'DNK';

if ~isempty(regexpi(getenv('username'), 'Kirill'))
    % code for user =  Kirill only
    addpath E:\!Home\HMD\MPIMirror\Soft\Lexis
    cd('E:\!Home\HMD\HMDWork\DNK\Matlab\');
    cd('..\indb');
end

indb_input('DNK');
load DNK;

d=selif(deaths, deaths(:, end)==1);
d=d(:,1:end-1);
p=selif(population, population(:, end)==1);
p=p(:,1:end-1);
births=selif(births, births(:, end)==1);
births=births(:,1:end-1);

clear deaths;
clear population;

disp('open age interval');
d=d_s5x1(d);
d=d_ma0(d,0);
d=d_s1x1tn(d, births, tadj);
d=d_soainew(d);
d=d_unk(d);
d=d_long(d);

save rsd
disp('distribution of unknown');
d=d_unk(d);

save rsd1

%p=selif(population, population(:, 5)>=1840);% & population(:, 5)~=2004);

p=p_ict(p, d, births, tadj);
disp('Extinct cohort method');
p=p_ecmt(p, d, tadj);
p=p_precensal(p, d, [1835, 1841]);

ldb_output(d, p, 'mDNK.txt', 'fDNK.txt', births);
d_printRA('dnk','Denmark');

%% move lexis databases
for sexl = {'m' 'f'}
    sexlc = char(sexl);
    fname1 = [hmdpath(Name, 'indb') sexlc Name '.txt'];
    fname2 = [hmdpath(Name, 'lxdb') sexlc Name '.txt'];
    % cmd  = sprintf('xcopy "%s" "%s" /Y', fname1, fname2);
    delete(fname2);  copyfile(fname1, fname2, 'f');  delete(fname1);
end


if ~isempty(regexpi(getenv('username'), 'Kirill'))
    % code for user =  Kirill only
    rmpath E:\!Home\HMD\MPIMirror\Soft\Lexis
%     cd('E:\!Home\HMD\HMDWork\DNK\Matlab\');
%     cd('..\indb');
end
