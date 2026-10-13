*** Settings ***
Documentation     Import libraries contained within 'project.tests' component.

# ## Setup/Teardown modules ## #
Resource    ${TAF_PATH}/project/test/setups.resource
Resource    ${TAF_PATH}/project/test/teardowns.resource

# Library    ${TAF_PATH}/project/test/suites/autoflash/auto_flash.py
