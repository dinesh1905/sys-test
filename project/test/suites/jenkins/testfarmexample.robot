*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource

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

Library    Dialogs
Library    SSHLibrary

*** Variables ***
${jenkinsip}    ${DUT_ID}
${host}        192.168.42.1
${username}    root
${password}    root

*** Test Cases ***
TestFarm Example
    [Documentation]    Choosing a hardware to test
    Log To Console    HI
    Log To Console    ${jenkinsip}
    IF    "${jenkinsip}" == "0123456789ABCDEF"
        log to console    connection available
        Open Connection   ${host}
        ${output}=    Login   ${username}   ${password}
        ${version}    Execute Command    cat /etc/topas/version_info.cfg
        Log To Console    ${Version}

    ELSE
        log to console    connected to 172.21.0.30
        ${Output}=    Open Connection    ${sut.ssh.SSH_DeviceHost}    prompt=#
        Login    ${sut.ssh.SSH_Username}   ${sut.ssh.SSH_Password}    ${True}
        SSHLibrary.File Should Exist    ${sut.ssh.DeviceSwVersionPath}
        SSHLibrary.Get File 	${sut.ssh.DeviceSwVersionPath} 	${sut.ssh.LocalSwVersionPath}
        ${SW}=    operatingsystem.Get File  	${sut.ssh.LocalSwVersionPath}
        Log To Console    ${SW}
        Should Contain    ${SW}    ${sut.ssh.MaaS_SWVersion}
    END
