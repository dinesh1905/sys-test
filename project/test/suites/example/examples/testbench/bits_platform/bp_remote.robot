*** Settings ***
Documentation  Connect to BITS-Platform remotely using robotremoteserver
...  use case: rf running on linux machine and BITS-Platform on windows machine/vm

Resource    ${TAF_PATH}/import.resource


*** Test Cases ***
Log BP Version
   [Documentation]  first steps using robotremoteserver
   ${version} =  bits_platform.get version
   Log To Console   ===>${version}
   bits_platform.Rfgenerator Set Parameter    1    frq    99.9

Run generic Keywords
    [Documentation]  check accessiblity of generic testbench keywords
    FOR    ${voltage}    IN RANGE    12.0    13.0    0.01
        Log    ${voltage}
        testbench.power.Measure Current    SUT_Power
        testbench.power.Set Output Voltage    SUT_Power    ${voltage}
    END
