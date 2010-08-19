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
destination_dir = '/Users/zuliani/Research/RANSACtoolbox';
author = 'Marco Zuliani';
% email = 'marco.zuliani@gmail.com';
email = 'marco.zuliani@gmail.com';
year = '2009';
license = 'GPL';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exclude list (with relative path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
exclude{1} = 'CreateRANSACtoolbox.m';
exclude{end+1} = 'get_file_list.m';
exclude{end+1} = 'Development';
exclude{end+1} = 'HowToGeneratePackage.txt';
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

% form the toolbox name
toolbox_dirname = sprintf('%s/RANSAC', destination_dir);
archive_filename = sprintf('%s_%s', toolbox_dirname, date);

% copy the files
[status, message, messageid] = copyfile('../RANSAC/', toolbox_dirname, 'f');

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
    case {'GLNX86', 'MAC', 'MACI', 'GLNXA64', 'SOL64'}
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

% remove the SVN dirs
f = get_file_list(toolbox_dirname, '.svn', true);

for h = 1:numel(f)
    switch exist(f(h).filename)
        case 2
            delete(f(h).filename);
        case 7
            rmdir(f(h).filename, 's');
    end;
    
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add the license
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = get_file_list(toolbox_dirname, '\.m$', true);

% take care of the damn CR LR
switch computer
    case {'GLNX86', 'MAC', 'MACI', 'GLNXA64', 'SOL64'}
        cmd = 'dos2unix -q';
    case {'PCWIN', 'PCWIN64'}
        cmd = 'unix2dos';
    otherwise
        error('Unknown platform')
end;
for h = 1:numel(f)
    eval(sprintf('!%s %s', cmd, f(h).filename));
end;

add_license(f, author, email, year, license);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the archive
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copy the documentation
toolbox_doc_dirname = [toolbox_dirname '\Docs'];
mkdir(toolbox_doc_dirname);
copyfile('~/Documents/Lectures/RANSAC4Dummies/RANSAC4Dummies.pdf', toolbox_doc_dirname);

switch computer
    case {'GLNX86', 'MAC', 'MACI', 'GLNXA64', 'SOL64'}
        % eval(sprintf('!tar -czvf %s.tgz %s/', archive_filename, toolbox_dirname));
        zip(sprintf('%s.zip', archive_filename), toolbox_dirname);
    case {'PCWIN', 'PCWIN64'}
        zip(sprintf('%s.zip', archive_filename), toolbox_dirname);
    otherwise
        error('Unknown platform')
end;
