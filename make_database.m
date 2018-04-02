function make_database(gs,deltaTL,deltaTU,deltaF) 
close all


Files = what('songDatabase');
matFiles = Files.mat;
save('matFiles.mat', 'matFiles');
songNameTable =[];

for x= 1: length(matFiles)
    fileName = matFiles{x};
    toRead = ['songDatabase/',fileName];
    newTable = make_table(toRead, gs,deltaTL,deltaTU,deltaF);
    SongID(1:length(newTable),1:1) = x;
    songNameTable = [songNameTable; newTable SongID];
    SongID = [];
end
hashTable = hash(songNameTable);
save('hashTable.mat', 'hashTable');

save('songNameTable.mat','songNameTable');

