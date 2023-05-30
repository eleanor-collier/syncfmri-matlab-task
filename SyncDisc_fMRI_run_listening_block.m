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
%listen:        Plays speaker's audio recordings in the order
%               determined by the speaker's ID

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET VARIABLES
%Clear existing variables & screens
clear all;
sca;

%Global variables
global screenPointer rect data subject session_ID speaker speaker_name speaker_is_odd scanning LH_red_button

%Collect user-specified session number
session_ID = input('Enter Session Number: '); % Make sure it doesn't override data

%Collect user-specified subject ID for participant
subject = input('Enter Subject ID: ');

%Collect user-specified subject ID for speaker
speaker = input('Enter Speaker ID: ');

%Determine whether speaker ID is odd
if mod(speaker, 2)==0
    speaker_is_odd = 0;
else
    speaker_is_odd = 1;
end

%Collect user-specified name of speaker
speaker_name = input('Enter First Name of Speaker: ');

%Determine whether scanning or not
scanning = input('Scanning? (0 = no, 1 = yes): ');

%Data info
datafile   = sprintf('output_data/listening_block/P%d_session%d.csv', subject, session_ID); %Datafile name & directory
datafields = {'ID' 'session_ID' 'speaker_ID' 'speaker_name' 'block' 'recording' 'triggerOT' 'recordingOT' 'recordingET'}; %Data column names (experiment data gets appended at the end of each block)
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
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN EXPERIMENT

%Experiment blocks
instructs_for_listening(1);
listen();
instructs_for_listening(2);
rest();
instructs_for_listening(3);
do_math();
instructs_for_listening(4);

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



