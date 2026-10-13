*** Settings ***
Documentation       script to deal with memory module
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource            ${TAF_PATH}/import.resource
Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         setups.Set Up Test Suite
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Variables ***
${AURIX_VERSION}    ${AURIX_VERSION}
${SOC_VERSION}    ${SOC_VERSION}
${UFS_INQUIRY_ID}    KLUFGAUHYB-B0EQ


*** Test Cases ***
EnvD_SysQual_MemorySubsystem_VolatileMemoryRequirement_SafeShutdownSoCTypicallyConcernOnLPDDR5RAMSuddenPowerLosstoSoC   #newchange
    [Documentation]    Check SCC Traces while power off 9 times
    [Tags]    MEMORY    FULLTEST    FID-2203140    TCID-332372
    prj.sut.power cycle
    FOR    ${INDEX}    IN RANGE    9
        prj.sut.connect.dlt
        Sleep    5s
        bits_platform.Output Set Analog Signal Value    Ignition    0
        bits_platform.Output Set Analog Signal Value    Battery    0
        Sleep    5s
        bits_platform.Output Set Analog Signal Value    Ignition    12
        bits_platform.Output Set Analog Signal Value    Battery    12
        Log To Console    Traces in SCC console(DTL)
        Sleep    5s
        Verify DLT keyword offline    [PowerM]  SendCanSignal
        bits_platform.Output Set Analog Signal Value    Ignition    0
        bits_platform.Output Set Analog Signal Value    Battery    0
        prj.sut.clear.logs.dlt
        Sleep    5s
        ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    [PowerM]
        Log To Console    The status of verified step is "${Status}"
        IF    ${Status} == ${TRUE}
            Log To Console    Trace is still loggining after power off
            framework.Set Test Status To Fail    error_type=MEMORY
        ELSE
            Log To Console    No Trace observed after power off
        END
        prj.sut.disconnect.dlt
    END

EnvD_SysQual_MemorySubsystem_UFSUniversalFlashStorage12.4_PowerFailSafe_CriticalUnderVoltage
    [Documentation]    Check critical and undervoltage range with startup trace
    [Tags]    MEMORY    FULLTEST    FID-1039577    TCID-371649

    prj.sut.connect.dlt
    prj.sut.connect.QNX
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Sleep    100s
    # Verify DLT keyword offline    [PowerM] GssPowerUp SwitchOnPowerRail
    # Verify DLT keyword offline    [PowerM] GssPowerUp CPU Activated
    # Verify DLT keyword offline    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
    # Verify DLT keyword offline    [PowerM] SendCanSignal [RUN_ACK]
    # Verify QNX keyword offline    Startup done
    prj.sut.power.add.voltage.to.dictionary.check    Battery    6    
    Verify DLT keyword offline    ${sut.power.DLT.critical_undervoltage}
    prj.sut.disconnect.qnx
    prj.sut.connect.QNX
    prj.sut.power.add.voltage.to.dictionary.check    Battery    12    
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}
    Sleep    100s
    Verify QNX keyword offline    Startup done
    Sleep    10s
    Verify QNX keyword offline    VERSION=    command= cat /mnt/Buildinfo.txt
    prj.sut.disconnect.dlt
    prj.sut.disconnect.qnx

EnvD_SysQual_MemorySubsystem_SystemRequirement_SOC-ETH-Flashing
    [Documentation]    Check Ethernet flashing is correct
    [Tags]    MEMORY    FULLTEST    FID-1039408, 1039412    TCID-404514
    prj.sut.connect.dlt
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Sleep    20s
    Verify DLT keyword offline    EthSwtFwversion:  25.04.00
    prj.sut.disconnect.dlt
