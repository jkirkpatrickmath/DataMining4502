% system("matlab -nodesktop -nojvm -nosplash < /data/commons/triffe/git/HMD_CS/HMDwork/C_PRT/PRT/InputDB/ldb_prt.m")

%function ldb_ptr()
%cd('/data/commons/triffe/git/HMD_CS/HMDwork/C_PRT/PRT/InputDB')
%addpath('/data/wilmoth0/HMDBmirror/Soft/Lexis')
%addpath('/data/commons/triffe/git/HMD_CS/HMDwork/C_PRT/PRT/InputDB')
global nofluctM nofluctF
disp('read in data');
indb_input('PRT');
load PRT;
% select deaths with LDB == 1
d      = selif(deaths, deaths(:, end)==1);
% remove LDB column from deaths
d      = d(:,1:end-1);
% select pop with LDB == 1
p      = selif(population, population(:, end)==1);
% remove LDB column from pop
p      = p(:,1:end-1);
% select births with LDB == 1
births = selif(births, births(:, end)==1);
% remove LDB column from births
births = births(:,1:end-1);
clear population;

disp('split by rectangles');
d = d_s5x1(d);
clear deaths;
disp('impute 0s in deaths');
d = d_ma01(d,0);

disp('split deaths into triangles');
d = d_s1x1(d, births);

disp('deaths open age interval');
d = d_soainew(d);

disp('extend deaths to age 130');
d = d_long(d);

disp('distribute deaths of unknown age');
d = d_unk(d);


disp('population');
disp('distribute population of unknown age');
p = p_unk(p);
disp('move Dec 31 to Jan 1 of following year');
p = p_ey2ny(p);

disp('uncomplicated intercensal estimates');
p=p_ic(p, d, births);
%disp('survivor ratio method starting at age 85 (instead of 90)');
%p=p_sra(p, d, 85);
%disp('extinct cohort method starting at age 85 (instead of 90)');
%p=p_ecmA(p, d, 85);
disp('survivor ratio method starting at age 90');
p=p_sra(p, d, 90);
disp('extinct cohort method starting at age 90');
p=p_ecmA(p, d, 90);
%disp('survivor ratio and extinct cohort methods');
%p=p_srecm(p, d);

save rsp
disp('precensal estimates to Jan 1, 1940');
p=p_precensal(p, d, [1940, 1940],1);

disp('save to LexisDB');
ldb_output(d, p, 'mPRT.txt', 'fPRT.txt', births);
%d_printRA('PRT','PRT');