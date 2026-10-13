*** Settings ***
Documentation     Import libraries contained within 'generic.sut' component.

# ## Module libraries ## #
Library    ${TAF_PATH}/generic/sut/media/keywords.py  AS  media
Library    ${TAF_PATH}/generic/sut/system/keywords.py  AS  system
Library    ${TAF_PATH}/generic/sut/tuner/keywords.py  AS  tuner
