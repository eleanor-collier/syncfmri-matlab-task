function [pahandle] = bufferRecording(device)

% Check device
if nargin < 1
    device = [];
end

% Perform basic initialization of the sound driver:
% InitializePsychSound;

% Open audio device 'device', with mode 2 (== Only audio capture),
% and a required latencyclass of 1 == low-latency mode, with the preferred
% default sampling frequency of the audio device, and 2 sound channels
% for stereo capture. This returns a handle to the audio device:
pahandle = PsychPortAudio('Open', device, 2, 1, [], 2);

% Preallocate an internal audio recording  buffer with a capacity of 10 seconds:
PsychPortAudio('GetAudioData', pahandle, 10);

end

