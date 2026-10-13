*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library    ${TAF_PATH}/project/framework/log2rqm.py
Library    AppiumLibrary


Metadata    testtype            functional test
Metadata    testarea            sw_flashing
Metadata    requirements        no requirements
Metadata    preconditions       no preconditions
Metadata    actions             flashing SOC sail and Main
Metadata    expectedresults     sw flashing should pass with return value

# Test Automation Framework
Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Test Cases ***
Auto Flashing
    [Documentation]    Debug board

   ${ack}    ${result}    bits_platform.System Get Connect State Device    Gen5_DebugBoard_1
   Log To Console    The Debug board is : ${result}
   IF    "${result}" == "DISCONNECT"
      bits_platform.System Connect Device    Gen5_DebugBoard_1
      Sleep    5s
      bits_platform.System Disconnect Device    Gen5_DebugBoard_1
      Sleep    5s
      bits_platform.System Connect Device    Gen5_DebugBoard_1
      Sleep    5s
      bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
      Sleep    2s
      bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC Control
      Sleep    2s
      bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=DSP/AVB-C Control
      Sleep    2s
      bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=CPU Control

   ELSE
      Log To Console    Connected.
   END

   ${ack}    ${result}    bits_platform.System Get Connect State Device    Gen5_DebugBoard_2
   Log To Console    The Debug board is : ${result}
   IF    "${result}" == "DISCONNECT"
      bits_platform.System Disconnect Device    Gen5_DebugBoard_1
      Sleep    2s
      bits_platform.System Connect Device    Gen5_DebugBoard_2
      Sleep    15s
      bits_platform.System Send Command    Gen5_DebugBoard_2    SET REMOTEMODE=ON
      Sleep    2s
      bits_platform.System Send Command    Gen5_DebugBoard_2    SET CONTROL=SCC Control
      Sleep    2s
      bits_platform.System Send Command    Gen5_DebugBoard_2    SET CONTROL=DSP/AVB-C Control
      Sleep    2s
      bits_platform.System Send Command    Gen5_DebugBoard_2    SET CONTROL=CPU Control

   ELSE
      Log To Console    Connected

   END

TEST1

    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_EXIT
    # bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_CLOSE