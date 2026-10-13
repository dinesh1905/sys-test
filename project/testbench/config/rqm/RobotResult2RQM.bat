@echo off
ping 127.0.0.1 -n 3 -w 1000 >NUL
@ C:\BITS\RobotFramework\python39\python.exe -m RobotLog2RQM %1 https://rb-alm-14-p.de.bosch.com "CentralComputingRack (QM)" --stream rbx_ccrack_mpci_sys TOA8PG1 AT44aabbccdd %2
@echo on