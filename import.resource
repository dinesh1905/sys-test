*** Settings ***
Documentation    Central import file including the main libraries needed for
...              test development and execution with BITS:RF TA-Framework

# ## Robotframework standard libraries ## #
Library     OperatingSystem
Library     Process
Library     Collections
Library     String
Library     BuiltIn
Library     DateTime
Library     Reserved

# ## RobotFramework AIO libraries ## #
Library     RobotFramework_TestsuitesManagement    AS    testsuites

# ## TA-Framework library imports ## #
Resource    ${TAF_PATH}/generic/import.resource
Resource    ${TAF_PATH}/project/import.resource
