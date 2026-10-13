*** Settings ***
Documentation     Import libraries contained within 'project' component.

# ## TA-Framework library imports ## #
Resource    ${TAF_PATH}/project/test/import.resource
Resource    ${TAF_PATH}/project/testbench/import.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/import.resource
