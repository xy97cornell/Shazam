function songName = matching(testOption,clip,hashTable,songNameTable,gs,deltaTL,deltaTU,deltaF) 

hashTable = hashTable.hashTable;
songNameTable = songNameTable.songNameTable;
matFiles = load('matFiles.mat');
matFiles = matFiles.matFiles;
 

if testOption == 2
    clipTable = make_table(clip, gs, deltaTL, deltaTU, deltaF);
elseif testOption ==1
    load(clip, '-mat');
    clip = y(:,1);
    clipTable = make_table(clip, gs, deltaTL, deltaTU, deltaF);
end
    

clipHash = hash(clipTable);
matchMatrix = [];

for i = 1: length(clipHash(:,1))
   q=(clipHash(i)==hashTable(:,1)); 
   matchI = find(q); 
   t1c = clipHash(i,2);
   t1s = hashTable(matchI,2);
   t0 = t1s-t1c;
   matchMatrix = [matchMatrix; t0 hashTable(matchI,3)];
end

M = mode(matchMatrix(:,1));
I = logical(M==matchMatrix(:,1));
ModesongNames = matchMatrix(I,2); 

[songNum, f] = mode(ModesongNames);

if (f/length(ModesongNames) > 0.35)
    songName=matFiles(songNum);
else
    songName = 'no-decision';
end


