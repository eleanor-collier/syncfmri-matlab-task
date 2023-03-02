function [RespTime] = wait_for_DP_trigger()

% Wait for datapixx trigger: modified code from Jason

mri_trigger = hex2dec('400');
trigger_detected = 0;

while ~trigger_detected
    Datapixx('RegWrRd');
    initialValues = Datapixx('GetDinValues');
    % We compare the value with the digital inputs and the mri_trigger.
    trigger_detected = (bitand(initialValues, mri_trigger) == mri_trigger );
    if trigger_detected
        break;
    end
end

end

