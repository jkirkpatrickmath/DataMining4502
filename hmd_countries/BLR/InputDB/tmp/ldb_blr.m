function ldb_rus=ldb_rus()

indb_input('BLR');
load BLR;

d=selif(deaths, deaths(:, end)~=0);
deaths=deaths(:,1:end-1);
p=selif(population, population(:, end)==1);
p=p(:,1:end-1);
births=selif(births, births(:, end)==1);
births=births(:,1:end-1);


%split by triangles
disp('split by triangles');
d=d_s1x1(d, births);

%open age interval
disp('open age interval');
d=d_soainew(d);


%distribution of unknown 
disp('distribution of unknown');
d=d_unk(d);


%p=selif(p, p(:,5)>1980);

p=p_unk(p);
p=p_ic(p,d,births);

disp('SR-method');
p=p_srA(p, d, 85);
p=p_srecm(p, d);
%p=p_postcensal(p,d,births,[2006 2006]);


ldb_output(d, p, 'mBLR.txt', 'fBLR.txt', births);
d_printRA('blr','Byelorussia');