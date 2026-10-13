"""
Project specific testbench audio_input module for bench_remote setup. This implements all audio input
commands specifically for this setup using BITS-Platform Audio Input module.
"""

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

MODULE_NAME    = "audio_input.py"
MODULE_VERSION = "0.0.2"
MODULE_DATE    = "23.06.2022"
MODULE         = MODULE_NAME + " v" + MODULE_VERSION + " / " + MODULE_DATE


@library
class audio_input(): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ project.testbench.bench_remote implementation of audio_input module. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = MODULE_VERSION
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    def __init__(self, this_module=MODULE):
        self.this_module = this_module
        self.module_prefix = "prj.testbench.audio.input."
        BuiltIn().log(self.this_module + " entered", "INFO")


    def __del__(self):
        BuiltIn().log(self.this_module + " done.", "INFO")


    @keyword
    def get_audio_source(self, channel_name:str) -> tuple[bool, str]:
        """
        Get the allocated source on the requested audio channel.\n
        = Interfaces = \n
        IN: ``channel_name`` (str): Name of the audio channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``source`` (str): Allocated audio source.
        """

        # init local variables
        ack = None
        source = None

        # implementation using BITS-Platform audio_in module as audio_input test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack, result = bp_lib.input_get_signal_value(sSignalName=channel_name)
        if ack:
            source = result

        return ack, source


    @keyword
    def get_volume(self, channel_name:str) -> tuple[bool, int]: # pylint: disable=W0613:unused-argument
        """
        Get the volume on the requested audio channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the audio channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``volume`` (int): Volume on the requested channel.
        """

        # init local variables
        ack = None
        volume = None

        # no implementation available

        return ack, volume


    @keyword
    def get_track_id(self, channel_name:str) -> tuple[bool, int]:
        """
        Get the id of the active track on the requested audio channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the audio channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``track_id`` (int): ID of the active track on the requested channel.
        """

        # init local variables
        ack = None
        track_id = None

        # implementation using BITS-Platform audio_in module as audio_input test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack, result = bp_lib.input_get_signal_value(sSignalName=channel_name)
        if ack:
            track_id = int(float(result))

        return ack, track_id


    @keyword
    def get_track_position(self, channel_name:str) -> tuple[bool, int]:
        """
        Get the time position of the active track on the requested audio channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the audio channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``time_position`` (int): Time position of the active track on the requested channel.
        """

        # init local variables
        ack = None
        time_position = None

        # implementation using BITS-Platform audio_in module as audio_input test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack, result = bp_lib.input_get_signal_value(sSignalName=channel_name)
        if ack:
            time_position = int(float(result))

        return ack, time_position


    @keyword
    def start_recording(self, channels:dict) -> bool: # pylint: disable=W0613:unused-argument
        """
        Start the recording on the selected audio channel(s).\n
        = Interfaces =\n
        IN: ``channels`` (dict): Audio channels to record.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # dummy implementation
        ack = True

        return ack


    @keyword
    def stop_recording(self, channels:dict) -> bool: # pylint: disable=W0613:unused-argument
        """
        Stop the recording on the selected audio channel(s).\n
        = Interfaces =\n
        IN: ``channels`` (dict): Audio channels to record.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # no implementation available

        return ack


    @keyword
    def pause_recording(self, channels:dict) -> bool: # pylint: disable=W0613:unused-argument
        """
        Pause the recording on the selected audio channel(s).\n
        = Interfaces =\n
        IN: ``channels`` (dict): Audio channels to record.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # no implementation available

        return ack


    @keyword
    def resume_recording(self, channels:dict) -> bool: # pylint: disable=W0613:unused-argument
        """
        Resume the recording on the selected audio channel(s).\n
        = Interfaces =\n
        IN: ``channels`` (dict): Audio channels to record.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # no implementation available

        return ack
