*** Settings ***
Documentation    Section to import config specific libraries.

Resource    ${TAF_PATH}/project/sut/all_sut/libraries/sw_flashing/sw_flashing.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/dlt/dlt.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/canoe/can.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/diagnostic/diagnostic.resource
Resource     ${TAF_PATH}/project/sut/all_sut/libraries/reliability/reliability.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/safety/safety.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/power/Power.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/audio/audio.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/com/com.resource
Resource    ${TAF_PATH}/project/sut/all_sut/libraries/soc/soc.resource

Library    ./reliability/sequencer.py
Library    ./canoe/customcanoeLib.py

