% function latency = pando(lqdeploy, sourcefile)
clear;
close;
clc;

scale = 2;

sourcefile = [131 120 120 242 151] ;
packetsize = size(sourcefile,2);
ntr = 0;
table = [];
% position = genposition(number,range);

position = [
    1.0000    0.2973    0.0083;
    2.0000    0.7169   -0.3479;
    3.0000    2.1052   -1.2682;
    4.0000    0.3296    1.5400;
    5.0000   -0.6591   -2.3215;
    6.0000   -0.7562    0.6589;
    7.0000    0.1327    0.5194;
    8.0000   -0.2673   -1.3689;
    9.0000   -1.5335   -1.4166;
   10.0000    0.3235   -1.0375];
rt = networkdeploy(position, scale);

lqdeploy = [
    1.0000         0    1.0000    0.0885    0.9943;
    2.0000         0    2.0000    0.6350    0.9662;
    3.0000         0    4.0000    2.4802    0.7154;
    4.0000         0    6.0000    1.0060    0.9231;
    5.0000         0    7.0000    0.2874    0.9832;
    6.0000         0    8.0000    1.9453    0.7857;
    7.0000         0   10.0000    1.1811    0.8418;
    8.0000    2.0000    3.0000    2.7743    0.6441;
    9.0000    8.0000    5.0000    1.0610    0.9140;
   10.0000    8.0000    9.0000    1.6055    0.7937;
   11.0000   10.0000    3.0000    3.2277    0.5859;
   12.0000   10.0000    5.0000    2.6142    0.6672;
   13.0000   10.0000    9.0000    3.5922    0.5854];

idnum = unique(lqdeploy(:,2:3));

%link quality status dynamic table
lqsdt = [];

for i = 1:1:size(lqdeploy(:,3))
    if ~ismember(lqdeploy(i,3), lqsdt)
        lqsdt = [lqsdt;lqdeploy(i,3)];
    end
end

numr = size(lqsdt,1); 
nodelq = zeros(numr,1);
rxstatus = zeros(numr,1);
destatus = zeros(numr,1);
delay = zeros(numr,1);
lqsdt = [lqsdt, nodelq, rxstatus, destatus, delay];

for i = 1:1:numr
    table{i} = [];
end

while ~all(lqsdt(:,4)>0)
        
    for i = 1:1:numr
        if lqsdt(i,4) == 1
            lqsdt(i,3) = 1;
        end
    end
    
    for i = 1:1:numr
        unlq = 1;
        routeid = find(lqdeploy(:,3) == lqsdt(i,1));
        for j = 1:1:size(routeid,1)
            s_id = lqdeploy(routeid(j,1),2);
            if s_id == 0
               pstatus = 1;
            else
               pstatus = lqsdt(s_id, 3);
            end
            unlq = (1-pstatus*lqdeploy(routeid(j,1),end))*unlq;
        end
        lq = 1 - unlq;
        lqsdt(i,2) = lq;
    end
        
    
    [code, degree, neighborlist] = fountainencode(sourcefile);
    ntr = ntr + 1;
    
    for i = 1:1:size(lqsdt,1)
        noderxstatus = linkstatus(lqsdt(i,2));
        lqsdt(i,3) = noderxstatus;
        lqneighborlist = noderxstatus * neighborlist;
        
        % Generate table.
        % The tables describes in each fountain code, which data is combined and what is the result.
        % It is similar to the A and b in the system of unlinear equations Ax = b.
        table{i} = gentable(packetsize, table{i}, lqneighborlist, code);


        [decodestatus, decode] = fountaindecode(packetsize, table{i}); 

        if decodestatus == 1 && lqsdt(i,4) ==0
            lqsdt(i,4) = 1;
            lqsdt(i,5) = ntr;
        end
    end
end