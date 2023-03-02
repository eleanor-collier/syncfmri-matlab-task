%SyncDisc fMRI speaking block master script
%Eleanor Collier
%9/20/2022

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DESCRIPTION
%This script takes subject number as an input, and determines speaking order based on whether 
%subject is even or odd. Each block is contained in a separate script as its own function, 
%which gets called by this master script.

%DETAILS ABOUT THE BLOCK FUNCTIONS:
%instructs:     Displays instructions on screen. All instruction text is
%               contained in the instructs_for_speaking.m script
%practice:      Guides participant through sharing practice story
%speak:         Guides participant through sharing stories in the order
%               determined by the participant's ID

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Clear existing variables & screens
clear all;
sca;

%Global variables
global screenPointer rect data subject group inputDevice trigger LH_red_button

%Determine group number from user-specified subject ID (1 for odd subjects, 2 for even subjects)
subject = input('Enter Subject ID: ');
if mod(subject, 2)==0
    group = 2;
else
    group = 1;
end

%Determine device (keyboard or button box) from user-specified device ID
deviceID = input('Enter Device Type (0 = keyboard, 1 = button box): ');
if deviceID     == 0
    inputDevice = 'keyboard';
elseif deviceID == 1
    inputDevice = 'buttonbox';
end

%Data info
datafile   = sprintf('output_data/speaking_block/P%d.csv', subject); %Datafile name & directory
datafields = {'subject', 'group', 'block', 'recording', 'triggerOT', 'recordingOT', 'recordingET'}; %Data column names (experiment data gets appended at the end of each block)
data       = [];

%Button box/scanner trigger DINs
trigger       = 11;
LH_red_button = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET UP
% Clear workspace & screen
close all;
sca;

%Set screen defaults
Screen('Preference', 'SkipSyncTests', 1);
%Screen('Preference', 'DefaultFontName', 'Avenir Book');
Screen('Preference', 'DefaultFontName', 'Helvetica');
Screen('Preference', 'DefaultFontSize', 70);
screens      = Screen('Screens');
screenNumber = max(screens);
white        = WhiteIndex(screenNumber);
black        = BlackIndex(screenNumber);
PsychDefaultSetup(2);

%Hide cursor
HideCursor();

%Display black screen
[screenPointer, rect] = Screen('OpenWindow', screenNumber, black);

%Initialize audio driver
% InitializePsychSound;

%Open Datapixx
if strcmp(inputDevice, 'buttonbox')
    Datapixx('Open');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN EXPERIMENT

%Run blocks
instructs_for_speaking(1);
speak_practice();
instructs_for_speaking(2);
speak();
instructs_for_speaking(3);

%Save data
datatable = cell2table(data, 'VariableNames', datafields);
writetable(datatable, datafile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLOSE EVERYTHING & CLEAN UP
%Close Datapixx
if strcmp(inputDevice, 'buttonbox')
    Datapixx('Close');
end

close all;
clearvars;
sca;
