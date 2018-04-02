function songName = main(testOption,clipName)

gs = 9;deltaTL=3;deltaTU=6;deltaF=9;
hashTable = load('hashTable');
songNameTable = load('songNameTable');
if (testOption == 1)
    load(clipName,'-mat');
    songName = matching(testOption,clipName,hashTable,songNameTable,gs,deltaTL,deltaTU,deltaF);
elseif (testOption == 2)
    Fs = 44100;
    bitsPerSample = 24;
    channel = 1;
    recordTime = 8;
    recorder = audiorecorder(Fs,bitsPerSample,channel);
    recordblocking(recorder,recordTime);
    clipName = getaudiodata(recorder);
    
    songName = matching(testOption,clipName,hashTable,songNameTable,gs,deltaTL,deltaTU,deltaF);
end