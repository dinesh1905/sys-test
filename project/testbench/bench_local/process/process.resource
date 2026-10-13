*** Settings ***
Documentation    Project specific software download keywords
Resource    ${TAF_PATH}/import.resource


*** Keywords ***
Close DLT
    [Documentation]  To close DLT Viewer Program
    ${rc_code}    ${output}    Run And Return Rc And Output    taskkill /IM ${testbench.process.DLT_IM} /F /T
    IF    '${rc_code}' == '0'
          Log To Console    DLT Program is successfully closed
    ELSE IF    '${rc_code}' == '128'
          Log To Console    DLT is already Closed
    ELSE
          Log to Console    There was error during termination of DLT
    END

Close Putty
    [Documentation]  To close Putty Program
    ${rc_code}    ${output}    Run And Return Rc And Output    taskkill /IM ${testbench.process.Putty_IM} /F /T
    IF    '${rc_code}' == '0'
          Log To Console    Putty Program is successfully closed
    ELSE IF    '${rc_code}' == '128'
          Log To Console    Putty is already Closed
    ELSE
          Log to Console    There was error during termination of Putty
    END


Close FlashGUI
    [Documentation]  To close FlashGUI Program
    ${rc_code}    ${output}    Run And Return Rc And Output    taskkill /IM ${testbench.process.FlashGUI_IM} /F /T
    IF    '${rc_code}' == '0'
          Log To Console    FlashGUI Program is successfully closed
    ELSE IF    '${rc_code}' == '128'
          Log To Console    FlashGUI is already Closed
    ELSE
          Log to Console    There was error during termination of FlashGUI
    END

Close DebugBoard RemoteControl
    [Documentation]  To close DebugBoard RemoteControl Program
    ${rc_code}    ${output}    Run And Return Rc And Output    taskkill /IM ${testbench.process.DebugRemote_IM} /F /T
    IF    '${rc_code}' == '0'
          Log To Console    DebugBoard RemoteControl Program is successfully closed
    ELSE IF    '${rc_code}' == '128'
          Log To Console    DebugBoard RemoteControl is already Closed
    ELSE
          Log to Console    There was error during termination of DebugBoard RemoteControl
    END
