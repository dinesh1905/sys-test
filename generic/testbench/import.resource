*** Settings ***
Documentation     Import libraries contained within 'generic.testbench' component.

Library    ${TAF_PATH}/generic/testbench/power/keywords.py    AS    testbench.power
Library    ${TAF_PATH}/generic/testbench/audio/input/keywords.py    AS    testbench.audio.input
Library    ${TAF_PATH}/generic/testbench/tuner/am/keywords.py    AS    testbench.tuner.am
Library    ${TAF_PATH}/generic/testbench/tuner/dab/keywords.py    AS    testbench.tuner.dab
Library    ${TAF_PATH}/generic/testbench/tuner/fm/keywords.py    AS    testbench.tuner.fm
Library    ${TAF_PATH}/generic/testbench/tuner/rds/keywords.py    AS    testbench.tuner.rds
Library    ${TAF_PATH}/generic/testbench/relays/keywords.py    AS    testbench.relays
Library    ${TAF_PATH}/generic/testbench/robotarm/keywords.py    AS    testbench.robotarm
