function bufferAudio_DP(audiofile)

%This function plays a specified audiofilefile on a specified screen and returns the audio start and end time. 
%The name of a recording skip key can also be specified; [] will allow all keys to be skip keys. If inputDevice 
%is set to 'buttonbox,' the function will wait for a scan trigger from a specified port to start the audio. 

%Initialize audio and stop any schedules which might already be running
Datapixx('StopAllSchedules');
Datapixx('InitAudio');
Datapixx('SetAudioVolume', [1,1]);    % Not too loud
Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache

%Read WAV file from filesystem:
[y, freq] = audioread(audiofile);
wavedata = y';
nrchannels = size(wavedata,1); % Number of rows == number of channels.
nTotalFrames = size(wavedata, 2);

% Download the entire waveform to address 0.
Datapixx('WriteAudioBuffer', wavedata, 0);

% If the .wav file has a single channel, it will play to both ears in mono mode,
% otherwise it will play in stereo mode.
if (nrchannels == 1)
    lrMode = 0;
else
    lrMode = 3;
end

% Configure Datapixx to play the buffer at the correct frequency
Datapixx('SetAudioSchedule', 0, freq, nTotalFrames, lrMode, 0, nTotalFrames);
Datapixx('RegWrRd'); %push these onto the hardware

end

