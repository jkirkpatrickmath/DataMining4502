% ISL

% code for user =  Kirill only
if ~isempty(regexpi(getenv('username'), 'Kirill'))
    clearall
    workfolder = 'E:\!Home\HMD\HMDWork\ISL\';
    % code for user =  Kirill only
    addpath E:\!Home\HMD\MPIMirror\Soft\Lexis
    addpath E:\!Home\HMD\HMDWork\ISL\Matlab
    cd([workfolder 'Matlab']);
    cd('..\indb');
end

% MPIDR script
ldb_isl

% code for user =  Kirill only
if ~isempty(regexpi(getenv('username'), 'Kirill'))
    rmpath E:\!Home\HMD\MPIMirror\Soft\Lexis
    rmpath E:\!Home\HMD\HMDWork\ISL\Matlab
%     cd('E:\!Home\HMD\HMDWork\DNK\Matlab\');
%     cd('..\indb');
end
