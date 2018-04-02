function hashTable = hash(Table)
% Number of columns
[r,c] = size(Table);

% Hashes table values
freq1 = Table(:,1) - 1;
freq2 = Table(:,2) - 1;
time1 = Table(:,3);
deltaT = Table(:,4);
h = freq1.*2^8 + freq2 + deltaT.*2^16;
if c == 4
    songID = zeros(r,1);
    hashTable = [h time1 songID];
elseif c == 5
    hashTable = [h time1 Table(:,5)];
end

