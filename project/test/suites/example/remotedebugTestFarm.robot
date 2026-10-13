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
Remotedebug_testfarm
   [Documentation]    Debug board
   ${ack}    ${result}    bits_platform.System Get Connect State Device    Gen5_DebugBoard_1
   Log To Console    The Debug board is : ${result}
   IF    "${result}" == "DISCONNECT"
       Log To Console    THe interface one is free to use. you can connect
       bits_platform.System Connect Device    Gen5_DebugBoard_1
       Sleep    15s
      #  bits_platform.System Disconnect Device    Gen5_DebugBoard_1
      #  Sleep    2s
      #  bits_platform.System Connect Device    Gen5_DebugBoard_1
      #  Sleep    15s
       bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
       # SYSTEM Gen5_DebugBoard_1 DEVICE SET COMMAND_  SET REMOTEMODE=ON
       Sleep    2s
       bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC Control
       Sleep    2s
       bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=DSP/AVB-C Control
       Sleep    2s
       bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=CPU Control

       bits_platform.output set digital signal value    H1000    1

       # Use Gen-5.6 to toggle H1005 to ON
       bits_platform.output set digital signal value    H1005    1

       # Use Gen-5.6 to toggle H1007 to ON
       bits_platform.output set digital signal value    H1007    1

       # Use Gen-5.6 to toggle H1008 to ON
       bits_platform.output set digital signal value    H1008    1

       # Use Gen-5.6 to toggle CPU_PWR to ON
        bits_platform.output set digital signal value    CPU_PWR    1

   ELSE
       Log To Console    THe interface 1 is occupied. Use interface 2
       ${ack}    ${result}    bits_platform.System Get Connect State Device    Gen5_DebugBoard_2
       IF    "${result}" == "DISCONNECT"
            Log To Console    Interface 2 is free you can connect.
            bits_platform.System Connect Device    Gen5_DebugBoard_2
            Sleep    15s
            bits_platform.System Send Command    Gen5_DebugBoard_2    SET REMOTEMODE=ON
            Sleep    2s
            bits_platform.System Send Command    Gen5_DebugBoard_2    SET CONTROL=SCC Control
            Sleep    2s
            bits_platform.System Send Command    Gen5_DebugBoard_2    SET CONTROL=DSP/AVB-C Control
            Sleep    2s
            bits_platform.System Send Command    Gen5_DebugBoard_2    SET CONTROL=CPU Control

            bits_platform.output set digital signal value    H1000    1

            # Use Gen-5.6 to toggle H1005 to ON
            bits_platform.output set digital signal value    H1005    1

            # Use Gen-5.6 to toggle H1007 to ON
            bits_platform.output set digital signal value    H1007    1

            # Use Gen-5.6 to toggle H1008 to ON
            bits_platform.output set digital signal value    H1008    1

            # Use Gen-5.6 to toggle CPU_PWR to ON
            bits_platform.output set digital signal value    CPU_PWR    1
       ELSE
            Log To Console    Interface 2 is in use. You have no more interface to connect
       END
   END


   ${ack}    ${result}    bits_platform.System Get Connect State Device    Gen5_DebugBoard_1
   Log To Console    The Debug board is : ${result}
   IF    "${result}" == "DISCONNECT"
       Log To Console    THe interface one is free to use. you can connect
       bits_platform.System Connect Device    Gen5_DebugBoard_1
       Sleep    15s
      #  bits_platform.System Disconnect Device    Gen5_DebugBoard_1
      #  Sleep    2s
      #  bits_platform.System Connect Device    Gen5_DebugBoard_1
      #  Sleep    15s
       bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
       # SYSTEM Gen5_DebugBoard_1 DEVICE SET COMMAND_  SET REMOTEMODE=ON
       Sleep    2s
       bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC Control
       Sleep    2s
       bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=DSP/AVB-C Control
       Sleep    2s
       bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=CPU Control

   ELSE
       Log To Console    THe interface 1 is occupied. Use interface 2
       ${ack}    ${result}    bits_platform.System Get Connect State Device    Gen5_DebugBoard_2
       IF    "${result}" == "DISCONNECT"
            Log To Console    Interface 2 is free you can connect.
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
            Log To Console    Interface 2 is in use. You have no more interface to connect
       END
   END
