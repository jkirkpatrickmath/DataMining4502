function ldb_nor=ldb_nor()


indb_input('NOR');
load NOR;

d=selif(deaths, deaths(:, end)==1);
d=d(:,1:end-1);
p=selif(population, population(:, end)==1);
p=p(:,1:end-1);
births=selif(births, births(:, end)==1);
births=births(:,1:end-1);
clear deaths;
clear population

d=d_ma0(d,0);

disp('distribution VV');
d=d_svv(d);

disp('long');
d=d_long(d);

save rsd

disp('population');

disp('Extinct cohort method');
p=p_ecm(p, d);
save rsp
ldb_output(d, p, 'mNOR.txt', 'fNOR.txt', births);