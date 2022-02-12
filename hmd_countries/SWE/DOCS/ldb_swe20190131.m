 %function ldb_swe=ldb_swe()
global nofluctM nofluctF
nofluctM=1755:1861;
nofluctF=1755:1861;


 indb_input('SWE');
 load SWE;

 d=selif(deaths, deaths(:, end)~=0);
 deaths=deaths(:,1:end-1);
 p=selif(population, population(:, end)==1);
 p=p(:,1:end-1);
 births=selif(births, births(:, end)==1);
 births=births(:,1:end-1);

 d1=selif(deaths, deaths(:,10) ~= 21 | deaths(:,3)<1861);
 d2=selif(deaths, deaths(:,10) == 21 & deaths(:,3)>=1861);

 clear deaths;
   

 disp('unk: split by rectangles');
 d=d_unk5(d1, d2);

 d=d_ma0(d,0);

disp('split by rectangles');
d=d_s5x1(d);

disp('split by triangles');
d=d_s1x1(d, births);


disp('open age interval');
d=d_soainew(d,1861);

disp('long');
d=d_long(d);

disp('distribution of unknown');
d=d_unk(d);


disp('population');
disp('read...');

%p=selif(population, population(:,2)~=3 & (population(:,5)<=1860 | population(:,10)~=31));% & population(:,5)>=1850);
clear population;

p=p_ey2ny(p);
p=p_my(p);

p=p_unk(p);

p=p_ic(p, d, births,0);


p=p_s5x1(p,d);
p=p_ecm(p, d);

%save rsp4 

p=p_precensal(p, d, [1751, 1751]);

ldb_output(d, p, 'mSWE.txt', 'fSWE.txt', births);
