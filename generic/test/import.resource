*** Settings ***
Documentation     Import libraries contained within 'generic.test' component.

# ## Setup/Teardown modules ## #
Library    ${TAF_PATH}/generic/test/setups.py  AS  setups
Library    ${TAF_PATH}/generic/test/teardowns.py  AS  teardowns
