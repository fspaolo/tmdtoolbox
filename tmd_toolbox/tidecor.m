%
% Script for running 'tmd_tide_pred.m' in parallel on several HDF5 files.
%
% This script facilitates the use of the Matlab Tide Model Driver (TMD):
% 
%    https://www.esr.org/research/polar-tide-models/tmd-software/
%
% To edit in the code:
%   - path(s) to input HDF5 data file(s)
%   - path to tide and load model control files
%   - names of variables: lon, lat, time, height
%   - reference epoch for input time in seconds
%   - number of parallel jobs
% 
% To run from Terminal:
%   /path/to/matlab -nodesktop < tidecor.m
% 
% To run from Matlab GUI:
%   tidecor
%
% Units of input variables:
%   lon (deg)
%   lat (deg)
%   time (secs since epoch)
%   height (m)
%
% Parallelization:
%   * For optimal efficiency, merge/split the input files into N files,
%     with N equal number of cores (even if the files end up fairly large).
%
% Notes:
%   * If files to process are in multiple folders, just provide a list
%     with the paths for the different locations.
%   * Some original Matlab scripts were modified to improve performance.
%     These modifications include replacing loops by vectorization, and
%     improving the I/O for multiple data files.
%   * Ignore => "Warning: Name is nonexistent or not a directory: /FUNCTIONS"
%   * Modifications were made by Fernando Paolo and Alex Gardner (JPL/Caltech),
%     and they are marked in the respective codes.
% 
% Apply Tide and Load corrections:
%   h_cor = h - tide - load
%
% Code written by Fernando Paolo <paolofer@jpl.nasa.gov>
% Jet Propulsion Laboratory, Caltech, Jun 29, 2017 


% If licence (user limit) is not available, pause and check again
status = 0;
while ~status
    [status, errmsg] = license('checkout', 'Distrib_Computing_Toolbox');
    pause(30);
end

clear ALL
tic;

%================================================================
%   Edit here
%================================================================

% List of paths to input files. Ex: {'/path/one/*.h5', '/path/two/*.h5'}
PATHS = {'/mnt/bylot-r2/shared_data/ers1/floating/latest/*_ICE_*_A_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/ers1/floating/latest/*_ICE_*_D_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/ers1/floating/latest/*_OCN_*_A_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/ers1/floating/latest/*_OCN_*_D_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/ers2/floating/latest/*_ICE_*_A_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/ers2/floating/latest/*_ICE_*_D_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/ers2/floating/latest/*_OCN_*_A_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/ers2/floating/latest/*_OCN_*_D_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/envisat/floating/latest/*_A_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/envisat/floating/latest/*_D_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/icesat/floating/latest/*_A_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/icesat/floating/latest/*_D_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/cryosat2/floating/latest/*_A_*_tile_???.h5',
         '/mnt/bylot-r2/shared_data/cryosat2/floating/latest/*_D_*_tile_???.h5'}

%PATHS = {'/Users/paolofer/data/ers1/thwaites/*.h5'};

% Number of parallel jobs
NJOBS = 16;

% Name of variables if HDF5 files
XVAR = '/lon'; 
YVAR = '/lat';
TVAR = '/t_sec';
ZVAR = '/h_res';

% DEPRECATED (use HDF5 only)
% Columns of x/y/t if ASCII files (Matlab uses 1-based indexing!)
XCOL = 4;
YCOL = 3;
TCOL = 2;

% Reference epoch of input time in seconds (Y, M, D, h, m, s)
% (The above converts given date to number of days since January 0, 0000)
REFTIME = datenum(1970, 1, 1, 0, 0, 0);

% Path to tide model
TIDEMODEL = 'DATA/Model_CATS2008a_opt';

% Path to load-tide model
LOADMODEL = 'DATA/Model_tpxo7.2_load';

% Path to TMD functions
addpath(genpath('.'));

%================================================================

% Get list of files per path and concatenate all file names
files = {};
for i = 1:length(PATHS)
    d = dir(PATHS{i});
    ifiles = strcat({d.folder}, '/', {d.name});  % list of file names (full paths)
    files = cat(2, files, ifiles);
end

% Start pool of workers
pool = gcp('nocreate');
if isempty(pool)
    parpool(NJOBS);
end

% Process files in parallel (parallel for loop)
parfor i = 1:length(files)

    infile = files{i}

    fprintf('processing file: %s ...\n', infile);

    % Get variables from file
    x = h5read(infile, XVAR);
    y = h5read(infile, YVAR);
    t = h5read(infile, TVAR);
    h = h5read(infile, ZVAR);

    %% Loads ASCII file into matrix
    %data = dlmread(infile);

    %lon = data(:,XCOL);
    %lat = data(:,YCOL);
    %time = data(:,TCOL);

    % Serial date number (this is number of days since 0000-Jan-1)
    SDtime = (t/86400.) + REFTIME;    

    % Predict tide values using the TMD toolbox
    [z, conList] = tmd_tide_pred(TIDEMODEL, SDtime, y, x, 'z');
    [l, conList] = tmd_tide_pred(LOADMODEL, SDtime, y, x, 'z');

    % Make sure dimensions correspond
    z = reshape(z, length(z), 1);
    l = reshape(l, length(z), 1);

    % Change NaN -> 0
    z(isnan(z)) = 0;                    
    l(isnan(l)) = 0;

    % Apply corrections
    h_cor = h - (z + l);

    % Save data in the same input file
    h5create(infile,'/h_tide', length(z));
    h5create(infile,'/h_load', length(l));
    h5write(infile, '/h_tide', z);
    h5write(infile, '/h_load', l);
    h5write(infile, ZVAR, h_cor);

    % Rename file
    [path, fname, ext] = fileparts(infile);
    outfile = fullfile(path, strcat(fname, '_TIDE', ext));
    movefile(infile, outfile);

    % Write corrections to external file (?)
    %[path, fname, ext] = fileparts(infile);
    %outfile = fullfile(path, strcat(fname, '.tide_matlab'));
    %dlmwrite(outfile, [lon lat time z' l'], ' ')
     
    fprintf('Output -> %s\n', outfile);

    fclose('all');

end

% Get the current pool and shut it down
pool = gcp('nocreate');
delete(pool);

toc;
