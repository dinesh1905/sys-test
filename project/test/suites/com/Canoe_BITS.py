import socket
import re
import os
import time

from subprocess import Popen

# import PythonExtensionsCollection
# pip install PythonExtensionsCollection
from PythonExtensionsCollection.String.CString import CString

# import Robotframework API
from robot.api.deco import keyword, library # required when using @keyword, @library decorators
from robot.libraries.BuiltIn import BuiltIn

@keyword
def rbs_wait_for_test_verdict(self, unit=None, timeout=300):
        """
        Waits for CANoe test verdict and returns the test result (PASS/FAIL).\n
        This function should be called after rbs_start_test().\n
        It monitors for OnTestVerdictFail and OnTestStop events to determine test outcome.\n
        = Interfaces =\n
        IN_1: ``unit`` (str): Number to select the device.\n
        IN_2: ``timeout`` (numeric): Timeout in seconds to wait for test verdict (default: 300sec).\n
        OUT_1: ``ack`` (bool): ``True`` in case of successful computation;
                            ``False`` in case of errors/timeout; ``None`` in case of exceptions.\n
        OUT_2: ``verdict`` (str): Test verdict - "PASS" if test passed, "FAIL" if test failed,
                                "TIMEOUT" if no verdict received within timeout,
                                "ERROR" if error occurred.\n
        OUT_3: ``event_data`` (str): Raw event data received from BITS-Platform.
        """
       
        self.__log(True, "Wait for BITS-Platform RBS [" + str(unit) + "] test verdict (timeout: " +
                str(timeout) + " seconds)")
       
        try:
            timeout = int(timeout)
        except (TypeError, ValueError) as ex:
            self.__log(False, "Invalid timeout value: " + str(ex))
            return False, "ERROR", str(ex)
       
        # Track events
        verdict_fail_detected = False
        event_data_list = []
       
        # Base notification pattern
        notification_base = "RBS TOOL_" + str(unit) + " EVENT NOTICE RESULT"
       
        self.__log(True, "Listening for notifications matching: '" + notification_base + "'")
       
        # Start time for timeout tracking
        import time
        start_time = time.time()
       
        # Main monitoring loop - wait for OnTestStop as completion signal
        while True:
           
            # Calculate remaining timeout
            elapsed_time = time.time() - start_time
            remaining_timeout = timeout - elapsed_time
           
            # Check if timeout expired
            if remaining_timeout <= 0:
                self.__log(False, "Timeout expired after " + str(timeout) + " seconds")
                break
           
            # Listen for any RBS event notification
            try:
                self.client_socket.settimeout(1)
                data_received = self.client_socket.recv(BUFFER_SIZE)
                data_received = data_received.decode("utf-8").strip()
               
                # Log every received message for debugging
                self.__log(True, "Received data: " + data_received)
               
                # Check if this is an RBS event notification
                if notification_base in data_received:
                    event_data_list.append(data_received)
                    self.__log(True, "Matched RBS event notification")
                   
                    # Check for OnTestVerdictFail (CORRECTED - was OnVerdictFail)
                    if "OnTestVerdictFail" in data_received:
                        verdict_fail_detected = True
                        self.__log(False, "BITS-Platform RBS [" + str(unit) + "] OnTestVerdictFail detected")
                   
                    # Check for OnTestStop - this signals test completion
                    if "OnTestStop" in data_received:
                        self.__log(True, "BITS-Platform RBS [" + str(unit) + "] OnTestStop detected")
                       
                        # Determine final verdict based on whether we saw OnTestVerdictFail
                        if verdict_fail_detected:
                            verdict = "FAIL"
                            self.__log(False, "BITS-Platform RBS [" + str(unit) + "] test verdict: FAIL")
                        else:
                            verdict = "PASS"
                            self.__log(True, "BITS-Platform RBS [" + str(unit) + "] test verdict: PASS")
                       
                        # Combine all event data
                        event_data = "\n".join(event_data_list)
                       
                        return True, verdict, event_data
                else:
                    # Log non-matching messages
                    if data_received:
                        self.__log(True, "Received non-RBS message: " + data_received[:100])
           
            except socket.timeout:
                # No data received in this iteration, continue waiting
                continue
            except socket.error as ex:
                # Socket error occurred
                self.__log(False, "Socket error while waiting for verdict: " + str(ex))
                return False, "ERROR", str(ex)
       
        # Timeout occurred
        self.__log(False, "Timeout waiting for test verdict from BITS-Platform RBS [" + str(unit) +
                "] after " + str(timeout) + " seconds")
       
        if verdict_fail_detected:
            # We saw OnTestVerdictFail but never got OnTestStop
            event_data = "\n".join(event_data_list) if event_data_list else "OnTestVerdictFail received but OnTestStop not received"
            self.__log(False, "Received OnTestVerdictFail but no OnTestStop - returning TIMEOUT")
            return False, "TIMEOUT", event_data
        else:
            self.__log(False, "No events received - returning TIMEOUT")
            return False, "TIMEOUT", "No test completion event (OnTestStop) received within timeout period"