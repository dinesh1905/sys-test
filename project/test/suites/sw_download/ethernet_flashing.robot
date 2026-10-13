*** Settings ***
Documentation    Running Weekly Build for auto flashing and entry test.

Resource    ${TAF_PATH}/import.resource
Library    OperatingSystem
Library    Process
Library    String
Library    AppiumLibrary
Library    subprocess
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library    ${TAF_PATH}/project/test/suites/sw_download/artifactory.py
Library    ${TAF_PATH}/project/test/suites/sw_download/ethswitch.py
Library    ${TAF_PATH}/project/test/suites/sw_download/interface_handler.py

Metadata    testtype            example
Metadata    testarea            power
Metadata    requirements        no requirements
Metadata    preconditions       no preconditions
Metadata    actions             no actions
Metadata    expectedresults     no expectedresults

# Test Automation Framework
Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Variables ***
${AURIX_VERSION}    ${AURIX_VERSION}
${SOC_VERSION}    ${SOC_VERSION}
${AURIX_URL}    ${AURIX_URL}
${SOC_URL}    ${SOC_URL}
# ${CDT_URL}    ${CDT_URL}
${PCSUTSERIALNUMBERJENKINS}   ${PCSUTSERIALNUMBERJENKINS}
${KDS_FLASH}    ${KDS_FLASH}
${HSM_ENABLE}    ${HSM_ENABLE}


*** Test Cases ***
# Ethernet Flashing
#     # Ethernet Switch Flashing        D:\tmp\SWdownload\MAAS_ETHSWT_25.03.01.01_SEC_PRJ    88Q5152_flash.bin
#     Ethernet Switch Flashing        D:\tmp\SWdownload\MAAS_ETHSWT_25.04.00_SEC_PRJ    88Q5152_flash_devSigned.bin



*** Keywords ***
# Ethernet Switch Flashing
#     [Arguments]    ${binary_dir}    ${binary_file}    ${provision_image}=${False}

#     ${tool_path}=    Set Variable    D:\\tmp\\SWdownload\\MAAS_ETHSWT_25.04.00_SEC_PRJ\\DownloadImage_v2.exe
#     ${binary_path}=    Set Variable    D:\\tmp\\SWdownload\\MAAS_ETHSWT_25.04.00_SEC_PRJ\\88Q5152_flash_devSigned.bin
    
#     # Check with custom messages
#     ${tool_exists}=    Run Keyword And Return Status    File Should Exist    ${tool_path}
#     Run Keyword If    not ${tool_exists}    Fail    Flashing tool not found at: ${tool_path}
    
#     ${binary_exists}=    Run Keyword And Return Status    File Should Exist    ${binary_path}
#     Run Keyword If    not ${binary_exists}    Fail    Binary file not found at: ${binary_path}
    
#     Log    Tool Path: ${tool_path}    console=True
#     Log    Binary Path: ${binary_path}    console=True
    
#     ethswitch.Set Flashing Tool Path    ${tool_path}
#     ethswitch.Set Flashing Port         ethernet
#     ethswitch.Set Flashing Interface    cmdprompt
    
#     Log    Starting flash operation...    console=True
#     ${status}=    ethswitch.Flash Image    ${binary_path}    5
    
#     Log    Flash status returned: ${status}    console=True
    
#     Should Be True    ${status}    Ethernet switch flashing failed

# Ethernet Switch Flashing
#     [Arguments]    ${binary_dir}    ${binary_file}    ${provision_image}=${False}

#     ${tool_path}=    Set Variable    D:\\tmp\\SWdownload\\MAAS_ETHSWT_25.04.00_SEC_PRJ\\DownloadImage_v2.exe
#     ${binary_path}=    Set Variable    D:\\tmp\\SWdownload\\MAAS_ETHSWT_25.04.00_SEC_PRJ\\88Q5152_flash_devSigned.bin
    
#     Log    Setting tool path to: ${tool_path}    console=True
    
#     ethswitch.Set Flashing Tool Path    ${tool_path}
#     ethswitch.Set Flashing Port         ethernet
#     ethswitch.Set Flashing Interface    cmdprompt
    
#     # Add this debug line to see what's stored internally
#     ${stored_path}=    Evaluate    ethswitch.EthSwitch().flashing_exe_path
#     Log    Stored path is: ${stored_path}    console=True
    
#     ${status}=    ethswitch.Flash Image    ${binary_path}    5
    
#     Should Be True    ${status}    Ethernet switch flashing failed

*** Test Cases ***
Ethernet Flashing
    Ethernet Switch Flashing    D:\\tmp\\SWdownload\\MAAS_ETHSWT_25.04.00_SEC_PRJ    88Q5152_flash_devSigned.bin


*** Keywords ***
Ethernet Switch Flashing
    [Arguments]    ${binary_dir}    ${binary_file}    ${provision_image}=${False}
    
    # Build paths from arguments
    ${tool_path}=    Set Variable    ${binary_dir}\\DownloadImage_v2.exe
    ${binary_path}=    Set Variable    ${binary_dir}\\${binary_file}
    
    # Use OperatingSystem library explicitly for local file checks
    OperatingSystem.File Should Exist    ${tool_path}
    OperatingSystem.File Should Exist    ${binary_path}
    
    Log    Tool Path: ${tool_path}    console=True
    Log    Binary Path: ${binary_path}    console=True
    
    # Set flashing configuration
    ethswitch.Set Flashing Tool Path    ${tool_path}
    ethswitch.Set Flashing Port         ethernet
    ethswitch.Set Flashing Interface    cmdprompt
    
    # Perform flashing
    ${status}=    ethswitch.Flash Image    ${binary_path}    5
    
    Log    Flash Status: ${status}    console=True
    Should Be True    ${status}    Ethernet switch flashing failed