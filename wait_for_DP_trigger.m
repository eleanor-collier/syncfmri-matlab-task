function [Bpress RespTime TheButtons bin_buttonpress inter_buttonpress] = WaitForEvent_Jerry_trigger(responseduration,TargList,starttime)
%TargList;  red=1, yellow=2, green=3, blue=4, trigger=11

dinRed      = hex2dec('1');
dinYellow   = hex2dec('2');
dinGreen    = hex2dec('4');
dinBlue     = hex2dec('8');
mri_trigger = hex2dec('400');

Bpress=0;
timestamp=-1;
TheButtons=-1;
inter_buttonpress{1}=[]; % added by Jason because matlab was throwing and error 
                         % saying that inter_buttonpress was not assigned. 
                         % 26 June 2018
RespTime= [];
binaryvals=[];
bin_buttonpress{1}=[]; % Jerry:use array instead of cell
inter_timestamp{1}=[]; % JERRY: NEVER USED, DO NOT UNDERSTAND WHAT IT STANDS FOR
                         
Datapixx('RegWrRd');
buttonLogStatus = Datapixx('GetDinStatus');

if buttonLogStatus.logRunning~=1;
         Datapixx('SetDinLog'); %added by Jerry
         Datapixx('StartDinLog');
         Datapixx('RegWrRd');
         buttonLogStatus = Datapixx('GetDinStatus');
         Datapixx('RegWrRd');
end
if ~exist('starttime','var') % var added by Jason 
    starttime=Datapixx('GetTime');
elseif  isempty(starttime)  % modified by Jerry from else to elseif
    starttime=Datapixx('GetTime');
end

%counter=0;
while ( (Datapixx('GetTime') < (starttime + responseduration) ) && ~Bpress)
    if (buttonLogStatus.newLogFrames > 0)
        [buttonpress timestamp] = Datapixx('ReadDinLog');
        for counter=1: buttonLogStatus.newLogFrames
            binaryvals=dec2bin(buttonpress(counter)); %convert triggers to binary values Jerry : should use (counter) index
            binaryvals=binaryvals(end:-1:1); %reorder to left to right
            inter_buttonpress{counter}=buttonpress(counter); %actual output : bits order: "Right to Left"
            bin_buttonpress{counter}=binaryvals; %saved output: bits order : "Left to Right"
            inter_timestamp{counter}=timestamp;
            %if (bitand(buttonpress(counter),dinRed+dinYellow+dinGreen+dinBlue+mri_trigger) ~=0) && any(str2num(binaryvals(TargList)))
            if ((mri_trigger) ~=0) && any(str2num(binaryvals(TargList)))
                Bpress=1;
                TheButtons=find(binaryvals(TargList)=='1');
                RespTime=timestamp(counter)-starttime;       
            end    
        end % for counter
    end
    Datapixx('RegWrRd');
    buttonLogStatus = Datapixx('GetDinStatus');
%   initialValues = Datapixx('GetDinValues')
    WaitSecs(.002); % avoids tight loop Jerry: DO NOT understand
end
Datapixx('StopDinLog');
