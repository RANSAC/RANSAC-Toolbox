% NAME:
% CreateRANSACToolbox.m
%
% DESC:
% creates the RANSAC toolbox

close all
clear 
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
root_dir = '/Users/zuliani/Documents';
RANSAC4Dummies_filename = strcat(root_dir, '/Papers/RANSAC4Dummies/RANSAC4Dummies.pdf');
destination_dir = strcat(root_dir, '/Research/RANSAC-toolbox');
author = 'Marco Zuliani';
email = 'marco.zuliani@gmail.com';
year = '2010';
license = 'GPL';

addpath(path, './Development')

% checks
if ~exist(root_dir, 'dir')
  error('RANSACToolbox:createToolboxError', sprintf('Root dir %s does not exist', root_dir));
end;

if ~exist(RANSAC4Dummies_filename, 'file')
  error('RANSACToolbox:createToolboxError', sprintf('Tutorial %s does not exist', RANSAC4Dummies_filename));
end;

if ~exist(destination_dir, 'dir')
  error('RANSACToolbox:createToolboxError', sprintf('Destination dir %s does not exist', destination_dir));
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exclude list (with relative path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
exclude{1} = 'CreateRANSACtoolbox.m';
exclude{end+1} = 'get_file_list.m';
exclude{end+1} = 'add_license.m';
exclude{end+1} = 'Development';
exclude{end+1} = 'HowToGeneratePackage.txt';
exclude{end+1} = 'octave-core';
if strcmp(license, 'GPL') == 0
    exclude{end+1} = 'COPYING_LESSER.txt';
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the version file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
version_num = datestr(now, 'dd-mmm-yyyy');
fid = fopen('VERSION.txt', 'w');
if (fid < 0)
    error('RANSACToolbox:createToolboxError', 'Unable to create version file')
end;
fwrite(fid, version_num, 'char');
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
isOctave = exist('OCTAVE_VERSION') ~= 0;

% form the toolbox name
toolbox_dirname = sprintf('%s/RANSAC', destination_dir);
archive_filename = sprintf('%s-%s', toolbox_dirname, date);
fprintf('\nToolbox path:     %s', toolbox_dirname);
fprintf('\nArchive filename: %s', archive_filename);

% copy the files bby performing an export to the target dir
if isOctave
  system(sprintf("svn export %s %s",'../RANSAC/', toolbox_dirname));
else
  error('RANSACToolbox:createToolboxError', 'Export not implemented for this configuration')
end;

% exclude the files
for h = 1:numel(exclude)
    temp = sprintf('%s/%s', toolbox_dirname, exclude{h});
    
    switch exist(temp)
        case 2
            delete(temp);
        case 7
            rmdir(temp, 's');
    end;
    
end;

% remove the autosaved files and other trash
switch computer
    case {'GLNX86', 'MAC', 'MACI', 'GLNXA64', 'SOL64', 'i386-apple-darwin10.4.0'}
        trash = '\.m~$|^[\.DS_Store]$';
    case {'PCWIN', 'PCWIN64'}
        trash = '\.asv$';
    otherwise
        error('Unknown platform')
end;

f = get_file_list(toolbox_dirname, trash, true);

for h = 1:numel(f)
    delete(f(h).filename)
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add the license
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = get_file_list(toolbox_dirname, '\.m$', true);

% take care of the damn CR LR
switch computer
    case {'GLNX86', 'MAC', 'MACI', 'GLNXA64', 'SOL64', 'i386-apple-darwin10.4.0'}
        cmd = 'dos2unix -q';
    case {'PCWIN', 'PCWIN64'}
        cmd = 'unix2dos';
    otherwise
        error('Unknown platform')
end;
for h = 1:numel(f)
    system(sprintf('%s %s', cmd, f(h).filename));
end;

add_license(f, author, email, year, license);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the archive
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copy the documentation
toolbox_doc_dirname = [toolbox_dirname '/Docs'];
mkdir(toolbox_doc_dirname);
copyfile(RANSAC4Dummies_filename, toolbox_doc_dirname);

switch computer
    case {'GLNX86', 'MAC', 'MACI', 'GLNXA64', 'SOL64', 'i386-apple-darwin10.4.0'}
        % eval(sprintf('!tar -czvf %s.tgz %s/', archive_filename, toolbox_dirname));
        if isOctave
          # note that the traditional zip command does not work
          # we would get the following error:
          # error: zip: zip failed with exit status = 12          
          str = sprintf('zip -r %s.zip %s', archive_filename, toolbox_dirname);     
          [status, output] = system(str);
        else
          zip(sprintf('%s.zip', archive_filename), toolbox_dirname);
        end;
    case {'PCWIN', 'PCWIN64'}
        zip(sprintf('%s.zip', archive_filename), toolbox_dirname);
    otherwise
        error('Unknown platform')
end;
