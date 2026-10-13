"""
Project specific testbench video module for bench_local setup. This implements all video
commands specifically for this setup using BITS-Platform vision module.
"""

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

MODULE_NAME    = "video.py"
MODULE_VERSION = "0.0.1"
MODULE_DATE    = "06.09.2022"
MODULE         = MODULE_NAME + " v" + MODULE_VERSION + " / " + MODULE_DATE


@library
class keywords(): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ project.testbench.bench_local implementation of video module. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = MODULE_VERSION
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    def __init__(self, this_module=MODULE):
        self.this_module = this_module
        self.module_prefix = "prj.testbench.video."
        BuiltIn().log(self.this_module + " entered", "INFO")


    def __del__(self):
        BuiltIn().log(self.this_module + " done.", "INFO")


    @keyword
    def get_video_source(self, channel_name:str) -> tuple[bool, str]: # pylint: disable=W0613:unused-argument
        """
        Get the allocated source on the requested video channel.\n
        = Interfaces = \n
        IN:    ``channel_name`` (str): Name of the video channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``source`` (str): Allocated video source.
        """

        # init local variables
        ack = None
        source = None

        # no implementation available

        return ack, source


    @keyword
    def get_volume(self, channel_name:str) -> tuple[bool, int]: # pylint: disable=W0613:unused-argument
        """
        Get the volume on the requested video channel.\n
        = Interfaces =\n
        IN:    ``channel_name`` (str): Name of the video channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``volume`` (int): Volume on the requested channel.
        """

        # init local variables
        ack = None
        volume = None

        # no implementation available

        return ack, volume


    @keyword
    def get_track_id(self, channel_name:str) -> tuple[bool, int]: # pylint: disable=W0613:unused-argument
        """
        Get the id of the active track on the requested video channel.\n
        = Interfaces =\n
        IN:    ``channel_name`` (str): Name of the video channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``track_id`` (int): ID of the active track on the requested channel.
        """

        # init local variables
        ack = None
        track_id = None

        # no implementation available

        return ack, track_id


    @keyword
    def get_track_position(self, channel_name:str) -> tuple[bool, int]: # pylint: disable=W0613:unused-argument
        """
        Get the time position of the active track on the requested video channel.\n
        = Interfaces =\n
        IN:    ``channel_name`` (str): Name of the video channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``time_position`` (int): Time position of the active track on the requested channel.
        """

        # init local variables
        ack = None
        time_position = None

        # no implementation available

        return ack, time_position


    @keyword
    def start_recording(self, channels:dict) -> bool: # pylint: disable=W0613:unused-argument
        """
        Start the recording on the selected video channel(s).\n
        = Interfaces =\n
        IN:  ``channels`` (dict): Video channels to record.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # implementation using BITS-Platform as video test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.vision_control_video_recording(unit='1', mode='START')

        return ack


    @keyword
    def stop_recording(self, channels:dict) -> bool: # pylint: disable=W0613:unused-argument
        """
        Stop the recording on the selected video channel(s).\n
        = Interfaces =\n
        IN:  ``channels`` (dict): Video channels to record.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # implementation using BITS-Platform as video test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.vision_control_video_recording(unit='1', mode='STOP')

        return ack


    @keyword
    def pause_recording(self, channels:dict) -> bool: # pylint: disable=W0613:unused-argument
        """
        Pause the recording on the selected video channel(s).\n
        = Interfaces =\n
        IN:  ``channels`` (dict): Video channels to record.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # implementation using BITS-Platform as video test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.vision_control_video_recording(unit='1', mode='PAUSE')

        return ack


    @keyword
    def resume_recording(self, channels:dict) -> bool: # pylint: disable=W0613:unused-argument
        """
        Resume the recording on the selected video channel(s).\n
        = Interfaces =\n
        IN:  ``channels`` (dict): Video channels to record.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # no implementation available

        return ack
