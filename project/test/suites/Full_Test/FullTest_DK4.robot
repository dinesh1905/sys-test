*** Settings ***

Documentation       Full Test for all Modules SysTest
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          run keywords    setups.Set Up Test Case    prj.sut.diag.SetVehicleSpeedToZero
Test Teardown       run keywords    teardowns.Tear Down Test Case    prj.sut.diag.SetVehicleSpeedToZero


*** Variables ***
${COUNTERPLUS1}        1
${AURIXDEBUG_VERSION}    ${AURIXDEBUG_VERSION}
${AURIXDEBUG_URL}    ${AURIXDEBUG_URL}
${KDS_FLASH}    ${KDS_FLASH}
${AURIX_VERSION}    ${AURIX_VERSION}
${SOC_VERSION}    ${SOC_VERSION}
${SAIL_VERSION}    ${SAIL_VERSION}


*** Test Cases ***
EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListVWSparePartNumber(0x0611)ExtendedSession
    [Documentation]    To read the Slave List VW spare part number
    [Tags]    CustomerDiagnostic    TCID-578686

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.SlaveListVWSparePartNumber_Req}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    The Virtual machineNode address bytes have been confirmed!
    ${response}    prj.sut.can.diag.get
    @{bytes}       Split String    ${response}

    Log To Console    Complete Response: ${bytes}

    # Remove positive response bytes : 62 06 11
    @{data_bytes}    Get Slice From List    ${bytes}    3

    # Virtual Machine 1
    # 02 68 + 11 bytes spare part number

    @{vm1_spare}    Get Slice From List    ${data_bytes}    2    13
    ${vm1_len}    Get Length    ${vm1_spare}
    Log To Console    VM1 Spare Part Bytes: ${vm1_spare}
    Log To Console    VM1 Spare Part Length: ${vm1_len}

    IF    ${vm1_len} != 11
        Set Test Status To Fail    error_type=Failure
        ...    info_text=VM1 spare part number is not 11 bytes
    END
    # Virtual Machine 2

    # second block starts after:
    # 02 69 + 11 bytes = 13 bytes total

    @{vm2_spare}    Get Slice From List    ${data_bytes}    15    26
    ${vm2_len}    Get Length    ${vm2_spare}
    Log To Console    VM2 Spare Part Bytes: ${vm2_spare}
    Log To Console    VM2 Spare Part Length: ${vm2_len}
    IF    ${vm2_len} != 11
        Set Test Status To Fail    error_type=Failure
        ...    info_text=VM2 spare part number is not 11 bytes
    END
    Log To Console    Both subsystem node addresses reported 11-byte VW spare part numbers successfully

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListVWECUHardwareVersionNumber(0x0613)ExtendedSession
    [Documentation]    To read the Slave_list_VW_ecu_hardware_version_number
    [Tags]    CustomerDiagnostic    TCID-578874
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.SlaveListVWECUHardwareVersionNumber}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveListVWECUHardwareVersionNumber_positiveResponse}
    ${response}    prj.sut.can.diag.get
    Sleep    2s
    @{bytes}       Split String    ${response}
    Log To Console    Complete Response: ${bytes}
    @{databytes}    Get Slice From List    ${bytes}    3
    Log To Console    Response bytes are ${databytes}

    # VM1 Hardware Version
    # Output for Sub system Node 1
    # 02 68 48 30 33

    @{vm1_hw_hex}    Get Slice From List    ${databytes}    4    7
    ${vm1_hw_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $vm1_hw_hex)
    Log To Console    VM1 Hardware Version: ${vm1_hw_ascii}
    IF    "${vm1_hw_ascii}" == ""
        Set Test Status To Fail    error_type=Failure
        ...    info_text=VM1 Hardware Version not reported
    END

    # VM2 Hardware Version
    # 02 69 48 30 33
    @{vm2_hw_hex}    Get Slice From List    ${databytes}    9    12
    ${vm2_hw_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $vm2_hw_hex)
    Log To Console    VM2 Hardware Version: ${vm2_hw_ascii}
    IF    "${vm2_hw_ascii}" == ""
        Set Test Status To Fail    error_type=Failure
        ...    info_text=VM2 Hardware Version not reported
    END
    # Final verification
    IF    "${vm1_hw_ascii}" == "${vm2_hw_ascii}"
        Log To Console    ECU Hardware Version reported successfully for both subsystem node addresses
    ELSE
        Set Test Status To Fail    error_type=Failure
        ...    info_text=Hardware Version mismatch between subsystem node addresses
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_IpNdpCacheListDefaultSession

    [Documentation]    To read the IpNDP Cache list data using DID 22 01 42
    [Tags]    CustomerDiagnostic    TCID-540228

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.IpNdpCacheList_Req}
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{IpNDP_bytes}    Get Slice From List    ${bytes}    3
    Log To Console    response bytes are ${IpNDP_bytes}
    ${payload_length}    Get Length    ${IpNDP_bytes}
    Log To Console    Payload Length is ${payload_length}

    # Verify length is multiple of 24
    ${remainder}    Evaluate    ${payload_length} % 24
    Should Be Equal As Integers    ${remainder}    0
    # Calculating number of IpNdp cache list entries

    ${IpNDP_count}    Evaluate    ${payload_length} // 24
    Log To Console    Total IpNdp Cache List Entries is ${IpNDP_count}

    # Optional validation
    Should Be True    ${IpNDP_count} > 0
    Log To Console    The IpNDP cache entries are more than 1
    # Report each 24-byte block
    FOR    ${index}    IN RANGE    ${IpNDP_count}

         ${start}    Evaluate    ${index} * 24
         ${end}    Evaluate    ${start} + 24
         @{cache_entry}    Get Slice From List    ${IpNDP_bytes}    ${start}    ${end}
         Log To Console    IpNdp Cache List ${index + 1}: ${cache_entry}
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListVWSoftwareVersionNumber(0x0612)ExtendedSession
    [Documentation]    To read the Slave List VW Software Version Number
    [Tags]    CustomerDiagnostic    TCID-578779
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    2s
    prj.sut.diag.SetVehicleSpeedToZero
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SlaveListVWSoftwareVersionNumberReq}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveListVWSoftwareVersionNumberResp}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    Both Subsystem Node address are present
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{SoftwareVersionNumber}    Get Slice From List    ${bytes}    3
    Log To Console    The software version number bytes are ${SoftwareVersionNumber}

    #Software version number for node address 02 68

    ${SWN1}    Get Slice From List    ${SoftwareVersionNumber}    4    8
    Log To Console    ${SWN1}
    ${SoftwareVersionNumber1_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $SWN1)
    Log To Console    SW Version number for subsystem 1 is: ${SoftwareVersionNumber1_ascii}

    # Software version number for node address 02 69

    ${SWN2}    Get Slice From List    ${SoftwareVersionNumber}    10    14
    Log To Console    ${SWN1}
    ${SoftwareVersionNumber2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $SWN2)
    Log To Console    SW Version number for subsystem 2 is: ${SoftwareVersionNumber2_ascii}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListVWHardwareVersionNumber(0x0614)DefaultSession
    [Documentation]    To get the VW Hardware version number for both subsystem nodes in default session
    [Tags]    CustomerDiagnostic    TCID-578875
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SlaveListVWHardwareVersionNumberReq}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveListVWHardwareVersionNumberResp}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    Both Subsystem Node address are present
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{HardwareVersionNumber}    Get Slice From List    ${bytes}    3
    Log To Console    The SlaveList VW Hardware Version Number bytes are: ${HardwareVersionNumber}
    #Hardware version number for node address 02 68

    ${HWN1}    Get Slice From List    ${HardwareVersionNumber}    4    13
    Log To Console    ${HWN1}
    ${HardwareVersionNumber1_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $HWN1)
    Log To Console    HW Version number for subsystem 1 is: ${HardwareVersionNumber1_ascii}

    # Hardware version number for node address 02 69

    ${HWN2}    Get Slice From List    ${HardwareVersionNumber}    17    26
    Log To Console    ${HWN2}
    ${HardwareVersionNumber2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $HWN2)
    Log To Console    HW Version number for subsystem 2 is: ${HardwareVersionNumber2_ascii}

    IF    '${HardwareVersionNumber1_ascii}' != '1T6907701' or '${HardwareVersionNumber2_ascii}' != '1T6907701'
        Set Test Status To Fail
    ...    error_type=Failure
    ...    info_text=For subsystems, Hardware version do not match!
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListVWHardwareVersionNumber_ExtendedSession
    [Documentation]    To get the VW Hardware version number for both subsystem nodes in Extend session
    [Tags]    CustomerDiagnostic    TCID-578883
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SlaveListVWHardwareVersionNumberReq}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveListVWHardwareVersionNumberResp}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    Both Subsystem Node address are present
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{HardwareVersionNumber}    Get Slice From List    ${bytes}    3
    Log To Console    The SlaveList VW Hardware Version Number bytes are: ${HardwareVersionNumber}
    # Hardware version number for node address 02 68

    ${HWN1}    Get Slice From List    ${HardwareVersionNumber}    4    13
    Log To Console    ${HWN1}
    ${HardwareVersionNumber1_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $HWN1)
    Log To Console    HW Version number for subsystem 1 is: ${HardwareVersionNumber1_ascii}

    # Hardware version number for node address 02 69

    ${HWN2}    Get Slice From List    ${HardwareVersionNumber}    17    26
    Log To Console    ${HWN2}
    ${HardwareVersionNumber2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $HWN2)
    Log To Console    HW Version number for subsystem 2 is: ${HardwareVersionNumber2_ascii}

    IF    '${HardwareVersionNumber1_ascii}' != '1T6907701' or '${HardwareVersionNumber2_ascii}' != '1T6907701'
        Set Test Status To Fail
    ...    error_type=Failure
    ...    info_text=For subsystems, Hardware version do not match!
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListECUSerialNumber(0x0615)DefaultSession
    [Documentation]    To get the Slavelist ECU Serial number for both subsystem nodes in default session
    [Tags]    CustomerDiagnostic    TCID-578884
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SlaveListECUSerialNumberReq}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveListECUSerialNumberResp}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    Both Subsystem Node address are present
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{ECUSerialNumber}    Get Slice From List    ${bytes}    3
    Log To Console    The SlaveList ECU Serial Number bytes are: ${ECUSerialNumber}
    # ECU Serial number for node address 02 68

    ${ECN1}    Get Slice From List    ${ECUSerialNumber}    4    24
    Log To Console    ECU serial number bytes for subsystem node 1 is: ${ECN1}
    ${ECUSerialNumber1_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECN1)
    Log To Console    ECU Serial number for subsystem 1 is: ${ECUSerialNumber1_ascii}

    # ECU Serial number for node address 02 69

    ${ECN2}    Get Slice From List    ${ECUSerialNumber}    26    46
    Log To Console    ECU serial number bytes for subsystem node 2 is: ${ECN2}
    ${ECUSerialNumber2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECN2)
    Log To Console    ECU Serial number for subsystem 2 is: ${ECUSerialNumber2_ascii}

    IF    '${ECUSerialNumber1_ascii}' != 'BPA08528052412340001' or '${ECUSerialNumber2_ascii}' != 'BPA08528052412340001'
        Set Test Status To Fail
    ...    error_type=Failure
    ...    info_text=For subsystems, ECU Serial Number do not match!
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListECUSerialNumber_ExtendedSession
    [Documentation]    To get the Slavelist ECU Serial number for both subsystem nodes in default session
    [Tags]    CustomerDiagnostic    TCID-581658
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SlaveListECUSerialNumberReq}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveListECUSerialNumberResp}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    Both Subsystem Node address are present
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{ECUSerialNumber}    Get Slice From List    ${bytes}    3
    Log To Console    The SlaveList ECU Serial Number bytes are: ${ECUSerialNumber}
    #ECU Serial number for node address 02 68

    ${ECN1}    Get Slice From List    ${ECUSerialNumber}    4    24
    Log To Console    ECU serial number bytes for subsystem node 1 is: ${ECN1}
    ${ECUSerialNumber1_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECN1)
    Log To Console    ECU Serial number for subsystem 1 is: ${ECUSerialNumber1_ascii}

    # ECU Serial number for node address 02 69

    ${ECN2}    Get Slice From List    ${ECUSerialNumber}    26    46
    Log To Console    ECU serial number bytes for subsystem node 2 is: ${ECN2}
    ${ECUSerialNumber2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECN2)
    Log To Console    ECU Serial number for subsystem 2 is: ${ECUSerialNumber2_ascii}

    IF    '${ECUSerialNumber1_ascii}' != 'BPA08528052412340001' or '${ECUSerialNumber2_ascii}' != 'BPA08528052412340001'
        Set Test Status To Fail
    ...    error_type=Failure
    ...    info_text=For subsystems, ECU Serial Number do not match!
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListVWFAZITidentificationString(0x016)_DefaultSession
    [Documentation]    To get the Slave List VW FAZIT Identification String for both subsystem nodes in default session
    [Tags]    CustomerDiagnostic    TCID-578893
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SlaveListVWFAZITidentificationStringReq}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveListVWFAZITidentificationStringResp}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    Both Subsystem Node address are present
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{FAZITidentificationString}    Get Slice From List    ${bytes}    3
    Log To Console    The SlaveList ECU Serial Number bytes are: ${FAZITidentificationString}

    # FAZIT Identification String for node address 02 68

    ${ECUproductionPlantNumber}    Get Slice From List    ${FAZITidentificationString}    4    11
    ${FAZITidentificationString_ECUproductionPlantNumber_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECUproductionPlantNumber)
    Log To Console    FAZIT Identification String: ECU production Plant Number is ${FAZITidentificationString_ECUproductionPlantNumber_ascii}

    ${ECUManufacturingDate}    Get Slice From List    ${FAZITidentificationString}    11    19
    ${FAZITidentificationString_ECUManufacturingDate_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECUManufacturingDate)
    Log To Console    FAZIT Identification String: ECU manufacturing Date is ${FAZITidentificationString_ECUManufacturingDate_ascii}

    ${ECUProductionTestSystemNumber}    Get Slice From List    ${FAZITidentificationString}    19    23
    ${FAZITidentificationString_ECUProductionTestSystemNumber_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECUProductionTestSystemNumber)
    Log To Console    FAZIT Identification String: ECU production test system number is ${FAZITidentificationString_ECUProductionTestSystemNumber_ascii}

    ${ConsecutiveSupplierNumber}    Get Slice From List    ${FAZITidentificationString}    23    27
    ${FAZITidentificationString_ConsecutiveSupplierNumber_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ConsecutiveSupplierNumber)
    Log To Console    FAZIT Identification String: Consecutive Supplier number is ${FAZITidentificationString_ConsecutiveSupplierNumber_ascii}

        # FAZIT Identification String for node address 02 69

    ${ECUproductionPlantNumber2}    Get Slice From List    ${FAZITidentificationString}    29    36
    ${FAZITidentificationString_ECUproductionPlantNumber2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECUproductionPlantNumber2)
    Log To Console    FAZIT Identification String: ECU production Plant Number for subsystem 2 is ${FAZITidentificationString_ECUproductionPlantNumber2_ascii}

    ${ECUManufacturingDate2}    Get Slice From List    ${FAZITidentificationString}    36    44
    ${FAZITidentificationString_ECUManufacturingDate2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECUManufacturingDate2)
    Log To Console    FAZIT Identification String: ECU manufacturing Date for subsystem 2 is ${FAZITidentificationString_ECUManufacturingDate2_ascii}

    ${ECUProductionTestSystemNumber2}    Get Slice From List    ${FAZITidentificationString}    44    48
    ${FAZITidentificationString_ECUProductionTestSystemNumber2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ECUProductionTestSystemNumber2)
    Log To Console    FAZIT Identification String: ECU production test system number for subsystem 2 is ${FAZITidentificationString_ECUProductionTestSystemNumber2_ascii}

    ${ConsecutiveSupplierNumber2}    Get Slice From List    ${FAZITidentificationString}    48    52
    ${FAZITidentificationString_ConsecutiveSupplierNumber2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $ConsecutiveSupplierNumber2)
    Log To Console    FAZIT Identification String: Consecutive Supplier number is ${FAZITidentificationString_ConsecutiveSupplierNumber2_ascii}

    # Comparison between subsystem 1 and subsystem 2

    IF    '${FAZITidentificationString_ECUproductionPlantNumber_ascii}' != '${FAZITidentificationString_ECUproductionPlantNumber2_ascii}'
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text=ECU Production Plant Number mismatch between subsystem nodes
    END

    IF    '${FAZITidentificationString_ECUManufacturingDate_ascii}' != '${FAZITidentificationString_ECUManufacturingDate2_ascii}'
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text=ECU Manufacturing Date mismatch between subsystem nodes
    END

    IF    '${FAZITidentificationString_ECUProductionTestSystemNumber_ascii}' != '${FAZITidentificationString_ECUProductionTestSystemNumber2_ascii}'
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text=ECU Production Test System Number mismatch between subsystem nodes
    END

    IF    '${FAZITidentificationString_ConsecutiveSupplierNumber_ascii}' != '${FAZITidentificationString_ConsecutiveSupplierNumber2_ascii}'
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text= Consecutive Supplier number mismatch between subsystem nodes
    END
    Log To Console    FAZIT Identification String values match for both subsystem nodes

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveListVWsystemNameOrEngineType_DefaultSession
    [Documentation]    To read the SlaveList VW system name or Engine type in default session
    [Tags]    CustomerDiagnostic    TCID-579796
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SlaveListVWsystemNameOrEngineTypeReq}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveListVWsystemNameOrEngineTypeResp}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    Both Subsystem Node address are present
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{SlaveListVWsystemNameOrEngineType}    Get Slice From List    ${bytes}    3
    Log To Console    The response bytes for SlaveList VW system Name/Engine Type is ${SlaveListVWsystemNameOrEngineType}

    # Slavelist VW system name/Engine type for node 02 68

    ${SN_ET1}    Get Slice From List    ${SlaveListVWsystemNameOrEngineType}    4    13
    Log To Console    ${SN_ET1}
    ${SystemName_EngineTypeNode1_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $SN_ET1)
    Log To Console    SlaveListVWsystemNameOrEngineType for subsystem 1 is: ${SystemName_EngineTypeNode1_ascii}

    # Slavelist VW system name/Engine type for node 02 69

    ${SN_ET2}    Get Slice From List    ${SlaveListVWsystemNameOrEngineType}    19    28
    Log To Console    ${SN_ET2}
    ${SystemName_EngineTypeNode2_ascii}    Evaluate    ''.join(chr(int(x,16)) for x in $SN_ET2)
    Log To Console    SlaveListVWsystemNameOrEngineType 2 is: ${SystemName_EngineTypeNode2_ascii}
    IF    '${SystemName_EngineTypeNode1_ascii}' != 'MAASBLADE' or '${SystemName_EngineTypeNode2_ascii}' != 'MAASBLADE'
        Set Test Status To Fail
    ...    error_type=Failure
    ...    info_text=For subsystems, SystemName_EngineTypeNode do not match!
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveComponentListDatabusIdentification_DefaultSession
    [Documentation]    To get the Slave component list for databus identification using DID 22 06 1B
    [Tags]    CustomerDiagnostic    TCID-579798
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListDatabusIdentificationReq}
    prj.sut.diag.checkbyte    ${sut.diag.SlaveComponentListDatabusIdentificationResp}
    ${Response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${Response}
    @{SlaveComponentListDatabusIdentification}    Get Slice From List    ${bytes}    3
    Log To Console    The databus identification bytes are ${SlaveComponentListDatabusIdentification}

    # BUS ID 1
    @{BusID1_hex}    Get Slice From List    ${SlaveComponentListDatabusIdentification}    0    2
    ${BusID1}    Evaluate    ' '.join(x for x in $BusID1_hex)
    Log To Console    Bus ID 1 is: ${BusID1}
    IF    '${BusID1}' == ''
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text=Bus ID 1 not reported
    END

    # Bus ID 2
    @{BusID2_hex}    Get Slice From List    ${SlaveComponentListDatabusIdentification}    2    4
    ${BusID2}    Evaluate    ' '.join(x for x in $BusID2_hex)
    Log To Console    Bus ID 2 is: ${BusID2}
    IF    '${BusID2}' == ''
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text=Bus ID 2 not reported
    END

    # Final Validation
    Log To Console    Both Bus IDs are reported successfully

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SlaveComponentListECUIdentificationVirtualMachines_DefaultSession
    [Documentation]    To read both the virtual machines for MaasBlade
    [Tags]    CustomerDiagnostic    TCID-579799
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag._SlaveComponentListECUIdentificationVirtualMachinesReq}
    prj.sut.diag.checkbyte    ${sut.diag._SlaveComponentListECUIdentificationVirtualMachinesResp}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine1}
    prj.sut.diag.checkbyte    ${sut.diag.SubsystemNodeAddress_VirtualMachine2}
    Log To Console    Both the susbsystems/virtual machines for MaasBlade is present