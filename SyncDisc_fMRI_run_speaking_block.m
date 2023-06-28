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
global screenPointer rect data subject subject_is_odd scanning LH_red_button

%Collect user-specified subject ID for participant
subject = input('Enter Subject ID: ');

%Determine whether subject ID is odd
if mod(subject, 2)==0
    subject_is_odd = 0;
else
    subject_is_odd = 1;
end

%Determine whether scanning or not
scanning = input('Scanning? (0 = no, 1 = yes): ');

%Data info
datafile   = sprintf('output_data/speaking_block/P%d.csv', subject); %Datafile name & directory
datafields = {'subject', 'block', 'recording', 'triggerOT', 'recordingOT', 'recordingET'}; %Data column names (experiment data gets appended at the end of each block)
data       = [];

%Button box DINs
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
if scanning
    Datapixx('Open');
    Datapixx('StopAllSchedules');
    Datapixx('RegWrRd');
    Datapixx('EnableDinDebounce');
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
if scanning
    Datapixx('Close');
end

close all;
clearvars;
sca;
