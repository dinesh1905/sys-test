*** Settings ***
Documentation       Example script to set and get voltage
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults
Library    OperatingSystem

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager
Library    Process
Library    OperatingSystem
Library    SerialLibrary
Library       ${TAF_PATH}/project/test/suites/example/Image_read.py
# Test Automation Framework
Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       run keywords    teardowns.Tear Down Test Case    delete raw and generated camera input images    delete raw and generated camera input video folders
#Test Teardown       run keywords    teardowns.Tear Down Test Case    delete raw and generated camera input images
*** Test Cases ***
EnvD_SysQual_Video_InputCamera_4camera-HSYNC, VSYNC, and DEN
    [Documentation]    1. Connect 4x Camera
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-1039542     TCID-246029    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_CameraInput_4camera_HsyncVsyncDen
    [Documentation]    1. Connect 4x camera from VWN as per HSI requirement 1616898 to MaaS blade camera inputs,
    ...     the Cameras specification from customer is store in link on HSI ID 1646900.
    ...    2Verify the camera video inputs by trigger the camera snapshot
    ...     Read the saving data via PC to MaaS blade, verfiy the video content.
    [Tags]    INPUTCAMERA    FID-1039542    TCID-416192    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_Video_InputCamera_4camera-HSVLsupport
    [Documentation]    1. Connect 4x Camera
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-1039506,1039537    TCID-246031    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_CameraInput_HSVL_GSML1And2
    [Documentation]    Connect 4x camera from VWN as per HSI requirement 1616898 to MaaS blade camera inputs,
    ...     the Cameras specification from customer is store in link on HSI ID 1646900.
    ...    2. Verify the camera video inputs by trigger the camera snapshot and save the video input data to the files in UFS.
    ...     Read the saving video data via PC to MaaS blade, verfiy the video content.
    [Tags]    INPUTCAMERA    FID-1039506    TCID-416185    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_CameraInput_4camera_HSVLsupport
    [Documentation]    Connect 4x camera from VWN as per HSI requirement 1616898 to MaaS Blade camera inputs,
    ...     the Cameras specification from customer is store in link on HSI ID 1646900.
    ...    2. Verify the camera video inputs by trigger the camera snapshot and save the video input data to the files in UFS.
    ...     Read the saving video data via PC to MaaS Blade, verify the video content
    [Tags]    INPUTCAMERA    FID-1039537    TCID-525512    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_Video_InputCamera_4camera-pixel resolution
    [Documentation]    1. Connect 4x Camera
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-1039536    TCID-246032    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_CameraInput_PixelResolution_SpecCompliance
    [Documentation]    Connect 4x Camera
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-1592409,1039536    TCID-416195    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Sleep    1s
    initial condition for camera test    172.21.0.10    22    root    maasdev
    ${output}=    FPS command to run camera
    FPS resolution validation    ${output}

EnvD_SysQual_Video_InputCamera_4camera-camera resolution
    [Documentation]    Connect 4x Camera
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-1156042    TCID-246033    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_CameraInput_Resolution_SpecCompliance
    [Documentation]    Connect 4x Camera(video)
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-1156042,1592409    TCID-416196    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    #prj.sut.Power.DTL logs for normal funcational state of DUT
    initial condition for camera test    172.21.0.10    22    root    maasdev
    ${output}=    Command for video dump    ${sut.power.QNXCommand.video_dump}
    Video file check
    Check and recreate directory    raw_video_folder
    ${local_encoded_video_file}=    Copy the video file from device to local
    ${local_path}=    Set Variable
    ...    ${TAF_PATH}/project/config/Camera_Input/raw_video_folder/${local_encoded_video_file}
    ${converted}=    Convert Video To Playable Format    ${local_path}
    Log To Console    Final playable video: ${converted}
    ${result}=    Validate Static Video Allowed    ${converted}
    Validate video dump in camera input    ${result}

EnvD_SysQual_Video_InputCamera_4camera-transmission rate
    [Documentation]    Connect 4x Camera
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-1156041    TCID-246034    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_CameraInput_TransmissionRate_SpecCompliance
    [Documentation]    Connect 4x Camera(video)
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-2382529,2382528,2375126,2375124,2382526,2375123,1156041    TCID-416197    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    #prj.sut.Power.DTL logs for normal funcational state of DUT
    initial condition for camera test    172.21.0.10    22    root    maasdev
    ${output}=    Command for video dump    ${sut.power.QNXCommand.video_dump}
    Video file check
    Check and recreate directory    raw_video_folder
    ${local_encoded_video_file}=    Copy the video file from device to local
    ${local_path}=    Set Variable
    ...    ${TAF_PATH}/project/config/Camera_Input/raw_video_folder/${local_encoded_video_file}
    ${converted}=    Convert Video To Playable Format    ${local_path}
    Log To Console    Final playable video: ${converted}
    ${result}=    Validate Static Video Allowed    ${converted}
    Validate video dump in camera input    ${result}

EnvD_SysQual_CameraInput_Deserializer_CameraAndDisplay
    [Documentation]    Connect 4x Camera
    ...    2. Enter SOC console and request camera info
    [Tags]    INPUTCAMERA    FID-1039401    TCID-416186    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

# EnvD_SysQual_CameraInput_FileSystem_SGMIITransfer
#     [Documentation]    Verification environment :
#     ...    1. Connect 4x cameras to MaaS blade.
#     ...    2. Trigger a software command (check with SW team) that capture the image on 4x cameras and stored into internal flash.
#     ...    3. Retrieve the image that stored in internal flash via software command and transfer to PC via Ethernet port.
#     [Tags]    INPUTCAMERA    FID-1039527    TCID-435426    FULLTEST

EnvD_SysQual_CameraInput_LineConnectionSelfTest_DeserializerAccess
    [Documentation]    Verification environment :
    ...    1. Connect 4x cameras to MaaS blade.
    ...    2. Get the camera info
    [Tags]    INPUTCAMERA    FID-1039401    TCID-435427    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_Video_InputCamera_4camera-link lock status
    [Tags]    INPUTCAMERA    FID-1039545    TCID-246030    FULLTEST
    [Documentation]    Verification environment :
    ...    1. Connect 4x cameras to MaaS blade.
    ...    2. Get the camera info
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_CameraInput_4camera_LinkLockStatus
    [Tags]    INPUTCAMERA    FID-1039545    TCID-416199    FULLTEST
    [Documentation]    Verification environment :
    ...    1. Connect 4x cameras to MaaS blade.
    ...    2. In the CANOE simulation, DTC console, Clear all existing DTC
    ...    DTC Check:Physically short the video lines VI0 (Camera 1,2,3,4) to GND.
    ...    Ensure that the connections are secure and that the lines are properly grounded.
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    # bits_platform.Output Set Digital Signal Value    Camera1_Short_Ground    ON
    # bits_platform.Output Set Digital Signal Value    Camera2_Short_Ground    ON
    # bits_platform.Output Set Digital Signal Value    Camera3_Short_Ground    ON
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    ON
    Sleep    10s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    # prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortToGnd1}
    # prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortToGnd2}
    # prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortToGnd3}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortToGnd4}
    Sleep    2s
    # bits_platform.Output Set Digital Signal Value    Camera1_Short_Ground    OFF
    # bits_platform.Output Set Digital Signal Value    Camera2_Short_Ground    OFF
    # bits_platform.Output Set Digital Signal Value    Camera3_Short_Ground    OFF
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF

EnvD_SysQual_CameraInput_LineConnectionVI1_DeserializerAccess
    [Tags]    INPUTCAMERA    FID-1039545    TCID-416194    FULLTEST
    [Documentation]    Verification environment :
    ...    1. Connect 4x cameras to MaaS blade.
    ...    2. In the CANOE simulation, DTC console, Clear all existing DTC
    ...    DTC Check:Physically short the video lines VI0 (Camera 2) to GND.
    ...    Ensure that the connections are secure and that the lines are properly grounded.
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    #bits_platform.Output Set Digital Signal Value    Camera2_Short_Ground    ON
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    ON
    Sleep    10s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortToGnd2}
    Sleep    2s
    #bits_platform.Output Set Digital Signal Value    Camera2_Short_Ground    OFF
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF

EnvD_SysQual_CameraInput_LineConnectionVI0_DeserializerAccess
    [Tags]    INPUTCAMERA    FID-1039545    TCID-416193    FULLTEST
    [Documentation]    Verification environment :
    ...    1. Connect 4x cameras to MaaS blade.
    ...    2. In the CANOE simulation, DTC console, Clear all existing DTC
    ...    DTC Check:Physically short the video lines VI0 (Camera 1) to GND.
    ...    Ensure that the connections are secure and that the lines are properly grounded.
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    #bits_platform.Output Set Digital Signal Value    Camera1_Short_Ground    ON
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    ON
    Sleep    10s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortToGnd2}
    Sleep    2s
    #bits_platform.Output Set Digital Signal Value    Camera1_Short_Ground    OFF
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF

EnvD_SysQual_CameraInput_LineConnectionVI2_DeserializerAccess
    [Tags]    INPUTCAMERA    FID-1039545    TCID-416190    FULLTEST
    [Documentation]    Verification environment :
    ...    1. Connect 4x cameras to MaaS blade.
    ...    2. In the CANOE simulation, DTC console, Clear all existing DTC
    ...    DTC Check:Physically short the video lines VI0 (Camera 3) to GND.
    ...    Ensure that the connections are secure and that the lines are properly grounded.
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    #bits_platform.Output Set Digital Signal Value    Camera3_Short_Ground    ON
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    ON
    Sleep    10s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortToGnd2}
    Sleep    2s
    #bits_platform.Output Set Digital Signal Value    Camera3_Short_Ground    OFF
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF

EnvD_SysQual_CameraInput_LineConnectionVI3_DeserializerAccess
    [Tags]    INPUTCAMERA    FID-1039545    TCID-416191    FULLTEST
    [Documentation]    Verification environment :
    ...    1. Connect 4x cameras to MaaS blade.
    ...    2. In the CANOE simulation, DTC console, Clear all existing DTC
    ...    DTC Check:Physically short the video lines VI0 (Camera 4) to GND.
    ...    Ensure that the connections are secure and that the lines are properly grounded.
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    #bits_platform.Output Set Digital Signal Value    Camera4_Short_Ground    ON
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    ON
    Sleep    10s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortToGnd2}
    Sleep    2s
    #bits_platform.Output Set Digital Signal Value    Camera4_Short_Ground    OFF
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF