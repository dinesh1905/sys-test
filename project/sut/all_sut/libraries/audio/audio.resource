*** Settings ***
Documentation    Project specific software download keywords
Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/diagnostic/HextoASCII.py


*** Keywords ***
Audio validation
    [Documentation]    This keyword is used to play tone in the target and validate audio
    [Arguments]    ${state}
    ${mFreq}    Set Variable    0
    ${sLevel}    Set Variable    0
    Validate audio media    ${sut.audio.unit1}    ${sut.audio.Channel_2}    ${state}

Validate audio media
    [Documentation]     This interface used to check the audio freq
    [Arguments]    ${sUnit}    ${Channel}    ${Music_state}
    bits_platform.audioinput_restart    1
    Sleep    2s
    IF    '${Music_state}' == 'Play'
        prj.sut.audio: AUDIO_INPUT_SET_LEVEL_FREQ    ${sut.audio.unit1}    ${Channel}    ${sut.audio.initial_level}    ${sut.audio.final_level}    ${sut.audio.initial_freq}    ${sut.audio.final_freq}
        #prj.sut.audio: AUDIO_INPUT_SET_LEVEL_FREQ    ${sut.audio.unit1}    ${Channel}    4    50    100    20000
    ELSE
        prj.sut.audio: AUDIO_INPUT_SET_LEVEL_FREQ    ${sut.audio.unit1}    ${Channel}    ${sut.audio.invalid_initial_level}    ${sut.audio.invalid_final_level}    ${sut.audio.invalid_initial_freq}    ${sut.audio.invalid_final_freq}
    END
    FOR    ${counter}    IN RANGE    0    3
        prj.sut.audio: AUDIO_INPUT_START_LEVEL_FREQ_CHECK    ${sut.audio.unit1}    ${Channel}
        ${back_wait_audio}    ${sChannel}    ${sLevel}    ${sFreq}    prj.sut.audio: AUDIO_INPUT_WAIT_UNTIL_FREQ_REACHED    1    30    sOnlyChannel=${Channel}
        prj.sut.audio: AUDIO_INPUT_STOP_LEVEL_FREQ_CHECK    ${sut.audio.unit1}    ${Channel}
        Sleep    2s
        Exit For Loop If    ${back_wait_audio} == ${True}
    END
    IF    ${back_wait_audio} == ${True}
        log    Split Duration String
        ${parts}=    Split String    ${sFreq}    DURATION
        Log    ${parts}
        ${Freq_Value}=    Get From List    ${parts}    0
        ${Duration_Value}=    Get From List    ${parts}    1
        Log    Frequency value: ${Freq_Value}
        Log    Duration value: ${Duration_Value}
    ELSE
        framework.Set Test Status To Fail    error_type=Audio    info_text= Value returned is : ${back_wait_audio}. Hence no measurement recieved for Audio input
    END
    RETURN    ${back_wait_audio}    ${sLevel}    ${Freq_Value}

prj.sut.audio: AUDIO_INPUT_SET_LEVEL_FREQ
    [Documentation]     This interface used to Set the frequency Level For Audio Recoder
    [Arguments]    ${sUnit}    ${sChannel}    ${sLevelMin}    ${sLevelMax}    ${sFreqMin}    ${sFreqMax}
 
    Log    *******Start:AUDIO_INPUT_SET_LEVEL_FREQ*******    console=yes
    ${bAck}    bits_platform.audioinput_set_level_freq_check    ${sUnit}    ${sChannel}    ${sLevelMin}    ${sLevelMax}    ${sFreqMin}    ${sFreqMax}
    IF    ${bAck} == ${True}
        Log   Audio Input level are set successful  console=yes
    ELSE
        Log    Audio Input level are not set successful    console=yes
        framework.Set Test Status To Fail    error_type=SW_Audio    info_text=Audio Input level are not set successful
    END
    Log    *******End:AUDIO_INPUT_SET_LEVEL_FREQ*******    console=yes
# ***************************************************************************************************
prj.sut.audio: AUDIO_INPUT_START_LEVEL_FREQ_CHECK
    [Documentation]     This interface used to start audio recoder conneccted to channel
    [Arguments]    ${sUnit}    ${sChannel}
 
    Log    *******Start:AUDIO_INPUT_START_LEVEL_FREQ_CHECK*******    console=yes
    ${bAck}    bits_platform.audioinput_start_level_freq_check    ${sUnit}    ${sChannel}

    Log    *******End:AUDIO_INPUT_START_LEVEL_FREQ_CHECK*******    console=yes
# ***************************************************************************************************
prj.sut.audio: AUDIO_INPUT_STOP_LEVEL_FREQ_CHECK
    [Documentation]     This interface used to stop audio recoder  connected to channel
    [Arguments]    ${sUnit}    ${sChannel}
 
    Log    *******Start:AUDIO_INPUT_STOP_LEVEL_FREQ_CHECK*******    console=yes
    ${bAck}    bits_platform.audioinput_stop_level_freq_check    ${sUnit}    ${sChannel}

    Log    *******End:AUDIO_INPUT_STOP_LEVEL_FREQ_CHECK*******    console=yes
# ***************************************************************************************************
prj.sut.audio: AUDIO_INPUT_WAIT_UNTIL_FREQ_REACHED
    [Documentation]     This interface used to wait until  values are reached the expected level
    [Arguments]    ${sUnit}    ${iTimeout}    ${sOnlyChannel}
    Log    *******Start:AUDIO_INPUT_WAIT_UNTIL_FREQ_REACHED*******    console=yes 
    ${bAck}    ${sChannel}    ${sLevel}    ${sFreq}    ${sDuration}    bits_platform.audioinput_wait_until_level_freq_reached    ${sUnit}    ${iTimeout}    ${sOnlyChannel}
    RETURN    ${back}    ${sChannel}    ${sLevel}    ${sFreq}
    Log    *******End:AUDIO_INPUT_WAIT_UNTIL_FREQ_REACHED*******    console=yes
# ***************************************************************************************************
