*** Settings ***
Documentation    Import libraries contained within 'project.testbench.bench_remote'

Library       Remote    http://${ADDRESS}:${PORT}  AS  bits_platform

Library    ./power/power.py    AS    prj.testbench.power
Library    ./audio/audio_input.py    AS    prj.testbench.audio.input
Library    ./tuner/tuner_am.py    AS    prj.testbench.tuner.am
Library    ./tuner/tuner_dab.py    AS    prj.testbench.tuner.dab
Library    ./tuner/tuner_fm.py    AS    prj.testbench.tuner.fm
Library    ./tuner/tuner_rds.py    AS    prj.testbench.tuner.rds
Library    ./relays/relays.py    AS    prj.testbench.relays
Library    ./video/video.py    AS    prj.testbench.video
Library    ./robotarm/robotarm.py    AS    prj.testbench.robotarm


*** Variables ***
# Details of Remote instance of BITS-Platform interface library
${ADDRESS}    YOUR.BP.REMOTE
${PORT}       8270
