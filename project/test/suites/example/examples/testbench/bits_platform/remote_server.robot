*** Settings ***
Documentation  Connect to BITS-Platform remotely using robotremoteserver
...  use case: rf running on linux machine and BITS-Platform on windows machine/vm

Library       Remote    http://${ADDRESS}:${PORT}  AS  bitsplatform0
Library       Remote    http://${ADDRESS1}:${PORT1}  AS  bitsplatform1
Library       Collections


*** Variables ***
${ADDRESS}    HI-C-0005L
${PORT}       8270
${ADDRESS1}    HI-C-0005L
${PORT1}       8271


*** Test Cases ***
Log BP Version
   [Documentation]  first steps using robotremoteserver
   ${version} =  bitsplatform0.get version
   Log To Console   ===>${version}
   bitsplatform0.Rfgenerator Set Parameter    1    frq    99.9

   ${version} =  bitsplatform1.get version
   Log To Console   ===>${version}
   bitsplatform1.Rfgenerator Set Parameter    1    frq    88.8
