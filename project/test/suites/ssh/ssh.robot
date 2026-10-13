*** Settings ***
Documentation    Example script to send ssh command and verify

Resource    ${TAF_PATH}/import.resource
Library    SSHLibrary

Metadata    testtype            example
Metadata    testarea            ssh
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
${host}        192.168.42.1
${username}    root
${password}    root


*** Test Cases ***
SSH Communication
   [Documentation]    to check ssh

   Open Connection   ${host}

   ${output}    Login   ${username}   ${password}

   Execute Command    mkdir TestFolder
   ${output1} =    Execute Command    ls
   # Execute Command    ls -l /home/root/00_Helpers
   ${output1} =    Execute Command    ls -l /home/root/00_Helpers
   # ${output1} =    Execute Command    python3 get-diag

   Log To Console  *************${output1}************
   Close All Connections
