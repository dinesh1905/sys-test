*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_secureboot.py
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
 ...    Debug Aurix Flashing    prj.sut.safety.precondition    prj.sut.disconnect.dlt
Suite Teardown   run keywords    teardowns.Tear Down Test Suite
 ...    prj.sut.safety.postcondition    Normal Aurix Flashing
Test Setup       setups.Set Up Test Case
Test Teardown    run keywords    teardowns.Tear Down Test Case    Sleep.10s

# Suite Setup      run keywords    setups.Set Up Test Suite
# ...    prj.sut.safety.precondition    prj.sut.disconnect.dlt
# Suite Teardown   run keywords    teardowns.Tear Down Test Suite
# ...    prj.sut.safety.postcondition
# Test Setup       setups.Set Up Test Case
# Test Teardown    run keywords    teardowns.Tear Down Test Case    Sleep.10s

*** Variables ***
${AURIXDEBUG_VERSION}    ${AURIXDEBUG_VERSION}
${AURIXDEBUG_URL}    ${AURIXDEBUG_URL}
${KDS_FLASH}    ${KDS_FLASH}
${SAIL_VERSION}    ${SAIL_VERSION}
${PI_Release}    ${PI_Release}

*** Test Cases ***
EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-PERIPROT-CONVCTRL-ASILTEST00
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the DMA peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332349

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_DMA_P1_ASILTEST01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-DMA-P1-ASILTEST01
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the DMA peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332350
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_DMA_P1_ASILTEST01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-DOM0-ASILTEST02
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the DOM0 peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332347
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_DOM0_ASILTEST02}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-EVADC-ASILTEST03
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the EVADC peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332348

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_EVADC_ASILTEST03}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-P33-DUMMY-ASILTEST04
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting Fault in the P33 peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332353
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_P33_DUMMY_ASILTEST04}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-MTU-ASILTEST05
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the MTU peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332354
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_MTU_ASILTEST05}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-PMS-ASILTEST06
    [Documentation]    "This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the PMS peripheral register"
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332351
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_PMS_ASILTEST06}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-SBCU-ASILTEST07
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the SBCU peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332352
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_SBCU_ASILTEST07}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-SCU-P0-ASILTEST08
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the SCU peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332346
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_SCU_P0_ASILTEST08}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-SMU-ASILTEST09
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the SMU peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332340
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_SMU_ASILTEST09}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-STM0-ASILTEST10
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the STM peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332341
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_STM0_ASILTEST10}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-FCE-ASILTEST011
    [Documentation]    "This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Injecting fault in the FCE peripheral register"
    [Tags]    SAFETY    FULLTEST    FID-1399960,1399964,1399977,1399979,1399980,1399981    TCID-332338
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_PERIPROT_FCE_ASILTEST011}
    prj.sut.power cycle
    Sleep    10s

# EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_WDG-SCPU-INVALIDPASSWORD-TEST06
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for MON
#     ...    Injecting fault to access Endinit protected register with wrong password
#     [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061
#     prj.sut.safety.wakeup
#     prj.sut.safety.setUTFmode
#    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_SCPU_INVALIDPASSWORD_TEST}

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-CONVCTRL-QMTEST01
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for MON
    ...    Injecting fault in the CONVCTRL peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332339
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_CONVCTRL_QMTEST01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-DMA-P1-QMTEST01
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for MON
    ...    Injecting fault in the DMA peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332344
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_DMA_P1_QMTEST01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-DOM0-QMTEST02
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for MON
    ...    Injecting fault in the DOM0 peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332345
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_DOM0_QMTEST02}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-EVADC-QMTEST03
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for MON
    ...    Injecting fault in the EVADC peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332342
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_EVADC_QMTEST03}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-P33-DUMMY-QMTEST04
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting Fault in the P33 peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332343
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_P33_DUMMY_QMTEST04}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-MTU-QMTEST05
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault in the MTU peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332366
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_MTU_QMTEST05}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-PMS-QMTEST06
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault in the PMS peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332367
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_PMS_QMTEST06}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-SBCU-QMTEST07
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault in the SBCU peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332364
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_SBCU_QMTEST07}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-SCU-P0-QMTEST08
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault in the SCU peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332365
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_SCU_P0_QMTEST08}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-SMU-QMTEST09
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault in the SMU peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332370
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_SMU_QMTEST09}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-PERIPROT-STM0-QMTEST10
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault in the STM peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332371
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_STM0_QMTEST10}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-PERIPROT-FCE-QMTEST11
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault in the FCE peripheral register
    [Tags]    SAFETY    FULLTEST    FID-1399953,1399954,1399989    TCID-332368
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_PERIPROT_FCE_QMTEST11}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-TRAP1-TEST00
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Triggering Trap 1 by assigning a value to null address
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332369
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_TRAP1_TEST00}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-TRAP2-TEST01
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Triggering Trap 2 by calling invalid opcode
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332363
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_TRAP2_TEST01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-TRAP3-TEST02
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Triggering Trap 3 by calling recursive function
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332357
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_TRAP3_TEST02}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-TRAP4-EST03
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Triggering Trap 5 by generating arithmetic flow
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332358
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_TRAP4_EST03}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-TRAP5-TEST04
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Triggering Trap 5 by generating arithmetic flow
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332355
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_TRAP5_TEST04}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-MP-ASIL-WRITE-CORE0-TEST00
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Writing the ASIL Memory Regions of Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969    TCID-332356
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_MPU_MP_ASIL_WRITE_CORE0_TEST00}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-MP-ASIL-STACKOVERFLOW-CORE0-TEST01
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    To verify for OS task Stack Overflow
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332361
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_ASIL_STACKOVERFLOW_CORE0_TEST01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-MP-ASIL-CURR-STACK-WRITE-CORE0-TEST02
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Writing the ASIL Memory Regions of Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969    TCID-332362
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_MPU_MP_ASIL_CURR_STACK_WRITE_CORE0_TEST02}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-MP-ASIL-NEXT-STACK-WRITE-CORE0-TEST03
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    To verify os task stack is not allowed to write from other task except current task stack
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332359
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_ASIL_NEXT_STACK_WRITE_CORE0_TEST03}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-MP-ASIL-PREV-STACK-WRITE-CORE0-TEST04
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    To verify os task stack is not allowed to write from other task except current task stack
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332360
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_ASIL_PREV_STACK_WRITE_CORE0_TEST04}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-MP-QM-WRITE-CORE0-TEST00
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    Writing the QM Memory Regions of Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969    TCID-332337
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_MPU_MP_QM_WRITE_CORE0_TEST00}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervison_SAFETESTDRV-MPU-MP-QM-WRITE-DSPR0-ASIL-CORE0-TEST01
    [Documentation]    This function is called by Aurix.FIT_Manager module in QM context for running fault injection test for peripheral protection.
    ...    To Modify the Value of DSPR0 in Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332320
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_WRITE_DSPR0_ASIL_CORE0_TEST01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-WRITE-PSPR0-ASIL-CORE0-TEST02
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To Modify the Value of PSPR0 in Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332321
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_WRITE_PSPR0_ASIL_CORE0_TEST02}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-WRITE-DLMU0-ASIL-CORE0-TEST03
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To Modify the Value of DLMU0 in Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332325
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_WRITE_DLMU0_ASIL_CORE0_TEST03}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-WRITE-DSPR1-ASIL-CORE0-TEST04
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To Modify the Value of DSPR1 in Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332332
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_WRITE_DSPR1_ASIL_CORE0_TEST04}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-WRITE-PSPR1-ASIL-CORE0-TEST05
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To Modify the Value of PSPR1 in Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332336
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_WRITE_PSPR1_ASIL_CORE0_TEST05}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-WRITE-DLMU1-ASIL-CORE0-TEST06
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To Modify the Value of DLMU1 in Core 0
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332331
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_WRITE_DLMU1_ASIL_CORE0_TEST06}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-STACKOVERFLOW-CORE0-TEST07
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To verify for OS task Stack Overflow
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332327
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_STACKOVERFLOW_CORE0_TEST07}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-CURR-STACK-WRITE-CORE0-TEST08
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To verify os task stack is not allowed to write from other task except current task stack
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969    TCID-332328
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.SAFETESTDRV_MPU_MP_QM_CURR_STACK_WRITE_CORE0_TEST08}
    prj.sut.power cycle
    Sleep    10s

# Annette Start here #

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-NEXT-STACK-WRITE-CORE0-TEST09
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To verify os task stack is not allowed to write from other task except current task stack
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332329

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_NEXT_STACK_WRITE_CORE0_TEST09}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_SAFETESTDRV-MPU-MP-QM-PREV-STACK-WRITE-CORE0-TEST10
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    To verify os task stack is not allowed to write from other task except current task stack
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332324

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SAFETESTDRV_MPU_MP_QM_PREV_STACK_WRITE_CORE0_TEST10}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_WDG-CPU0-SERVCFAIL-TEST00
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault to fail the service of watchdog
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332330

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_CPU0_SERVCFAIL_TEST00}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_WDG-CPU0-ENDINITLOCK-TEST01
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault to write into Endinit protected register without unlocking the register
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332326

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_CPU0_ENDINITLOCK_TEST01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_WDG-CPU0-ENDINITUNLOCKED-TEST02
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault to timeout the Endinit protected register.
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332335

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_CPU0_ENDINITUNLOCKED_TEST02}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_WDG-CPU0-INVALIDPASSWORD-TEST03
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault to access Endinit protected register with wrong password.
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332334

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_CPU0_INVALIDPASSWORD_TEST03}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_WDG-SCPU-ENDINITLOCK-TEST04
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault to timeout the Endinit protected register
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332333

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_SCPU_ENDINITLOCK_TEST04}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_WDG-SCPU-ENDINITUNLOCKED-TEST05
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault to timeout the Endinit protected register
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332323

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_SCPU_ENDINITUNLOCKED_TEST05}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM04MemProtectionSupervision_WDG-SCPU-INVALIDPASSWORD-TEST06
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...    Injecting fault to access Endinit protected register with wrong password
    [Tags]    SAFETY    FULLTEST    FID-1399967,1399968,1399955,1399969,1400061    TCID-332322

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_SCPU_INVALIDPASSWORD_TEST06}
    prj.sut.power cycle
    Sleep    10s

# ******************PART 2******************

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DMEMRegionInjection00
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DMEM region
    [Tags]    SAFETY    FULLTEST    FID-1282478,1282479,1282480    TCID-227035

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DMEMRegionInjection00}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DTAGRegionInjection01
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DTAG Region
    [Tags]    SAFETY    FULLTEST    FID-1282478,1282479,1282480    TCID-227038

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DTAGRegionInjection01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_PMEMRegionInjection02
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the PMEM region
    [Tags]    SAFETY    FULLTEST    FID-1282478,1282479,1282480    TCID-227032

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PMEMRegionInjection02}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_PTAGRegionInjection03
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the PTAG region
    [Tags]    SAFETY    FULLTEST    FID-1282478,1282479,1282480    TCID-227046

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PTAGRegionInjection03}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DLMUSTBYRegionInjection04
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DLMU_STBY region
    [Tags]    SAFETY    FULLTEST    FID-1282478,1282479,1282480    TCID-227049

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DLMUSTBYRegionInjection04}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DMEMSBE10
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DMEM region
    [Tags]    SAFETY    FULLTEST    FID-1282479    TCID-227042

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.DMEMSBE10}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DTAGSBE11
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DTAG region
    [Tags]    SAFETY    FULLTEST    FID-1282479    TCID-227029

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check no reset happen.
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.DTAGSBE11}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_PMEMSBE12
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the PMEM region
    [Tags]    SAFETY    FULLTEST    FID-1282479    TCID-227021

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check no reset happen.
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PMEMSBE12}
    prj.sut.power cycle
    Sleep    10s

# EnvD_SysQual_ProductSafety_SM01RAMSupervision_PTAGSBE13
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
#     ...   Injecting fault in the PTAG region
#     [Tags]    SAFETY    FULLTEST    FID-1282479

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PTAGSBE13}


EnvD_SysQual_ProductSafety_SM01RAMSupervision_DLMUSTBYSBE14
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DMEM region
    [Tags]    SAFETY    FULLTEST    FID-1282479    TCID-227028

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check no reset happen.
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.DLMUSTBYSBE14}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DMEMDBE20
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DMEM region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227078

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check no reset happen.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DMEMDBE20}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DTAGDBE21
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DTAG region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227081

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DTAGDBE21}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_PNEMDBE22
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the PNEM region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227072

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PNEMDBE22}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_PTAGDBE23
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the PTAG region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227075

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PTAGDBE23}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DLMUSTBYDBE24
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DLMU_STBY region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227088

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DLMUSTBYDBE24}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DMEMMEF30
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DMEM region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227091

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DMEMMEF30}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DTAGMEF31
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DTAG region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227085

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DTAGMEF31}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_PMEMMEF32
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the PMEM region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227071

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PMEMMEF32}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_PTAGMEF33
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the PTAG region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227057

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PTAGMEF33}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM01RAMSupervision_DLMUSTBYMEF34
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for RAMMON
    ...   Injecting fault in the DLMU_STBY region
    [Tags]    SAFETY    FULLTEST    FID-1282480    TCID-227051

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DLMUSTBYMEF34}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST00
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...   EDC Error Injection PFlash0
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227054

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST00}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST01
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...   EDC Error Injection PFlash0
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227067

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST01}
    prj.sut.power cycle
    Sleep    10s

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST02
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...   Correctable Single Bits Address Buffer (SBAB) Error Injection in PFlash0
#     [Tags]    SAFETY    FULLTEST    FID-1337766    TCID-227070

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check no reset happen.
#     prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST02}

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST03
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...    Correctable Double Bits Address Buffer (DBAB) Error Injection PFlash0
#     [Tags]    SAFETY    FULLTEST    FID-1337766    TCID-227061

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check no reset happen.
#     prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST03}

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST04
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...    Uncorrectable Multi Bit Address Buffer (MBAB) Error Injection PFlash0
#     [Tags]    SAFETY    FULLTEST    FID-1337766,1337775    TCID-227064

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and no reset happen.
#     prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST04}

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST05

#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...    Uncorrectable All Zeros Bits Address Buffer (ZBAB) Error Injection PFlash0
#     [Tags]    SAFETY    FULLTEST    FID-1337766,1337775    TCID-227065

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check no reset happen.
#     prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST05}

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST06
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Single Bit Error (SBER) Injection PFlash0
    [Tags]    SAFETY    FULLTEST    FID-1337766,2151967    TCID-227063

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST06}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST07
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Double Bit Error (DBER) Injection PFlash0
    [Tags]    SAFETY    FULLTEST    FID-1337766,2151967    TCID-227062

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST07}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST08
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    NVM Configuration (NVMCER) Injection PFlash0
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227069

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST08}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST09
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Flashcon Error (FLCONER) Injection PFlash0
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227068

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST09}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST10
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Injecting all the above faults together PFlash0
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227066

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST10}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST11
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Injecting PFlash0 READ Path error
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227060

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST11}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST12
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    ECC Error Injection PFlash1
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227053

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST12}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST13
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    ECC Error Injection PFlash1
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227052

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST13}
    prj.sut.power cycle
    Sleep    10s

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST14
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...    Corrected Single Bits Address Buffer (SBAB) Error Injection PFlash1
#     [Tags]    SAFETY    FULLTEST    FID-1337766    TCID-227050

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check no reset happen.
#     prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST14}

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST15
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...    Corrected Double Bits Address Buffer (DBAB) Error Injection PFlash1
#     [Tags]    SAFETY    FULLTEST    FID-1337766    TCID-227058

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check no reset happen.
#     prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST15}

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST16
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...    Uncorrected Multi Bit Address Buffer (MBAB) Error Injection PFlash1
#     [Tags]    SAFETY    FULLTEST    FID-1337766    TCID-227059

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check no reset happen.
#     prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST16}

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST17
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...    Uncorrected All Zeros Bits Address Buffer (ZBAB) Error Injection PFlash1
#     [Tags]    SAFETY    FULLTEST    FID-1337766    TCID-227055

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check no reset happen.
#     prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST17}

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST18
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Single Bit Error (SBER) Injection PFlash1
    [Tags]    SAFETY    FULLTEST    FID-1337766,2151967    TCID-227056

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST18}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST19
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    NVM Configuration (NVMCER) Injection PFlash1
    [Tags]    SAFETY    FULLTEST    FID-1337766,2151967    TCID-227086

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.PFLASH0TEST19}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST20
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    NVM Configuration (NVMCER) Injection PFlash1
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227087

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST20}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST21
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Flashcon Error (FLCONER) Injection PFlash1
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227083

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST21}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST22
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Injecting all the above faults together PFlash1
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227084

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST22}
    prj.sut.power cycle
    Sleep    10s

# EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST23
#     [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
#     ...    Injecting PFlash1 READ Path error
#     [Tags]    SAFETY    FULLTEST    FID-1337766,1337768

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST23}

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST24
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Injecting SRI Address Phase Error
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227090

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST24}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST25
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Injecting SRI Bus Error
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227089

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST25}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST26
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Injecting SRI Bus Error
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227082

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST26}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST27
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Injecting SRI Bus Error
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227076

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST27}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM02ROMSupervision_PFLASH0TEST28
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection testing for PFlash Read Path error
    ...    Injecting LPB Access Voilation Error
    [Tags]    SAFETY    FULLTEST    FID-1337766,1337768    TCID-227074

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST28}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VDDPD-OverVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing over voltage to VDDPD pin.
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227073

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDPD_OverVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VDDM-OverVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing over voltage to VDDM pin.
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227080

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDM_OverVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VEVRSB-OverVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running faul
    ...    Passing over voltage to VEVRSB pin.
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227079

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDM_OverVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VDDPD-UnderVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing under voltage to VDDPD pin.
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227077

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDPD_UnderVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VDDM-UnderVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing under voltage to VDDM pin
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227018

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDM_UnderVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VEVRSB-UnderVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running faul
    ...    Passing under voltage to VEVRSB pin.
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227027

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEVRSB_UnderVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VDD-OverVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing over voltage to VDD pin.
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227023

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDD_OverVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VDDP3-OverVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing over voltage to VDDP3 pin
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227024

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDP3_OverVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VEXT-OverVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing over voltage to VEXT pin
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227025

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEXT_OverVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VDD-UnderVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing under voltage to VDD pin
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227026

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDD_UnderVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VDDP3-UnderVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing under voltage to VDDP3 pin.
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227020

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDP3_UnderVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12IVMSupervision_VEXT -UnderVoltage
    [Documentation]    This function is called by SafeTestDrv_Safety_Apps_IVM for running fault injection test of IVM
    ...    Passing under voltage to VEXT pin.
    [Tags]    SAFETY    FULLTEST    FID-2151900,2151933,2151937    TCID-227019

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEXT_UnderVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13TEMPSupervision_DTS-UPLIMIT-FAULT
    [Documentation]    This function is called by Aurix FIT manager module for running fault injection test.
    ...    By using this API we are injecting fault into the below mentioned Temperature sensors:
    ...    * DTS
    ...    * DTSC
    ...    Passing the temperature greater than upper limit to DTS
    [Tags]    SAFETY    FULLTEST    FID-1338714,1396214,1396215,1396220    TCID-227043

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DTS_UPLIMIT_FAULT}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13TEMPSupervision_DTS- LOWLIMIT-FAULT
    [Documentation]    This function is called by Aurix FIT manager module for running fault injection test.
    ...    By using this API we are injecting fault into the below mentioned Temperature sensors:
    ...    * DTS
    ...    * DTSC
    ...    Passing the temperature greater than lower limit to DTS .
    [Tags]    SAFETY    FULLTEST    FID-1338714,1396214,1396215,1396220    TCID-227044

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DTS_LOWLIMIT_FAULT}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13TEMPSupervision_DTSC-UPLIMIT-FAULT
    [Documentation]    This function is called by Aurix FIT manager module for running fault injection test.
    ...    By using this API we are injecting fault into the below mentioned Temperature sensors:
    ...    * DTS
    ...    * DTSC
    ...    Passing the temperature greater than the upper limit to DTSC.
    [Tags]    SAFETY    FULLTEST    FID-1338714,1396214,1396215,1396220    TCID-227040

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DTSC_UPLIMIT_FAULT}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13TEMPSupervision_DTSC-DOWNLIMIT-FAULT
    [Documentation]    This function is called by Aurix FIT manager module for running fault injection test.
    ...    By using this API we are injecting fault into the below mentioned Temperature sensors:
    ...    * DTS
    ...    * DTSC
    ...    Passing the temperature lesser than the lower limit to DTSC
    [Tags]    SAFETY    FULLTEST    FID-1338714,1396214,1396215,1396220    TCID-227048

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DTSC_DOWNLIMIT_FAULT}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_CLKM-PLL0-MONTST_TC_E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM21[15] - PLLx/fSPB Alive Alarm (provided on fBACK clock with x = 0..1) Standby Alarm ALM21[15] is replaced with ALM10[0]
    [Tags]    SAFETY    FULLTEST    FID-1338708,1338706,2151969,1338711    TCID-227047

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.CLKM_PLL0_MONTST_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_CLKM-PLL1-MONTST-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM21[15] - PLLx/fSPB Alive Alarm (provided on fBACK clock with x = 0..1) Standby Alarm ALM21[15] is replaced with ALM10[0]
    [Tags]    SAFETY    FULLTEST    FID-1338708,1338706,2151969,1338711    TCID-227045

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.CLKM_PLL1_MONTST_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_CLKM-SPB-MONTST-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM21[15] - PLLx/fSPB Alive Alarm (provided on fBACK clock with x = 0..1) Standby Alarm ALM21[15] is replaced with ALM10[0]
    [Tags]    SAFETY    FULLTEST    FID-1338708,1338706,2151969,1338711    TCID-227033

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.CLKM_SPB_MONTST_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_BACKUP-MONTST-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM8[2] - Backup Clock Alive Alarm
    [Tags]    SAFETY    FULLTEST    FID-1338708,1338706,2151969,1338711    TCID-227034

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.BACKUP_MONTST_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_OSCMAIN-HIGFREQ-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM8[0] - OSC clock frequency out of range
    [Tags]    SAFETY    FULLTEST    FID-1338708,1338706,2151969,1338711    TCID-227039

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCMAIN_HIGFREQ_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_OSCMAIN-LOWFREQ-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM8[0] - OSC clock frequency out of range
    [Tags]    SAFETY    FULLTEST    FID-1338708,1338706,2151969,1338711    TCID-227037

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCMAIN_LOWFREQ_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_OSCBACK-LOWFREQ-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM8[1] - Back-up clock out-of-range alarm
    [Tags]    SAFETY    FULLTEST    FID-1338706,2151969,1338711    TCID-227031

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCBACK_LOWFREQ_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_OSCBACK-HIGHFREQ-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection
    ...    ALM8[1] - Back-up clock out-of-range alarm
    [Tags]    SAFETY    FULLTEST    FID-1338706,2151969,1338711    TCID-227030

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCBACK_HIGFREQ_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_SYSPLL0-LOSSOFLOCK-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM8[3] - System PLL DCO loss of lock event.
    [Tags]    SAFETY    FULLTEST    FID-1338708,1338706,2151969,1338711    TCID-227036

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SYSPLL0_LOSSOFLOCK_TC_E}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM18ClockSupervision_PERPLL0-LOSSOFLOCK-TC-E
    [Documentation]    This function is called by Aurix.FIT_Manager module for running fault injection test for peripheral protection.
    ...    ALM8[4] - Peripheral PLL DCO loss of lock event.
    [Tags]    SAFETY    FULLTEST    FID-1338708,1338706,2151969,1338711    TCID-227041

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PERPLL0_LOSSOFLOCK_TC_E}
    prj.sut.power cycle
    Sleep    10s

# Haakim Test Case starts here SM09_PERI

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST000
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_WDTS_CON1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272156

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST000}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST001
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_WDTCPU0_CON1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-272153
    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST001}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST002
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_EICON1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237    TCID-272159

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST002}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST003
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_SEICON1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237    TCID-272145

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST003}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST004
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_EICR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237    TCID-272142

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST004}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST005
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_CCUCON3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237    TCID-272151

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST005}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST006
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_CCUCON4 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237    TCID-272148

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST006}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST007
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_ACCEN00 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237    TCID-272174

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST007}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST008
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SCU_ACCEN10 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237    TCID-272180

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST008}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST009
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_EVRRSTCON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272177

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST009}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST010
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_MONCTRL register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272164

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST010}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST011
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_EVRMONFILT register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272170

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST011}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST012
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_PMSIEN register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272167

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST012}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST013
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_EVRUVMON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272126

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST013}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST014
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_EVROVMON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272138

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST014}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST015
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_EVRUVMON2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272268

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST015}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST016
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_EVROVMON2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272132

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST016}
    prj.sut.power cycle
    Sleep    10s

# EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST017
#     [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
#     ...    Passing a fault value to PMS_DTSLIM register
#     [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272124

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST017}

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST018
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...   Passing a fault value to PMS_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147551    TCID-272125

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST018}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST019
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P33_IOCR4 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147549    TCID-272137

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset   ${sut.safety.REGM_PERI_TEST019}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST020
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P33_PDISC register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147549    TCID-272237

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset   ${sut.safety.REGM_PERI_TEST020}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST021
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P33_PDR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147549    TCID-272234

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset   ${sut.safety.REGM_PERI_TEST021}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST022
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P33_PDR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147549    TCID-272243

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset   ${sut.safety.REGM_PERI_TEST022}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST023
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P33_ESR register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,2147549    TCID-272240

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST023}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST024
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGC register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272226

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST024}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST025
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_RTC register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272232

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST025}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST026
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_PCTL register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272229

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST026}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST027
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_RTAC00 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272258

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST027}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST028
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_RTAC01 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272255

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST028}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST029
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_RTAC10 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272264

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST029}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST030
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_RTAC11 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272261

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST030}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST031
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF0_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272247

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST031}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST032
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF0_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272253

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST032}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST033
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF0_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272250

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST033}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST034
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF1_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272195

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST034}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST035
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF1_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272192

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST035}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST036
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF1_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272201

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST036}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST037
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF2_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272198

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST037}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST038
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF2_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272184

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST038}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST039
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF2_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272190

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST039}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST040
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF6_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272187

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST040}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST041
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF6_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272216

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST041}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST042
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF6_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272213

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST042}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST043
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF7_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272222

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST043}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST044
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF7_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272219

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST044}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST045
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF7_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272205

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST045}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST046
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF8_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272211

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST046}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST047
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF8_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272208

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST047}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST048
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF8_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272209

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST048}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST049
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF9_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272210

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST049}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST050
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF9_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272212

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST050}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST051
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF9_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272204

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST051}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST052
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF10_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272203

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST052}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST053
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF10_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272207

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST053}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST054
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF10_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272206

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST054}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST055
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF11_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272218

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST055}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST056
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF11_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272220

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST056}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST057
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGCF11_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272221

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST057}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST058
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272214

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST058}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST059
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272215

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST059}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST060
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272217

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST060}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST061
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272202

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST061}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST062
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP4 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272188

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST062}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST063
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP5 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272189

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST063}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST064
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP6 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272191

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST064}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST065
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP7 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272183

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST065}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST066
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP8 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272182

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST066}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST067
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP9 register
    [Tags]    SAFETY    FULLTEST    FID-1396234,1396236,1396241    TCID-272186

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST067}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST068
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP10 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272185

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST068}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST069
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_AGFSP11 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272197

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST069}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST070
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_CMD_STDBY register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241,2147551    TCID-272199

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST070}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST071
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_AGFSP_STDBY0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241,2147551    TCID-272200

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST071}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST072
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PMS_AGFSP_STDBY1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241,2147551    TCID-272193

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST072}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST073
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SMU_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241,2147551    TCID-272194

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST073}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST074
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to EVADC_G0_ANCFG register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272196

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST074}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST075
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to EVADC_G0_SYNCTR register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272223

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST075}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST076
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.Passing a fault value to EVADC_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272251

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST076}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST077
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to STM0_CMCON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272252

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST077}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST078
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core.
    ...    Passing a fault value to STM0_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272254

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST078}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST079
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC0_ECCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272246

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST079}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST080
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC1_ECCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272245

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST080}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST081
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC2_ECCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272249

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST081}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST082
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC3_ECCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272248

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST082}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST083
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC4_ECCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272260

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST083}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST084
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC34_ECCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272262

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST084}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST085
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC0_ALMSRCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272263

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST085}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST086
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC1_ALMSRCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272256

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST086}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST087
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC2_ALMSRCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272257

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST087}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST088
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC3_ALMSRCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272259

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST088}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST089
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC4_ALMSRCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272244

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST089}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST090
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC34_ALMSRCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272230

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST090}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST091
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0
    ...    Passing a fault value to SRC_SMU_SMU0_SR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272231

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST091}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST092
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_SMU_SMU0_SR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272233

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST092}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST093
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_SMU_SMU0_SR2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396241    TCID-272225

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST093}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST094
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G0_SR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272224

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST094}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST095
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G0_SR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272228

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST095}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST096
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G0_SR2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272227

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST096}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST097
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G0_SR3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272239

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST097}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST098
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_STM_STM0_SR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272241

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST098}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST099
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G1_SR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272242

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST099}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST100
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G1_SR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272235

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST100}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST101
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G1_SR2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272236

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST101}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST102
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G1_SR3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272238

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST102}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST103
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G2_SR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272123

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST103}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST104
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G2_SR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272122

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST104}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST105
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G2_SR2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272136

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST105}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST106
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G2_SR3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272134

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST106}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST107
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G3_SR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272420

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST107}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST108
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G3_SR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272120

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST108}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST109
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G3_SR2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272127

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST109}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST110
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G3_SR3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272140

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST110}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST111
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G8_SR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272133

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST111}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST112
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G8_SR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272135

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST112}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST113
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G8_SR2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272139

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST113}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST114
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G8_SR3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272141

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST114}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST115
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G11_SR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272129
    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST115}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST116
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G11_SR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272121

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST116}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST117
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G11_SR2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272128

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST117}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST118
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_VADC_G11_SR3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396231    TCID-272168

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST118}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST119
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SRC_DMA_DMA0_CH0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272169

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST119}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST120
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_SCICTRL1_PECON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272171

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST120}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST121
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_SCICTRL2_PECON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272163

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST121}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST122
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_SCICTRL3_PECON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272162

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST122}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST123
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_SCICTRL4_PECON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272166

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST123}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST124
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_SCICTRL5_PECON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272178

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST124}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST125
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_SCICTRL6_PECON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272179

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST125}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST126
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_SCICTRL8_PECON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272181

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST126}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST127
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to MTU_MC3_ECCS register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272173

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST127}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST128
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_SCICTRL15_PECON register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272172

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST128}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST129
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CONVCTRL_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272176

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST129}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST130
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DMA_ACCEN0_ACCENR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272175

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST130}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST131
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DMA_ACCEN1_ACCENR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272147

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST131}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST132
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DMA_ACCEN2_ACCENR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272149

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST132}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST133
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DMA_ACCEN3_ACCENR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272150

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST133}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST134
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P15_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272143

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST134}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST135
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P20_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272144

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST135}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST136
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P32_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272146

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST136}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST137
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P33_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272158

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST137}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST138
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to DOM0_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272157

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST138}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST139
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to SBCU_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272161

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST139}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST140
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to GTM_ACCEN0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272160

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST140}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST141
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to EVADC_G11_ANCFGregister
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272152

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST141}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST142
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to EVADC_G11_SYNCTR register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272154

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST142}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST143
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P33_IOCR12 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272155

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST143}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST144
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P33_IOCR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-272165

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST144}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST145
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PHSCFG register
    [Tags]    SAFETY    FULLTEST    FID-1396232   TCID-434988

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_PERI_TEST145}
    prj.sut.power cycle
    Sleep    10s

# Haakim-SM20,SM23

# EnvD_SysQual_ProductSafety_SM20&23_DLTView
#     [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
#     ...    Passing a fault value to CPU_CPXE_0 register
#     [Tags]    SAFETY    FULLTEST    FID-1396099,1396101,1396102,2725238    TCID-332314

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.DLTView}

# Haakim-SM24

# EnvD_SysQual_ProductSafety_SM24_SS01
#     [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
#     ...    Passing a fault value to CPU_CPXE_1 register
#     [Tags]    SAFETY    FULLTEST    FID-1282475    TCID-332313

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SS01}

# Haakim-SM06

# EnvD_SysQual_ProductSafety_SM06WDGSupervison_ALIVESV-ASILCORE0-MAX-EXCEED-TEST00
#     [Documentation]    For alive supervision test cases of QM context,
#     ...    the checkpoint exceeds more than the maximum threshold value,
#     ...    SSH should be called after the reference time interval, which varies for each task but lies within FTTI.
#     ...    Exceed Alive counter of BswTask_10ms_ASILCore0 task
#     [Tags]    SAFETY    FULLTEST    FID-1400061,1400057    TCID-332319

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.ALIVESV_ASILCORE0_MAX_EXCEED_TEST00}

# EnvD_SysQual_ProductSafety_SM06WDGSupervison_WDG-ALIVESV-QM5MSCORE0-MAX-EXCEED-TEST00
#     [Documentation]    For alive supervision test cases of QM context,
#     ...    the checkpoint exceeds more than the maximum threshold value,
#     ...    SSH should be called after the reference time interval, which varies for each task but lies within FTTI.
#     ...    Exceed Alive counter of BswTask_5ms_QMCore0 task
#     [Tags]    SAFETY    FULLTEST    FID-1400061,1400057    TCID-332317

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_ALIVESV_QM5MSCORE0_MAX_EXCEED_TEST00}

# EnvD_SysQual_ProductSafety_SM06WDGSupervison_WDG-ALIVESV-QM10MSCORE0-MAX-EXCEED-TEST01
#     [Documentation]    For alive supervision test cases of QM context,
#     ...    the checkpoint exceeds more than the maximum threshold value, SSH should be called after
#     ...    the reference time interval, which varies for each task but lies within FTTI.
#     ...    Exceed Alive counter of BswTask_10ms_QMCore0 task
#     [Tags]    SAFETY    FULLTEST    FID-1400061,1400057    TCID-332318

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_ALIVESV_QM10MSCORE0_MAX_EXCEED_TEST01}

# EnvD_SysQual_ProductSafety_SM06WDGSupervison_WDG-ALIVESV-QM20MSCORE0-MAX-EXCEED-TEST02
#     [Documentation]    For alive supervision test cases of QM context,
#     ...    the checkpoint exceeds more than the maximum threshold value, SSH should
#     ...    be called after the reference time interval, which varies for each task
#     ...    but lies within FTTI.
#     ...    Exceed Alive counter of BswTask_20ms_QMCore0 task
#     [Tags]    SAFETY    FULLTEST    FID-1400061,1400057    TCID-332315

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_ALIVESV_QM20MSCORE0_MAX_EXCEED_TEST02}

# EnvD_SysQual_ProductSafety_SM06WDGSupervison_WDG-ALIVESV-QM100MSCORE0-MAX-EXCEED-TEST03
#     [Documentation]    For alive supervision test cases of QM context, the checkpoint
#     ...    exceeds more than the maximum threshold value, SSH should be called after the
#     ...    reference time interval, which varies for each task but lies within FTTI.
#     ...    Exceed Alive counter of BswTask_100ms_QMCore0 task
#     [Tags]    SAFETY    FULLTEST    FID-1400061,1400057    TCID-332316

#     # Wake up Maas Blade before Safety Injection Test.
#     prj.sut.safety.wakeup

#     # Setting to UTF mode
#     prj.sut.safety.setUTFmode

#     # Injecting failure command and check reset only.
#     prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.WDG_ALIVESV_QM100MSCORE0_MAX_EXCEED_TEST03}

# Haakim-SM09_CPU

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST000
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPXE_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-332312

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST000}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST001
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPXE_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273889

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST001}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST002
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPXE_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273890

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST002}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST003
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPXE_3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273891

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST003}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST004
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPXE_4 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273886

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST004}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST005
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPXE_5 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273887

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST005}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST006
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPRE_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273888

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST006}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST007
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPRE_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273892

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST007}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST008
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPRE_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273896

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST008}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST009
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPRE_3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273897

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST009}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST010
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPRE_4 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273898

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST010}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST011
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPRE_5 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273893

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST011}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST012
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPWE_0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273894

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST012}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST013
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPWE_1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273895

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST013}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST014
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPWE_2 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273876

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST014}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST015
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPWE_3 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273877

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST015}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST016
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPWE_4 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273878

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST016}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST017
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPWE_5 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273873

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST017}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST018
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR1_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273874

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST018}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST019
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR1_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273875

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST019}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST020
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR2_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273879

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST020}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST021
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR2_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273883

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST021}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST022
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR3_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273884

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST022}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST023
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR3_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273885

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST023}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST024
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR4_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273880

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST024}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST025
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR4_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273881

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST025}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST026
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR5_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273882

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST026}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST027
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR5_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273915

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST027}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST028
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR6_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273916

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST028}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST029
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR6_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273917

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST029}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST030
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR7_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273912

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST030}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST031
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR7_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273913

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST031}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST032
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR8_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273914

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST032}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST033
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR8_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273918

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST033}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST034
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR9_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273922

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST034}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST035
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR9_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273923

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST035}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST036
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR10_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273924

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST036}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST037
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR10_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273919

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST037}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST038
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR11_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273920

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST038}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST039
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR11_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273921

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST039}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST040
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR12_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273902

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST040}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST041
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR12_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273903

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST041}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST042
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR13_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273904

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST042}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST043
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR13_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273899

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST043}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST044
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR14_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273900

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST044}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST045
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR14_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273901

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST045}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST046
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR15_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273905

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST046}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST047
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR15_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273909

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST047}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST048
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR16_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273910
    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST048}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST049
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR16_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273911

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST049}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST050
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR17_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273906

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST050}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST051
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DPR17_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273907

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST051}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST052
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR0_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273908

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST052}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST053
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR0_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273851

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST053}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST054
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR1_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273850

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST054}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST055
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR1_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273854

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST055}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST056
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR2_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273849

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST056}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST057
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR2_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273865

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST057}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST058
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR3_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273871

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST058}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST059
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR3_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273870

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST059}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST060
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR4_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273857

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST060}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST061
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR4_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273864

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST061}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST062
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR5_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273862

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST062}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST063
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR5_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273858

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST063}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST064
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR6_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273869

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST064}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST065
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR6_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273867

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST065}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST066
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR7_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273855

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST066}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST067
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR7_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273848

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST067}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST068
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR8_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273856

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST068}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST069
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR8_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273866

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST069}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST070
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR9_L register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273859

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST070}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST071
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_CPR9_U register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273861

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST071}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST072
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_PMA0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273863

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST072}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST073
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_PMA1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273860

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST073}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST074
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_PCON0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273872

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST074}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST075
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_DCON0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273868

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST075}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST076
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_COMPAT register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273847

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST076}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST077
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_TPS_EXTIM_EXIT_LVAL register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273853

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST077}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-CPU-TEST078
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to CPU_TPS_EXTIM_EXIT_LVAL register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236,1396237,1396238,1396239,1396240    TCID-273852

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.REGM_CPU_TEST078}
    prj.sut.power cycle
    Sleep    10s
	
	
#Below Regm FIT Commands Works only in C2-Sample(145-159)
EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST146
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P22_IOCR8 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534730

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST146}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST147
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P32_IOCR4 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534731

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST147}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST148
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to PP15_IOCR4 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534732

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST148}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST149
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P15_IOCR8 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534733

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST149}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST150
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P22_PDISC register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534734

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST150}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST151
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P32_PDISC register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534735

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST151}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST152
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P15_PDISC register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534738

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST152}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST153
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P22_PDR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534740

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST153}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST154
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P32_PDR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534741

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST154}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST155
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P15_PDR0 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534742

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST155}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST156
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P15_PDR1 register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534743

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST156}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST157
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P22_ESR register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534744

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST157}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST158
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P22_ESR register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534745

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST158}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST159
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P15_ESR register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534746

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST159}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM09RegisterSupervison_REGM-PERI-TEST160
    [Documentation]    This function lets the test framework to inject faults in the desired configured registers of REGM in Core0.
    ...    Passing a fault value to P15_OUT register
    [Tags]    SAFETY    FULLTEST    FID-1396242,1396234,1396236    TCID-534747

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.REGM_PERI_TEST160}
    prj.sut.power cycle
    Sleep    10s


#SM12ExtVolatgeMonitoring_Testcases
#Removed UBAT related Tetscase based on https://rb-aebe-review.de.bosch.com/ui#review:id=162978
EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_U88SADC
    [Documentation]    This testcase checks triggering ADC range check failure for U88S voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4054100,4018293,4044195,4044194,4044196,4018294,4018288    TCID-529647

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_U88SADC}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_U88SUV
    [Documentation]    This testcase checks triggering UV failure for U88S voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4018294,4044195,4044196,4054100,4018293,4018288    TCID-529638

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_U88SUV}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_U88SOV
    [Documentation]    This testcase checks triggering OV failure for U88S voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4044196,4018293,4018288,4018294,4044195,4054100 TCID-529651

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_U88SOV}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_U88SADCHYST
    [Documentation]    This testcase checks triggering ADC range check fault and verifying the recovery mechanism for U88S voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4054100,3846897,4044196,4044195,4018293,4018288,4044194,4018294    TCID-529652

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_U88SADCHYST}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_U88SUVHYST
    [Documentation]    This testcase checks triggering UV fault and verifying the recovery mechanism for U88S voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4054100,4044194,4018288,4018294,4018293,4044195    TCID-529653

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_U88SUVHYST}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_U88SOVHYST
    [Documentation]    This testcase checks triggering OV fault and verifying the recovery mechanism for U88S voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4044194,4054100,4044196,4018293,4044195,4018294,4018288    TCID-529650

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_U88SOVHYST}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_ETHADC
    [Documentation]    This testcase checks triggering ADC range check failure for ETH voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992089,4992093,4992092,4992088,4992090,4992091    TCID-535064

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_ETHADC}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_ETHUV
    [Documentation]    This testcase checks triggering UV failure for ETH voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992092,4992093,4992087,4992090    TCID-535065

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_ETHUV}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_ETHOV
    [Documentation]    This testcase checks triggering OV failure for ETH voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992092,4992093,4992087,4992090   TCID-535066

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_ETHOV}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_ETHADCHYST
    [Documentation]    This testcase checks triggering ADC range check fault and verifying the recovery mechanism for ETH voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992093,4992090,4992092,4992091,4992089,4992088    TCID-535067

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_ETHADCHYST}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_ETHUVHYST
    [Documentation]    This testcase checks triggering UV fault and verifying the recovery mechanism for ETH voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992093,4992090,4992092,4992091,4992089,4992088    TCID-535068

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_ETHUVHYST}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_ETHOVHYST
    [Documentation]    This testcase checks triggering OV fault and verifying the recovery mechanism for ETH voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992093,4992090,4992092,4992091,4992089,4992088    TCID-535069

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_ETHOVHYST}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_CPUADC
    [Documentation]    This testcase checks triggering UV failure for CPU voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992086,4992085,4992081,4992079,4992083,4992082   TCID-535070

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_CPUADC}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_CPUUV
    [Documentation]    This testcase checks triggering UV failure for CPU voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992085,4992086,4992078    TCID-535071

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_CPUUV}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_CPUOV
    [Documentation]    This testcase checks triggering OV failure for CPU voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992085,4992086,4992078    TCID-535072

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_CPUOV}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_CPUADCHYST
    [Documentation]    This testcase checks triggering ADC range check fault and verifying the recovery mechanism for CPU voltage rail
    [Tags]    SAFETY    FULLTEST    FID-4992083,4992081,4992082,4992085,4992086,4992079   TCID-535073

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_CPUADCHYST}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_CPUUVHYST
    [Documentation]    This testcase checks triggering UV fault and verifying the recovery mechanism for CPU voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992082,4992086,4992085,4992081,4992079,4992083    TCID-535074

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_CPUUVHYST}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM12ExtVoltageSupervision_CPUOVHYST
    [Documentation]    This testcase checks triggering OV fault and verifying the recovery mechanism for CPU voltage rail.
    [Tags]    SAFETY    FULLTEST    FID-4992082,4992086,4992085,4992081,4992079,4992083    TCID-535075

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTVOLT_CPUOVHYST}
    prj.sut.power cycle
    Sleep    10s

#SM13ExtTempSupervision_Testcases
EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_BLADETOPADCMINTHD
    [Documentation]    This testcase enusure the Fault handling and Fault reaction of Blade top sensor input value is provided with below minimum ADC threshold value.
    [Tags]    SAFETY    FULLTEST    FID-1412571,4166108,1876534,4193886,3843443,1438094,1412570,4679796,4326765,3843474   TCID-529738

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTTEMP_BLADETOPADCMINTHD}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_BLADETOPADCMAXTHD
    [Documentation]    This testcase enusure the Fault handling and Fault reaction of Blade top sensor input value is provided with below maximum ADC threshold value.
    [Tags]    SAFETY    FULLTEST    FID-3843471,1412570,4326765,1438094,1412571,4166108,3843435,4193886,4679796,3843443     TCID-529739

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTTEMP_BLADETOPADCMAXTHD}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_BLADETOPADCPlAUSBILITY
    [Documentation]    This testcase enusure the Fault handling and Fault reaction of Blade top sensor input value is provided with difference value than the Plausibiility threshold value.
    [Tags]    SAFETY    FULLTEST    FID-1412570,4326765,3843443,4679796,1438094,1412571,3843471,4193886,3843435,1876534   TCID-529744

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTTEMP_BLADETOPADCPlAUSBILITY}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_BLADETOPOVERTEMP
    [Documentation]    This testcase enusure the Fault handling and Fault reaction of Blade top sensor input value is provided with ADC value than the Over temperature threshold value.
    [Tags]    SAFETY    FULLTEST    FID-3843471,3843474,4193886,3843435,1438094,1876534,4166108,1412571,1412570,4679796    TCID-529740

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTTEMP_BLADETOPOVERTEMP}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_BLADEBOTTOMADCMINTHD
    [Documentation]    This testcase enusure the Fault handling and Fault reaction of Blade bottom sensor input value is provided with below minimum ADC threshold value.
    [Tags]    SAFETY    FULLTEST    FID-1412570,1412571,3843474,1876534,4193886,4166108,3843443,3843471,4326765,4679796   TCID-529743

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTTEMP_BLADEBOTTOMADCMINTHD}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_BLADEBOTTOMADCMAXTHD
    [Documentation]    This testcase enusure the Fault handling and Fault reaction of Blade bottom sensor input value is provided with below maximum ADC threshold value.
    [Tags]    SAFETY    FULLTEST    FID-4193886,1876534,3843474,4326765,3843471,4679796,4166108,1412571,1438094,1412570    TCID-529745

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTTEMP_BLADEBOTTOMADCMAXTHD}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_BLADEBOTTOMADCPlAUSBILITY
    [Documentation]    This testcase enusure the Fault handling and Fault reaction of Blade bottom sensor input value is provided with difference value than the Plausibiility threshold value.
    [Tags]    SAFETY    FULLTEST    FID-4193886,4326765,4166108,4679796,3843471,3843474,1412570,1438094,1412571,3843443     TCID-529746

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTTEMP_BLADEBOTTOMADCPlAUSBILITY}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_BLADEBOTTOMOVERTEMP
    [Documentation]    This testcase enusure the Fault handling and Fault reaction of Blade bottom sensor input value is provided with ADC value than the Over temperature threshold value.
    [Tags]    SAFETY    FULLTEST    FID-4166108,4679796,1412570,3843443,4326765,1876534,3843435,4193886,1412571,3843474  TCID-529741

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset   ${sut.safety.EXTTEMP_BLADEBOTTOMOVERTEMP}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_SENSORINPUTFAILURE
    [Documentation]    This testcase ensure the fault handling is done within the FHTI for sensor input failures FHTI = 100ms
    [Tags]    SAFETY    FULLTEST    FID-4193886,3843471,4679796,3843443,4166108,1412571,4326765,1876534,3843435,1412570   TCID-529747

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset  ${sut.safety.EXTTEMP_SENSORINPUTFAILURE}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM13ExtTempSupervision_SENSORRANGEEXCEEDED
    [Documentation]    This testcase ensure the fault detection is done within the FDTI for range excedded errors.FDTI = 1 sec.
    [Tags]    SAFETY    FULLTEST    FID-4166108,3843474,1412570,4326765,1876534,1438094,3843443,4193886,3843471,3843435    TCID-529742

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check non-reset
    prj.sut.safety.injectandverify.withoutreset    ${sut.safety.EXTTEMP_SENSORRANGEEXCEEDED}
    prj.sut.power cycle
    Sleep    10s

# SM23-ADCPlausbility

EnvD_SysQual_ProductSafety_SM23_ADCPlausibility_TC1
    [Documentation]    This testcase ensure the fault detection is done by Passing the voltage greater than upper thresold
	...    Passing ADCCCHANNELU33SSCC_SNS voltage greater
    [Tags]    SAFETY    FULLTEST    FID-2742217,1282483,2048371,1396102,1396101,1396094,1396099   TCID-372630

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.ADCPlausbility_ADCC_CHANNEL_U33S_SCC_SNS_GreaterVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM23_ADCPlausibility_TC2
    [Documentation]    This testcase ensure the fault detection is done by Passing the lesser than lower thresold
	...    Passing ADCCCHANNELU33SSCC_SNS voltage Lower
    [Tags]    SAFETY    FULLTEST    FID-2742217,1396102,1396101,1396094,1396099   TCID-372629

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.ADCPlausbility_ADCC_CHANNEL_U33S_SCC_SNS_LowerVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM23_ADCPlausibility_TC3
    [Documentation]    This testcase ensure the fault detection is done by Passing the voltage greater than upper thresold
	...    Passing ADCCCHANNELBLADE_TOP_TMP voltage greater
    [Tags]    SAFETY    FULLTEST    FID-2742217,1396102,1396101,1396099   TCID-372632

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.ADCPlausbility_ADCC_CHANNEL_BLADE_TOP_TMP_GreaterVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM23_ADCPlausibility_TC4
    [Documentation]    This testcase ensure the fault detection is done by Passing the voltage lesser than upper thresold
	...    Passing ADCCCHANNELBLADE_TOP_TMP voltage Lesser
    [Tags]    SAFETY    FULLTEST    FID-2742217,1396102,1396101,1396099   TCID-372631

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.ADCPlausbility_ADCC_CHANNEL_BLADE_TOP_TMP_LowerVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM23_ADCPlausibility_TC5
    [Documentation]    This testcase ensure the fault detection is done by Passing the voltage greater than upper thresold
	...    Passing ADCCCHANNELBLADE_BOT_TMP voltage greater
    [Tags]    SAFETY    FULLTEST    FID-2742217,1396102,1396101,1396099   TCID-372627

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.ADCPlausbility_ADCC_CHANNEL_BLADE_BOT_TMP_GreaterVoltage}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM23_ADCPlausibility_TC6
    [Documentation]    This testcase ensure the fault detection is done by Passing the voltage lower than upper thresold
	...    Passing ADCCCHANNELBLADE_BOT_TMP voltage lower
    [Tags]    SAFETY    FULLTEST    FID-2742217,1396102,1396101,1396099   TCID-372628

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.ADCPlausbility_ADCC_CHANNEL_BLADE_BOT_TMP_LowerVoltage}
    prj.sut.power cycle
    Sleep    10s

#SSH Testcases
EnvD_SysQual_ProductSafety_SM20_SSH-execute-TC01
    [Documentation]    This testcase ensure Undefined non-existent error, triggering a reset.
    ...    Undefined non-existent error, triggering a reset.
    [Tags]    SAFETY    FULLTEST    FID-1282483    TCID-506527


    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_TC01}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM20_SSH-execute-TC10
    [Documentation]    This testcase ensure Safe State Triggered when Error Tolerance reached
    ...    Safe State Triggered when Error Tolerance reached
    [Tags]    SAFETY    FULLTEST    FID-1282483    TCID-506528

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_TC10}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM20_SSH-execute-TC11
    [Documentation]    This testcase ensure Operation Mode changes 01
    ...    Operation Mode changes 01
    [Tags]    SAFETY    FULLTEST    FID-1282483    TCID-506526

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_TC11}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM20_SSH-execute-TC16
    [Documentation]    This testcase ensure general SEH error reporting
    ...    general SEH error reporting
    [Tags]    SAFETY    FULLTEST    FID-1282483    TCID-506525

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_TC16}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM20aurixSafeStateHandler_MaxResetCounter
    [Documentation]    This testcase check safe state handler Max_resetCounter
    ...    check safe state handler Max_resetCounter
    [Tags]    SAFETY    FULLTEST    FID-1282484,2134902    TCID-501124

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_MAXResetCounter}
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_MAXResetCounter}
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_MAXResetCounter}
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_MAXResetCounter}
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_MAXResetCounter}
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_MAXResetCounter}
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_MAXResetCounter}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM20aurixSafeStateHandler_CommunicationCheck
    [Documentation]    This testcase check safe state handler communication check
    ...    check safe state handler communication check
    [Tags]    SAFETY    FULLTEST    FID-2356986    TCID-501126

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_CommunicationCheck}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM20aurixSafeStateHandler_DegradationState_Recovery
    [Documentation]    This testcase check safe state handler degradation state recovery
    ...    heck safe state handler degradation state recovery
    [Tags]    SAFETY    FULLTEST    FID-3565915    TCID-501125

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_DegradationStateRecovery}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_ProductSafety_SM20aurixSafeStateHandler_CommunicationCheck_SS01
    [Documentation]    This testcase check safe state handlercommunicationcheckSS1
    ...    check safe state handlercommunicationcheck_SS1
    [Tags]    SAFETY    FULLTEST    FID-1282477    TCID-501128

    # Wake up Maas Blade before Safety Injection Test.
    prj.sut.safety.wakeup

    # Setting to UTF mode
    prj.sut.safety.setUTFmode

    # Injecting failure command and check reset only.
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.SSH_CommunicationCheckSS01}
    prj.sut.power cycle
    Sleep    10s

# Diagnostic Safety DTC Test start here

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_NVMConfiguration(NVMCER)InjectionPFlash0
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST8→ NVM Configuration (NVMCER) Injection PFlash0
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371315    FID-2869055
    prj.sut.safety.postcondition
    prj.sut.can.diag.tester.present.active
    Sleep    10s
    # Clear DTC command
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
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_NVMConfiguration(NVMCER)InjectionPFlash1
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST20→ NVMConfiguration (NVMCER) Injection PFlash1
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371316    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST20}
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashConfigurationError_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_ECCErrorInjectionPFlash0
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST0 → ECC Error Injection PFlash0
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371317    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST00}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashECCFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_ECCErrorInjectionPFlash1
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST12 → ECC Error Injection PFlash1
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371314    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST12}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashECCFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_EDCErrorInjectionPFlash0
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST1 → EDC Error Injection PFlash0
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371311    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST01}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_EDCErrorOverPflash_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_EDCErrorInjectionPFlash1
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST13 → EDC Error Injection PFlash1
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371312    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST01}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_EDCErrorOverPflash_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_PFlashConfigurationErrorDTC_InjectingPFlash0READPathError
    [Documentation]    To perform FIT_ROMMON_PFLASH0_TEST11→ Injecting PFlash0 READ Path error
    ...     to trigger PFlash error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371625    FID-2869055
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PFLASH0TEST11}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PFlashReadPathError_Resp}
    prj.sut.power cycle
    Sleep    10s

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
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDPD_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVDDPDPin
    [Documentation]    To perform FIT_IVM_VDDPD_UV → Passing undervoltage to VDDPD pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371322    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDPD_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVDDMPin
    [Documentation]    To perform FIT_IVM_VDDM_OV → Passing overvoltage to VDDM pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371323    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDM_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVDDMPin
    [Documentation]    To perform FIT_IVM_VDDM_UV → Passing undervoltage to VDDM pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371324    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDM_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVEVRSBPin
    [Documentation]    To perform FIT_IVM_VEVRSB_OV → Passing overvoltage to VEVRSB pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371321    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEVRSB_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVEVRSBPin
    [Documentation]    To perform FIT_IVM_VEVRSB_UV → Passing undervoltage to VEVRSB pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371318    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEVRSB_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVDDPin
    [Documentation]    To perform FIT_IVM_VDD_OV → Passing overvoltage to VDD pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371319    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDD_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVDDPin
    [Documentation]    To perform FIT_IVM_VDD_UV → Passing undervoltage to VDD pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371320    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDD_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVDDP3Pin
    [Documentation]    To perform FIT_IVM_VDDP3_OV → Passing overvoltage to VDDP3 pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371310    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDP3_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVDDP3Pin
    [Documentation]    To perform FIT_IVM_VDDP3_UV → Passing undervoltage to VDDP3 pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371304    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VDDP3_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingOvervoltageToVEXTPin
    [Documentation]    To perform FIT_IVM_VEXT_OV → Passing overvoltage to VEXT pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371624    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEXT_OverVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_VoltageSupervisionErrorDTC_PassingUndervoltageToVEXTPin
    [Documentation]    To perform FIT_IVM_VEXT_UV → Passing undervoltage to VEXT pin
    ...     to trigger Voltage Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371623    FID-2873326
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.VEXT_UnderVoltage}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_VoltageMonitoringFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_BackupClockAliveAlarm
    [Documentation]    To perform FIT_CLKM_BACKUP_MONTST_TC_E → Backup Clock Alive Alarm
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371306    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.BACKUP_MONTST_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_BackupClockFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_BackupClockOutOfRangeAlarmHighFreq
    [Documentation]    To perform FIT_CLKM_OSCBACK_HIGFREQ_TC_E → Back-up clock out-of-range alarm
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371308    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCBACK_HIGFREQ_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_BackupClockFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_BackupClockOutOfRangeAlarmLowFreq
    [Documentation]    To perform FIT_CLKM_OSCMAIN_LOWFREQ_TC_E → Back-up clock out-of-range alarm
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371305    FID-2873328
    # # Clear DTC command
    # prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    # Sleep    5s
    # prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCBACK_LOWFREQ_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_BackupClockFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_OSCClockFrequencyOutOfRangeHighFreq
    [Documentation]    To perform FIT_CLKM_OSCMAIN_HIGFREQ_TC_E → OSC clock frequency out of range
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371307    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt.safety
    # prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCMAIN_HIGFREQ_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OSCClockFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_OSCClockFrequencyOutOfRangeLowFreq
    [Documentation]    To perform FIT_CLKM_OSCMAIN_LOWFREQ_TC_E → OSC clock frequency out of range
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371309    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt.safety
    # prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.OSCMAIN_LOWFREQ_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OSCClockFailure_Resp}
    prj.sut.power cycle
    Sleep    10s

EnvD_SysQual_Diagnostic_ClockSupervisionErrorDTC_PeripheralPLLDCOLossOfLockEvent
    [Documentation]    To perform FIT_CLKM_PERPLL0_LOSSOFLOCK_TC_E→ Peripheral PLL DCO loss of lock event
    ...     to trigger Clock Supervision error and DTC
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371303    FID-2873328
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt.safety
    # prj.sut.safety.wakeup
    prj.sut.safety.setUTFmode
    prj.sut.safety.injectandverify.withreset.withoutresponse    ${sut.safety.PERPLL0_LOSSOFLOCK_TC_E}
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PLLLossOfLockFailure_Resp}
    prj.sut.power cycle
    Sleep    10s


*** Keywords ***
Debug Aurix Flashing
    [Documentation]    Calling the function to flash debug version

    #  switch off debug board and power cycle before aurix flashing
    prj.sut.usb toggle debug board switch Off &Watchdog/DNL ON

    # Close Remote Debug Board program for FlashGUI to start

    IF    "${PI_Release}" == "true"
      Set Global Variable    ${Aurix_Debug_FolderPath}    ${sut.auto_flash.AurixDebug_PI_RELEASE_PATH}
    ELSE
      Set Global Variable    ${Aurix_Debug_FolderPath}    ${sut.auto_flash.AurixDebug_PI_Nightly_PATH}
    END

    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_EXIT
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_CLOSE
    Close DebugBoard RemoteControl
    prj.sut.power cycle
    prj.sut.can.simulation.Stop
    Debug.Aurix.Flashing    ${AURIXDEBUG_VERSION}    ${AURIXDEBUG_URL}    ${KDS_FLASH}    ${Aurix_Debug_FolderPath}

Normal Aurix Flashing
    [Documentation]    Calling the function to flash NORMAL version
    # Flash back to HSM enable sw
    ${Status}    Run keyword and Return Status
    ...    Aurix.Flashing.Same.Software    true    true
    IF    ${Status} == True
       Log to console   Aurix normal flashing is successful
    ELSE
       Log to console  Aurix flashing is unsuccessful
    END
