function [pahandle] = playAudio(audiofile)

%This function plays a specified audiofilefile on a specified screen and returns the audio start and end time. 
%The name of a recording skip key can also be specified; [] will allow all keys to be skip keys. If inputDevice 
%is set to 'buttonbox,' the function will wait for a scan trigger from a specified port to start the audio. 

%Read WAV file from filesystem:
[y, freq] = psychwavread(audiofile);
wavedata = y';
nrchannels = size(wavedata,1); % Number of rows == number of channels.

% Make sure we have always 2 channels stereo output.
% Why? Because some low-end and embedded soundcards
% only support 2 channels, not 1 channel, and we want
% to be robust in our demos.
if nrchannels < 2
    wavedata = [wavedata ; wavedata];
    nrchannels = 2;
end

%Open sound buffer
pahandle = PsychPortAudio('Open', [], [], 2, freq, nrchannels);

%Fill the audio playback buffer with the audio data 'wavedata':
PsychPortAudio('FillBuffer', pahandle, wavedata);

end

