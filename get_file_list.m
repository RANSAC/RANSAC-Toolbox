function f = get_file_list(dir_name, id, dir_recurse)

% f = get_file_list(dir_name, id, dir_recurse)
%
% DESC:
% Return a file list of the files wich match the regular expression id
%
% AUTHOR
% Marco Zuliani - zuliani@ece.ucsb.edu
%
% VERSION
% 1.0.1
%
% INPUT:
% dir_name      = directory name
% id            = regular expression
% dir_recurse   = true to recurse inside the directory
%
% OUTPUT:
% f             = struct containing the file list
%                 pathstr   -> the path of the file
%                 name      -> name of the file (no extension)
%                 ext       -> extension of the file
%                 versn     -> version info
%                 filename  -> entire filename
%
% EXAMPLE:
%
% Remove all the temporary files created by Matlab
%
% f = get_file_list('/Users/zuliani/Research', '.m~', true);
% for h = 1:numel(f)
%   delete(f(h).filename);
% end;

% HISTORY
% 1.0.0        ??/??/04 - Initial version
% 1.0.1        11/28/04 - add directory recursion

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 3
    dir_recurse = false;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = dir(dir_name);

l = 0;
f = [];
for h = 1:numel(d)

    % skip . and ..
    if (~strcmp(d(h).name, '.')) && (~strcmp(d(h).name, '..'))

        % check if it is a directory
        if (dir_recurse) && (d(h).isdir)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % recursively run the procedure on the subdir
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            fr = get_file_list(fullfile(dir_name, d(h).name), id, true);

            % copy back the results
            for k = 1:numel(fr)
                l = l + 1;
                
                f(l).pathstr = fr(k).pathstr;
                f(l).name = fr(k).name;
                f(l).ext = fr(k).ext;
                f(l).versn = fr(k).versn;
                f(l).filename = fr(k).filename;
            end;

        else

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % search using regular expression
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            [start, finish] = regexp(d(h).name, id);

            if ~isempty(start) && ~isempty(finish)
                l = l + 1;
                
                [pathstr, f(l).name, f(l).ext, f(l).versn] = fileparts(d(h).name);
                if ~isempty(pathstr)
                    f(l).pathstr = fullfile(dir_name, pathstr);
                else
                    f(l).pathstr = dir_name;
                end;
                
                f(l).filename = fullfile(f(l).pathstr, [f(l).name f(l).ext]);
            end;

        end;

    end;

end;

return