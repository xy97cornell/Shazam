function table = make_table(songName, gs, deltaTL, deltaTU, deltaF)

Fs = 8000;
resampledSong = resample(songName, Fs, 44100);

lpFilt = designfilt('lowpassfir', 'FilterOrder', 20, 'CutoffFrequency', (8000)/44100);
resampledSong = filter(lpFilt,resampledSong);


window = 64e-3*Fs;
nfft = 64e-3*Fs;
noverlap = 32e-3*Fs;

[S,F,T] = spectrogram(resampledSong,window,noverlap,nfft,Fs);

log_S = log10(abs(S)+1);
% Step 2 Check
% figure
% imagesc(T,F,20*log10(abs(S)))
% axis xy;
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% title('Spectrogram')
% 
% colormap jet
% c= colorbar;
% set(c);
% ylabel(c,'Power (dB)','FontSize',14);

%Feature Extraction
[nr,nc] = size(log_S);
localPeak = (gs^2-1)*ones(nr,nc);

for r = -1*floor(gs/2):floor(gs/2)
    for c = -1*floor(gs/2):floor(gs/2)
    CS = circshift(log_S, [r,c]);
    localPeak = localPeak - ((log_S-CS)>0);
    end
end

localPeak = (localPeak == 0);

%Thresholding

Threshold = 30;

Averages = ceil(Threshold*T(length(T)));

log_SPeaks = localPeak.*log_S;

log_SReshaped = reshape(log_SPeaks,[],1);

[log_Sm, log_SmIndex] = sort(log_SReshaped, 'descend');

localPeakThresh = zeros(nr,nc);
localPeakThresh(log_SmIndex(1:Averages))=localPeak(log_SmIndex(1:Averages));

% Constructing table
fanOut = 3;

f1 = [];
t1 = [];
f2 = [];
t2 = [];
% [r, c] = find(localPeakThresh);
for r = deltaF+1:nr-deltaF
    for c = 1:(nc-deltaTU)
        if localPeakThresh(r,c) == 1
            submatrix = localPeakThresh((r-deltaF):(r+deltaF), (c+deltaTL):(c+deltaTU));
            subIndex = find(submatrix, fanOut);
            if ~(isempty(subIndex))
                [I, J] = ind2sub(size(submatrix), subIndex);
                I = I + r - deltaF;
                J = J + c + deltaTL;
                f2 = [f2; I];
                t2 = [t2; J];
                r1 = r.*ones(length(J),1);
                c1 = c.*ones(length(J),1);
                f1 = [f1; r1];
                t1 = [t1; c1];
                
            end
        end
    end
end
% for x=1:length(r)
%     ri=r(x);
%     ci=c(x);
%     if (ri<=(nr-deltaF))&&(ri>=(deltaF+1))
%         if (ci>=1)&&(ci<=(nc-deltaTU))
%             submatrix = localPeakThresh((ri-deltaF):(ri+deltaF), (ci+deltaTL):(ci+deltaTU));
%             subIndex = find(submatrix, fanOut);
%             if ~(isempty(subIndex))
%                 [I, J] = ind2sub(size(submatrix), subIndex);
%                 I = I + ri - deltaF;
%                 J = J + ci + deltaTL;
%                 f2 = [f2; I];
%                 t2 = [t2; J];
%                 r1 = ri.*ones(length(J),1);
%                 c1 = ci.*ones(length(J),1);
%                 f1 = [f1; r1];
%                 t1 = [t1; c1];
%                 
%             end
%         end
%     end
% end
table = [f1 f2 t1 t2-t1];
end



