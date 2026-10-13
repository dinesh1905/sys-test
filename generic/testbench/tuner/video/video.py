'''
Generic testbench video module. This implements all video commands in generic way by means of
abstract keywords indedepended from any specific testbench setup.
'''

from robotlibcore import DynamicCore
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.testbench.video.libraries.manager import VideoManager
from generic.testbench.video.libraries.recorder import VideoRecorder


@library
class video(DynamicCore): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """General library documentation."""
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        self.manager = VideoManager()
        self.recorder = VideoRecorder()
        libraries = []
        DynamicCore.__init__(self, libraries)


    def check_if_source_exists(self, source_name) -> bool:
        """ Helper function to check if a video source with the given name exist.\n
        = Interfaces = \n
        IN: ``source_name`` (str): Name of the video source.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        if source_name not in self.manager.video_sources:
            return False

        return True


    def check_if_channel_exists(self, channel_name) -> bool:
        """ Helper function to check if a video channel with the given name exist.\n
        = Interfaces = \n
        IN: ``channel_name`` (str): Name of the video channel.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        if channel_name not in self.manager.video_channels:
            return False

        return True

############################# Video keywords ##############################

    @keyword
    def get_video_source(self, channel_name:str) -> tuple[bool, str]:
        """
        Get the allocated source on the requested video channel.\n
        = Interfaces = \n
        IN: ``channel_name`` (str): Name of the video channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``source`` (str): Allocated video source.
        """

        # init local variables
        ack = None
        source = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A video channel with the given name is not existing.", level='WARN', console=True)
            return False, None

        ack, source = self.manager.video_channels[channel_name].get_video_source()

        # check if 'source' is available in 'video_sources' dictionary
        if ack is True and source not in self.manager.video_sources:
            BuiltIn().log(message="The detected video source is not supported.", level='WARN', console=True)
            return False, source

        return ack, source


    @keyword
    def check_video_source(self, channel_name:str, source:str) -> tuple[bool, bool]:
        """
        Check if the active video source on the requested channel is the expected one.\n
        = Instances =\n
        IN_1: ``channel_name`` (str): Name of the video channel.\n
        IN_2: ``source`` (str): Expected video source.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Result feedack (True/False).
        """

        # init local variables
        ack = None
        result = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A video channel with the given name is not existing.", level='WARN', console=True)
            return False, None

        ack, value = self.get_video_source(channel_name)

        # check if 'value' is the expected video source
        if ack is True:
            if value == source: #pylint: disable=R1703:simplifiable-if-statement
                result = True
            else:
                result = False

        return ack, result


    @keyword
    def get_volume(self, channel_name:str) -> tuple[bool, int]:
        """
        Get the volume on the requested video channel.\n
        = Instances =\n
        IN: ``channel_name`` (str): Name of the video channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``volume`` (int): Volume on the requested channel.
        """

        # init local variables
        ack = None
        volume = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A video channel with the given name is not existing.", level='WARN', console=True)
            return False, None

        ack, volume = self.manager.video_channels[channel_name].get_volume()

        # check data type of 'volume' and convert if necessary
        if ack is True and not isinstance(volume, int):
            try:
                volume = int(volume)
            except TypeError:
                BuiltIn().log(message="'volume' has the wrong type (expected: int) and cannot be converted.",
                level='WARN',
                console=True)
                return False, None

        return ack, volume


    @keyword
    def check_volume(self, channel_name:str, volume:int) -> tuple[bool, bool]:
        """
        Check if the volume level on the requested video channel is the expected one.\n
        = Instances =\n
        IN_1: ``channel_name`` (str): Name of the video channel.\n
        IN_2: ``volume`` (int): Expected volume level.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Result feedack (True/False).
        """

        # init local variables
        ack = None
        result = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A video channel with the given name is not existing.", level='WARN', console=True)
            return False, None

        if isinstance(volume, bool) or not isinstance(volume, int):
            BuiltIn().log(message="'volume' has wrong type (expected: int).", level='WARN', console=True)
            return False, None

        ack, value = self.get_volume(channel_name)

        # check if 'value' is the expected video volume
        if ack is True:
            result = bool(value == volume)

        return ack, result


    @keyword
    def get_track_id(self, channel_name:str) -> tuple[bool, int]:
        """
        Get the id of the active track on the requested video channel.\n
        = Instances =\n
        IN: ``channel_name`` (str): Name of the video channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``track_id`` (int): ID of the active track on the requested channel.
        """

        # init local variables
        ack = None
        track_id = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A video channel with the given name is not existing.", level='WARN', console=True)
            return False, None

        ack, track_id = self.manager.video_channels[channel_name].get_track_id()

        # check data type of 'track_id' and convert if necessary
        if ack is True and not isinstance(track_id, int):
            try:
                track_id = int(track_id)
            except TypeError:
                BuiltIn().log(message="'track_id' has the wrong type (expected: int) and cannot be converted.",
                level='WARN',
                console=True)
                return False, None

        return ack, track_id


    @keyword
    def check_track_id(self, channel_name:str, track_id:int) -> tuple[bool, bool]:
        """
        Check if the active track on the requested video channel is the expected one.\n
        = Instances =\n
        IN_1: ``channel_name`` (str): Name of the video channel.\n
        IN_2: ``track_id`` (int): Expected track.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Result feedack (True/False).
        """

        # init local variables
        ack = None
        result = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A video channel with the given name is not existing.", level='WARN', console=True)
            return False, None

        if isinstance(track_id, bool) or not isinstance(track_id, int):
            BuiltIn().log(message="'track_id' has wrong type (expected: int).", level='WARN', console=True)
            return False, None

        ack, value = self.get_track_id(channel_name)

        # check if 'value' is the expected track id
        if ack is True:
            result = bool(value == track_id)

        return ack, result


    @keyword
    def get_track_position(self, channel_name:str) -> tuple[bool, int]:
        """
        Get the time position of the active track on the requested video channel.\n
        = Instances =\n
        IN: ``channel_name`` (str): Name of the video channel.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``time_position`` (int): Time position of the active track on the requested channel.
        """

        # init local variables
        ack = None
        time_position = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A video channel with the given name is not existing.", level='WARN', console=True)
            return False, None

        ack, time_position = self.manager.video_channels[channel_name].get_track_position()

        # check data type of 'time_position' and convert if necessary
        if ack is True and not isinstance(time_position, int):
            try:
                time_position = int(time_position)
            except TypeError:
                BuiltIn().log(message="'time_position' has the wrong type (expected: int) and cannot be converted.",
                level='WARN',
                console=True)
                return False, None

        return ack, time_position


    @keyword
    def check_track_position(self, channel_name:str, time_position:int) -> tuple[bool, bool]:
        """
        Check if the time position of the active track on the requested video channel is the expected one.\n
        = Instances =\n
        IN_1: ``channel_name`` (str): Name of the video channel.\n
        IN_2: ``time_position`` (int): Expected time position of the active track.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``bResult`` (bool): Result feedack (True/False).
        """

        # init local variables
        ack = None
        result = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A video channel with the given name is not existing.", level='WARN', console=True)
            return False, None

        if isinstance(time_position, bool) or not isinstance(time_position, int):
            BuiltIn().log(message="'time_position' has wrong type (expected: int).", level='WARN', console=True)
            return False, None

        ack, value = self.get_track_position(channel_name)

        # check if 'value' is the expected track position
        if ack is True:
            result = bool(value == time_position)

        return ack, result

######################### Video recorder keywords #########################

    @keyword
    def select_channels_for_recording(self, channel_names:list) -> bool:
        """
        Select the video channel(s) for recording.\n
        = Interfaces =\n
        IN: ``channel_names`` (list): List of video channel names.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # check if the video recorder is able to receive data
        if self.recorder.state in ['recording','paused']:
            return None

        # check if the channel input list is valid
        if not isinstance(channel_names, list):
            BuiltIn().log(message="Input is not a list.", level='WARN', console=True)
            return False

        for channel_name in channel_names:
            if not self.check_if_channel_exists(channel_name):
                BuiltIn().log(message="A video channel with the given name is not existing.",
                level='WARN',
                console=True)
                return False

        # extract selected video channels from 'video_channels' dictionary
        dict_item = {key:value for key,value in self.manager.video_channels.items() if key in channel_names}

        # update 'selected_channels' distionary
        self.recorder.set_channel_for_recording(dict_item)

        return True


    @keyword
    def start_recording(self) -> bool:
        """
        Start the recording on the selected video channel(s).\n
        = Interfaces =\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        if self.recorder.state not in ['initialized','stopped']:
            BuiltIn().log(message="Video recorder is in wrong state (expected: 'initialized' or 'stopped').",
            level='WARN',
            console=True)
            return False

        ack = self.recorder.start_recording()

        return ack


    @keyword
    def stop_recording(self) -> bool:
        """
        Stop the recording on the selected video channel(s).\n
        = Interfaces =\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        if self.recorder.state not in ['paused','recording']:
            BuiltIn().log(message="Video recorder is in wrong state (expected: 'paused' or 'recording').",
            level='WARN',
            console=True)
            return False

        ack = self.recorder.stop_recording()

        return ack


    @keyword
    def pause_recording(self) -> bool:
        """
        Pause the recording on the selected video channel(s).\n
        = Interfaces =\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        if self.recorder.state != 'recording':
            BuiltIn().log(message="Video recorder is in wrong state (expected: 'recording').",
            level='WARN',
            console=True)
            return False

        ack = self.recorder.pause_recording()

        return ack


    @keyword
    def resume_recording(self) -> bool:
        """
        Resume the recording on the selected video channel(s).\n
        = Interfaces =\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        if self.recorder.state != 'paused':
            BuiltIn().log(message="Video recorder is in wrong state (expected: 'paused').", level='WARN', console=True)
            return False

        ack = self.recorder.resume_recording()

        return ack
