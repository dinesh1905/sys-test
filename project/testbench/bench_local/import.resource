*** Settings ***
Documentation    Import libraries contained within 'project.testbench.default'

Library  %{BITS_PLATFORM_INSTALL_PATH}/interfaces/robotframework/bits_platform.py  log_to_console=${False}  AS  bits_platform

Library  ./power/keywords.py        AS    prj.testbench.power
Library  ./audio/input/keywords.py  AS    prj.testbench.audio.input
Library  ./tuner/am/keywords.py     AS    prj.testbench.tuner.am
Library  ./tuner/dab/keywords.py    AS    prj.testbench.tuner.dab
Library  ./tuner/fm/keywords.py     AS    prj.testbench.tuner.fm
Library  ./tuner/rds/keywords.py    AS    prj.testbench.tuner.rds
Library  ./relays/keywords.py       AS    prj.testbench.relays
Library  ./video/keywords.py        AS    prj.testbench.video
Library  ./robotarm/keywords.py     AS    prj.testbench.robotarm

Resource    ./process/process.resource
