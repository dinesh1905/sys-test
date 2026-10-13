*** Settings ***
Documentation    To check Static Code Analysis
Metadata            project    IDBuzz
Metadata            version_sw    26.1_RC1
Metadata            team-area    MaaS


*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_PowerHandlingVoltageRangeMonitoring

    [Tags]    TCID-19584    POWE    FID-1275380,1275382,1275400,127541    FULLTES

    Log To console    hey reqid and tcid

EnvD_SysQual_PowerManagementSubsystem_PowerHandlingVoltageRangeMonitoring2_logical
    [Documentation]    
    [Tags]    TCID-195846    FID-1275380,1275382,1275407,1275414    FULLTEST    SOC

    Log To console    hey reqid and tcid2

