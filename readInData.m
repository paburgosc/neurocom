function D = readInData(fn)

fid = fopen(fn);
%fid = fopen(fn,'r','native','UTF-16');  % will read in headers, but
%doesn't seem to work with the whole file once you get to the column data

% Read in headers
for i=1:26
    C{i} = fgetl(fid);
    %disp(C{i})
end
H1 = C;
[S]  =H1{8}(13:end);     % SUB_ID
D.SUB_ID=S;
% N = sscanf(S,'ATID%d'); % scan prefix 'ATID####' and extract number
% if isempty(N)   % if prefix not found
%     D.SUB_ID=str2num(S);    % use original string
% else
%     D.SUB_ID=N;    % use extracted number
% end
% [D.Cond]    =str2num(H1{20}(19:end));      % COND #
% [D.Trial]   =str2num(H1{21}(15:end));     % TRIAL #
% [D.TestDate]=H1{16}(12:end);     % TEST DATE
% [D.TestTime]=H1{17}(12:end);     % TEST TIME

%C([5 6 7 9 14]) = []; Discard PHI

for i=1:3
    fgetl(fid);
end

nCols = 38;  % was 21

C = textscan(fid,'%s',nCols);
H2 = C{1};   % Headers

C = textscan(fid,'%s',nCols);
N = C{1};   % Names of Variables

fmt = '';
for i = 1:nCols
    fmt = strcat(fmt,'%f'); % repeat for each column
end
%C = textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','CollectOutput',1);
C = textscan(fid,fmt,'CollectOutput',1);
D.mydata = C{1};   % Data in 21 x Inf matrix

end