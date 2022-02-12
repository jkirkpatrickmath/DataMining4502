function ldb_grc()

disp('Read...');

%indb_input('GRC');
load grc;
d=deaths(deaths(:, end)==1,1:end-1);
clear deaths
p=population(population(:, end)==1,1:end-1);
clear population
births=births(births(:, end)==1,1:end-1);

disp('split by triangles');
d=d_s5x1(d);
d=d_unk(d);
d=d_s1x1(d, births);


disp('open age interval');
d=d_soainew(d,1950);

save rsd

p=p_unk(p);
save rsp
disp('Intercensal');
p=p_ic(p,d,births);
p=p_precensal(p, d,[1990, 1991],1);

disp('Extinct cohort method');
p=p_srecm(p,d);


save rsp

ldb_output(d, p, 'mGRC.txt', 'fGRC.txt', births);
d_printRA('grc','Greece');