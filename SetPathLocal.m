function SetPathLocal(base)

% SetPathLocal(base)
%
% DESC:
% sets the paths
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.4
%
% INPUT:
% base              = base directory (optional)
%
% SEE ALSO          RANSAC_update.m

% HISTORY
% 1.0.0                         ??/??/07 - intial version
% 1.0.1                         ??/??/07 - add base directory parameter
% 1.0.2                         11/08/07 - some improvements
% 1.0.3                         06/26/08 - added seed global variable
% 1.0.4                         11/25/10 - automatic addition of model directories

warning('off','MATLAB:dispatcher:pathWarning');

% save the seed for the random number generator.
% From matlab help:
% rand(method,s) causes rand to use the generator determined by method, and
% initializes the state of that generator using the value of s.
% The value of s is dependent upon which method is selected. If method is 
% set to 'state' or 'twister', then s must be either a scalar integer value
% from 0 to 2^32-1 or the output of rand(method). If method is set to 
% 'seed', then s must be either a scalar integer value from 0 to 2^31-2 or 
% the output of rand(method).
global RANSAC_SEED;
RANSAC_SEED = 2222;

% if the base directory is not specified, then pick the current one
global RANSAC_ROOT;
if (nargin < 1) || isempty(base)
    RANSAC_ROOT = pwd;
else
    RANSAC_ROOT = base;
end;

if nargin < 1
    fprintf('\nBase directory set to: %s\n', RANSAC_ROOT)
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init Matlab directories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
models_dir = '/Models/';
file_list = dir( sprintf('%s%s', RANSAC_ROOT, models_dir) );
nd = 1;
dirs = {};
for h = 1:numel(file_list)
  if ( file_list(h).isdir ) && ...
     ( ~strcmp(file_list(h).name, '..') ) && ...
     ( isempty(strfind(file_list(h).name, '.')) ) 
    dirs{nd} =  sprintf('%s%s', models_dir, file_list(h).name);
    nd = nd + 1;
  end;
end;

fprintf('\n%d models automatically added:\n', nd-1);
for h = 1:nd-1
  fprintf('%s\n', dirs{h});
end;

dirs{nd} = '/Common';
dirs{nd+1} = '/.';

for h = 1:numel(dirs)
    addpath(path, sprintf('%s%s', RANSAC_ROOT, dirs{h}));
end;

warning('off','MATLAB:dispatcher:pathWarning');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if Octave take care of the windows server
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (exist('OCTAVE_VERSION','var') ~= 0)
    setenv('GNUTERM', 'x11')
end;

return
