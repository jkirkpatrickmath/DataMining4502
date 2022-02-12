% CHE
% clearall

dbstop if error
Name = 'CHE';


indb_input('CHE');
load CHE;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=selif(deaths, deaths(:, end)==1);
d=d(:,1:end-1);
p=selif(population, population(:, end)==1);
p=p(:,1:end-1);
births=selif(births, births(:, end)==1);
births=births(:,1:end-1);

d=d_ma0(d);

d=d_soainew(d);
d=d_long(d);
d=d_vh2tltu(d);

save rsd

disp('population');

%p=selif(p, population(:,5)>=1876);
clear population;
p=p_ey2ny(p);


disp('Intercensal');
p=p_ic(p, d, births);

disp('Extinct cohort method');
p=p_srecm(p, d);

save rsp

% ldb_outputt(d, p, 'mCAN.txt', 'fCAN.txt', births, tadj); if tadj is
% present
ldb_output(d, p, 'mCHE.txt', 'fCHE.txt', births);
d_printRA('CHE','Switzerland');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


