%SyncDisc fMRI listening block master script
%Eleanor Collier
%9/20/2022

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DESCRIPTION
%This script takes subject number and partner subject number as an input, and determines listening order 
%based on whether subject is even or odd. Each block is contained in a separate script as its own function, 
%which gets called by this master script.

%DETAILS ABOUT THE BLOCK FUNCTIONS:
%instructs:     Displays instructions on screen. All instruction text is
%               contained in the instructs_for_listening.m script
%listen:        Plays study partner's audio recordings in the order
%               determined by the study partner's ID

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Clear existing variables & screens
clear all;
sca;

%Global variables
global screenPointer rect data subject partner group inputDevice trigger LH_red_button

%Determine group number from user-specified subject ID (1 for odd subjects, 2 for even subjects)
subject = input('Enter Subject ID: ');
if mod(subject, 2)==0
    group = 2;
else
    group = 1;
end

%Collect user-specified subject ID for study partner
partner = input('Enter Study Partner ID: ');

%Determine device (keyboard or button box) from user-specified device ID
deviceID = input('Enter Device Type (0 = keyboard, 1 = button box): ');
if deviceID     == 0
    inputDevice = 'keyboard';
elseif deviceID == 1
    inputDevice = 'buttonbox';
end

%Data info
datafile = sprintf('output_data/listening_block/P%d.csv', subject); %Datafile name & directory
data     = {'subject' 'group' 'block' 'recording' 'triggerOT' 'recordingOT' 'recordingET'}; %Data column names (experiment data gets appended at the end of each block)

%Button box/scanner trigger DINs
trigger       = 9;
LH_red_button = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET UP
% Clear workspace & screen
close all;
sca;

%Set screen defaults
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'DefaultFontName', 'Avenir Book');
Screen('Preference', 'DefaultFontSize', 70);
screens      = Screen('Screens');
% screenNumber = 0;
screenNumber = max(screens);
white        = WhiteIndex(screenNumber);
black        = BlackIndex(screenNumber);
PsychDefaultSetup(2);

%Hide cursor
HideCursor();

%Display black screen
[screenPointer, rect] = Screen('OpenWindow', screenNumber, black);

%Initialize audio driver
InitializePsychSound;

%Open Datapixx
if strcmp(inputDevice, 'buttonbox')
    Datapixx('Open');
%     Datapixx('StopAllSchedules'); % stop any current schedule comment out
%     Datapixx('RegWrRd'); % write local register, need prior to DataPixx read/write command comment out
%     Datapixx('EnableDinDebounce'); % filer out button bounce within 30 ms. comment out
%     Datapixx('SetDinLog');
%     Datapixx('StartDinLog');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN EXPERIMENT

%Experiment blocks
% instructs_for_listening(1);
listen();
instructs_for_listening(2);

%Save data
writematrix(data, datafile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLOSE EVERYTHING & CLEAN UP
%Close Datapixx
if strcmp(inputDevice, 'buttonbox')
    Datapixx('Close');
end

close all;
clearvars;
sca;



