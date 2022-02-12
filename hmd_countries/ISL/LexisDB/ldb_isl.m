function ldb_isl=ldb_isl()
global nofluctM nofluctF
nofluctM=1755:2005;
nofluctF=1755:2005;

disp('Read...');

indb_input('ISL');
load ISL;
d=selif(deaths, deaths(:, end)==1);
d=d(:,1:end-1);
p=selif(population, population(:, end)==1);
p=p(:,1:end-1);
births=selif(births, births(:, end)==1);
births=births(:,1:end-1);

clear population
clear deaths

   

d=d_ma01(d,0);
disp('split by rectangles');
d=d_s5x1(d);

disp('split by triangles');
d=d_s1x1(d, births);

disp('open age interval');
d=d_soainew(d);

disp('long');
d=d_long(d);

%distribution of unknown 
disp('distribution of unknown');
d=d_unk(d);
save rsd;

%output
disp('population');
p=p_ecm(p, d);

save rsp 

p=p_precensal(p, d, [1838, 1840]);

ldb_output(d, p, 'mISL.txt', 'fISL.txt', births);

d_printRA('ISL','Iceland');