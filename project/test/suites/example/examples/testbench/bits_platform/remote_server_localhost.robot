*** Settings ***
Documentation  Connect to BITS-Platform remotely using robotremoteserver
...  use case: rf running on linux machine and BITS-Platform on windows machine/vm

Library       Remote    http://${ADDRESS}:${PORT}  AS  bits_platform
Library       Collections


*** Variables ***
${ADDRESS}    127.0.0.1
${PORT}       8271


*** Test Cases ***
Log BP Version
   [Documentation]  first steps using robotremoteserver
   ${version} =  bits_platform.get version
   Log To Console   \n===>${version}
   bits_platform.Rfgenerator Set Parameter    1    frq    99.9
   ${value} =  bits_platform.Input Get Signal Value    Battery_Current
   Log to console  \n===> ${value}
