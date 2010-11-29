function RANSAC_update()

% RANSAC_update()
%
% DESC:
% checks if it is available an updated version of the Toolbox and installs 
% it
%
% AUTHOR
% Marco Zuliani - marco.zuliani@gmail.com
%
% VERSION:
% 1.0.2
%
% SEE ALSO          SetPathLocal.m

% HISTORY
% 1.0.0             07/25/08 - intial version - R.I.P. Dr. R. Pausch
% 1.0.1             11/19/08 - modified links for the new Matlab central
% 1.0.2             11/19/08 - modified links for my site

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%url_version = 'http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=18555';
%url_download = 'http://www.mathworks.com/matlabcentral/fileexchange/18555?controller=file_infos&download=true';
url_version = 'http://vision.ece.ucsb.edu/~zuliani/Code/Code.html';
url_download = 'http://vision.ece.ucsb.edu/~zuliani/Code/Packages/RANSAC/RANSAC.zip';
dummy_filename = 'RANSAC.dummy';
post_installation_filename = 'post_installation.mat';

global RANSAC_ROOT;

if isempty(RANSAC_ROOT);
    error('RANSACToolbox:localPathError', 'Local path not set. Run SetPathLocal first')
end;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get current version info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check the version
fid = fopen('VERSION.txt', 'r');
if (fid < 0)
    error('RANSACToolbox:versionInfoError', 'Could not open file version.txt');
end;

version = fgetl(fid);

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get web version info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nConnecting to the hosting site... ');
s = urlread(url_version);

if isempty(s)
    error('RANSACToolbox:downloadError', 'Error downloading version information')
end;

fprintf('Done.')

% seek for the filename inside the web page
str = 'Last version:';
p1 = regexp(s, str, 'once');
if isempty(p1)
    error('RANSACToolbox:versionInfoError', 'Error finding version information');
end;
version_web = s(p1+length(str)+(0:11));
version_web(4) = '-';
version_web(8) = '-';

version_num = datenum(version, 'dd-mmm-yyyy');
try
    version_num_web = datenum(version_web, 'dd-mmm-yyyy');
catch
    error('RANSACToolbox:versionInfoError', 'Error parsing version information');
end;

if (version_num_web <= version_num)
    fprintf('\nYour version (%s) is up to date.\n', version);
    return;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mark the current directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nUpdating to version %s', version_web);

% create file marker
fid = fopen(dummy_filename, 'w');
if (fid < 0)
    error('RANSACToolbox:markerError', 'Unable to create marker file')
end;
fwrite(fid, sprintf('Dummy file generated at: %s', datestr(now, 'mmmm dd, yyyy HH:MM:SS.FFF AM')), 'char');
fclose(fid);

% get the target directory
dummy_path_filename = which(dummy_filename);
p = strfind(dummy_path_filename, dummy_filename);
update_path = dummy_path_filename(1:p(1)-2);
p = strfind(update_path, filesep);
update_path = update_path(1:p(end)-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a copy of the old package
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
backup = [update_path '/RANSAC.backup_' date];
[status, message] = copyfile([update_path '/RANSAC'], backup);
if (status == 0)
    error('RANSACToolbox:bakupError', ['Unable to create backup copy: ' message]);
end;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Downlaod and uncompress the data to the appropriate folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nUpdating... ')
unzip(url_download, update_path);
fprintf('Done!');

% remove the marker file
delete(dummy_path_filename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Execute post-installation operations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist(post_installation_filename, 'file')
    fprintf('\nPost installation... ')
    
    load(post_installation_filename);
    
    for n = 1:numel(cmd)
       eval(cmd{n}); 
    end
    fprintf('Done!');
end;

fprintf('The package was succesfully installed.');
fprintf('Your original installation has been saved to %s\n', backup)

return
