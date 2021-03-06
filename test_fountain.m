close all;
clear;
clc;

%%
%Define the file consisting of n bytes data
packetsize = 5;

%link quality
LQ = 0.5;

%%
table = [];

% 0, continue; 1, finish!
decodestatus = 0; 

% number of times for transmission
ntr = 0;

% Generate n bytes data randomly to construct the source file.
sourcefile = gensourcefile(packetsize);

%% one hop with two nodes
% while(~decodestatus)
%     % Generate code
%     [code, degree, neighborlist] = fountainencode(sourcefile);    
%     
%     % Link Quality
%     lqneighborlist = linkstatus(LQ) * neighborlist;
%     
%     ntr = ntr + 1;
%     
%     % Generate table.
%     % The tables describes in each fountain code, which data is combined and what is the result.
%     % It is similar to the A and b in the system of unlinear equations Ax = b.
%     table = gentable(packetsize, table, lqneighborlist, code);
% 
% 
%     [decodestatus, decode] = fountaindecode(packetsize, table); 
%     
%     if decodestatus == 1
%         fprintf('Finish!\n');
%     end
% 
% end

%%
s=sprintf('%d ', sourcefile);
fprintf('Source: %s\n', s);
d=sprintf('%d ', decode);
fprintf('Decode: %s\n', d);
fprintf('Trasmit %d pacets\n', ntr);
fprintf('Receive %d pacets\n',size(table,1));

 

