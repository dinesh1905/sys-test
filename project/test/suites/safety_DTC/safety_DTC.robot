*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library     ${TAF_PATH}/generic/framework/testcase_iterator.py
Library     QConnectBase.ConnectionManager

Metadata    testtype            functional test
Metadata    testarea            sw_flashing
Metadata    requirements        no requirements
Metadata    preconditions       no preconditions
Metadata    actions             flashing SOC sail and Main
Metadata    expectedresults     sw flashing should pass with return value

# Test Automation Framework
Suite Setup      run keywords    setups.Set Up Test Suite
Suite Teardown   run keywords    teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Test Cases ***
# Tower 3 Safety DTC

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_NVMConfiguration(NVMCER)InjectionPFlash0
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST8→ NVM Configuration (NVMCER) Injection PFlash0
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371315    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    10s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST08}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    Sleep    3s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashConfigurationError_Resp}

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_NVMConfiguration(NVMCER)InjectionPFlash1
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST20→ NVMConfiguration (NVMCER) Injection PFlash1
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371316    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST20}
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashConfigurationError_Resp}

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_ECCErrorInjectionPFlash0
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST0 → ECC Error Injection PFlash0
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371317    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST00}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashECCFailure_Resp}

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_ECCErrorInjectionPFlash1
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST12 → ECC Error Injection PFlash1
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371314    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST12}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashECCFailure_Resp}

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_EDCErrorInjectionPFlash0
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST1 → EDC Error Injection PFlash0
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371311    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST01}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_EDCErrorOverPflash_Resp}

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_EDCErrorInjectionPFlash1
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST13 → EDC Error Injection PFlash1
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371312    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST01}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_EDCErrorOverPflash_Resp}

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_InjectingPFlash0READPathError
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST11→ Injecting PFlash0 READ Path error
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371625    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST11}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashReadPathError_Resp}

# EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_InjectingPFlash1READPathError
#     [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST23→ Injecting PFlash1 READ Path error
#     ...     to trigger PFlash error and DTC
#     [Tags]    FULLTEST    CustomerDiagnostic    TCID-371626    FID-2869055
#     # Clear DTC command
#     prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
#     Sleep    3s
#     prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

#     prj.sut.safety.wakeup
#     prj.sut.safety.setUTFmode
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST23}
#     Sleep    10s
#     prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
#     prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashReadPathError_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVDDPDPin
    [Documentation]    To perform FIT_IVM_VDDPD_OV → Passing overvoltage to VDDPD pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371313    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDPD_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVDDPDPin
    [Documentation]    To perform FIT_IVM_VDDPD_UV → Passing undervoltage to VDDPD pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371322    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDPD_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVDDMPin
    [Documentation]    To perform FIT_IVM_VDDM_OV → Passing overvoltage to VDDM pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371323    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDM_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVDDMPin
    [Documentation]    To perform FIT_IVM_VDDM_UV → Passing undervoltage to VDDM pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371324    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDM_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVEVRSBPin
    [Documentation]    To perform FIT_IVM_VEVRSB_OV → Passing overvoltage to VEVRSB pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371321    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEVRSB_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVEVRSBPin
    [Documentation]    To perform FIT_IVM_VEVRSB_UV → Passing undervoltage to VEVRSB pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371318    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEVRSB_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVDDPin
    [Documentation]    To perform FIT_IVM_VDD_OV → Passing overvoltage to VDD pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371319    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDD_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVDDPin
    [Documentation]    To perform FIT_IVM_VDD_UV → Passing undervoltage to VDD pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371320    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDD_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVDDP3Pin
    [Documentation]    To perform FIT_IVM_VDDP3_OV → Passing overvoltage to VDDP3 pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371310    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDP3_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVDDP3Pin
    [Documentation]    To perform FIT_IVM_VDDP3_UV → Passing undervoltage to VDDP3 pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371304    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDP3_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVEXTPin
    [Documentation]    To perform FIT_IVM_VEXT_OV → Passing overvoltage to VEXT pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371624    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEXT_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVEXTPin
    [Documentation]    To perform FIT_IVM_VEXT_UV → Passing undervoltage to VEXT pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371623    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEXT_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_BackupClockAliveAlarm
    [Documentation]    To perform FIT_CLKM_BACKUP_MONTST_TC_E → Backup Clock Alive Alarm
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371306    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.BACKUP_MONTST_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_BackupClockFailure_Resp}

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_BackupClockOutOfRangeAlarmHighFreq
    [Documentation]    To perform FIT_CLKM_OSCBACK_HIGFREQ_TC_E → Back-up clock out-of-range alarm
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371308    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCBACK_HIGFREQ_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_BackupClockFailure_Resp}

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_BackupClockOutOfRangeAlarmLowFreq
    [Documentation]    To perform FIT_CLKM_OSCMAIN_LOWFREQ_TC_E → Back-up clock out-of-range alarm
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371305    FID-2873328
    # # Clear DTC command
    # prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    # Sleep    3s
    # prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCBACK_LOWFREQ_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_BackupClockFailure_Resp}

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_OSCClockFrequencyOutOfRangeHighFreq
    [Documentation]    To perform FIT_CLKM_OSCMAIN_HIGFREQ_TC_E → OSC clock frequency out of range
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371307    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt.safety
    # prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCMAIN_HIGFREQ_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OSCClockFailure_Resp}

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_OSCClockFrequencyOutOfRangeLowFreq
    [Documentation]    To perform FIT_CLKM_OSCMAIN_LOWFREQ_TC_E → OSC clock frequency out of range
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371309    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt.safety
    # prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCMAIN_LOWFREQ_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OSCClockFailure_Resp}

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_PeripheralPLLDCOLossOfLockEvent
    [Documentation]    To perform FIT_CLKM_PERPLL0_LOSSOFLOCK_TC_E→ Peripheral PLL DCO loss of lock event
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371303    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt.safety
    # prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PERPLL0_LOSSOFLOCK_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PLLLossOfLockFailure_Resp}
