'''
Generic testbench audio input module. This implements all audio input commands in generic way by means of
abstract keywords independed from any specific testbench setup.
'''

from robotlibcore import DynamicCore
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.testbench.audio.input.manager import AudioManager
from generic.testbench.audio.input.recorder import AudioRecorder
from generic.framework.framework import framework


@library
class keywords(DynamicCore): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """General library documentation."""
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        self.manager = AudioManager()
        self.recorder = AudioRecorder()
        libraries = []
        DynamicCore.__init__(self, libraries)


    def check_if_source_exists(self, source_name) -> bool:
        """ Helper function to check if an audio source with the given name exist.\n
        = Interfaces = \n
        IN: ``source_name`` (str): Name of the audio source.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        if source_name not in self.manager.audio_sources:
            return False

        return True


    def check_if_channel_exists(self, channel_name) -> bool:
        """ Helper function to check if an audio channel with the given name exist.\n
        = Interfaces = \n
        IN: ``channel_name`` (str): Name of the audio channel.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        if channel_name not in self.manager.audio_channels:
            return False

        return True

########################## Audio input keywords ###########################

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
        info_text = "Found unknown error while executing 'audio_input.Get Audio Source'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An audio channel with the given name is not existing.", level='WARN')
            return False, None

        ack, source = self.manager.audio_channels[channel_name].get_audio_source()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        # check if 'source' is available in 'audio_sources' dictionary
        if ack is True and source not in self.manager.audio_sources:
            BuiltIn().log(message="The detected audio source is not supported.", level='WARN')
            return False, source

        return ack, source


    @keyword
    def check_audio_source(self, channel_name:str, source:str) -> tuple[bool, bool]:
        """
        Check if the active audio source on the requested channel is the expected one.\n
        = Interfaces =\n
        IN_1: ``channel_name`` (str): Name of the audio channel.\n
        IN_2: ``source`` (str): Expected audio source.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Result feedack (True/False).
        """

        # init local variables
        ack = None
        result = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An audio channel with the given name is not existing.", level='WARN')
            return False, None

        ack, value = self.get_audio_source(channel_name)

        # check if 'value' is the expected audio source
        if ack is True:
            if value == source: #pylint: disable=R1703:simplifiable-if-statement
                result = True
            else:
                result = False

        return ack, result


    @keyword
    def get_volume(self, channel_name:str) -> tuple[bool, int]:
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
        info_text = "Found unknown error while executing 'audio_input.Get Volume'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An audio channel with the given name is not existing.", level='WARN')
            return False, None

        ack, volume = self.manager.audio_channels[channel_name].get_volume()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        # check data type of 'volume' and convert if necessary
        if ack is True and not isinstance(volume, int):
            try:
                volume = int(volume)
            except TypeError:
                BuiltIn().log(message="'volume' has the wrong type (expected: int) and cannot be converted.",
                level='WARN')
                return False, None

        return ack, volume


    @keyword
    def check_volume(self, channel_name:str, volume:int) -> tuple[bool, bool]:
        """
        Check if the volume level on the requested audio channel is the expected one.\n
        = Interfaces =\n
        IN_1: ``channel_name`` (str): Name of the audio channel.\n
        IN_2: ``volume`` (int): Expected volume level.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Result feedack (True/False).
        """

        # init local variables
        ack = None
        result = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An audio channel with the given name is not existing.", level='WARN')
            return False, None

        if isinstance(volume, bool) or not isinstance(volume, int):
            BuiltIn().log(message="'volume' has wrong type (expected: int).", level='WARN')
            return False, None

        ack, value = self.get_volume(channel_name)

        # check if 'value' is the expected audio volume
        if ack is True:
            result = bool(value == volume)

        return ack, result


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
        info_text = "Found unknown error while executing 'audio_input.Get Track Id'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An audio channel with the given name is not existing.", level='WARN')
            return False, None

        ack, track_id = self.manager.audio_channels[channel_name].get_track_id()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        # check data type of 'track_id' and convert if necessary
        if ack is True and not isinstance(track_id, int):
            try:
                track_id = int(track_id)
            except TypeError:
                BuiltIn().log(message="'track_id' has the wrong type (expected: int) and cannot be converted.",
                level='WARN')
                return False, None

        return ack, track_id


    @keyword
    def check_track_id(self, channel_name:str, track_id:int) -> tuple[bool, bool]:
        """
        Check if the active track on the requested audio channel is the expected one.\n
        = Interfaces =\n
        IN_1: ``channel_name`` (str): Name of the audio channel.\n
        IN_2: ``track_id`` (int): Expected track.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Result feedack (True/False).
        """

        # init local variables
        ack = None
        result = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An audio channel with the given name is not existing.", level='WARN')
            return False, None

        if isinstance(track_id, bool) or not isinstance(track_id, int):
            BuiltIn().log(message="'track_id' has wrong type (expected: int).", level='WARN')
            return False, None

        ack, value = self.get_track_id(channel_name)

        # check if 'value' is the expected track id
        if ack is True:
            result = bool(value == track_id)

        return ack, result


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
        info_text = "Found unknown error while executing 'audio_input.Get Track Position'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An audio channel with the given name is not existing.", level='WARN')
            return False, None

        ack, time_position = self.manager.audio_channels[channel_name].get_track_position()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        # check data type of 'time_position' and convert if necessary
        if ack is True and not isinstance(time_position, int):
            try:
                time_position = int(time_position)
            except TypeError:
                BuiltIn().log(message="'time_position' has the wrong type (expected: int) and cannot be converted.",
                level='WARN')
                return False, None

        return ack, time_position


    @keyword
    def check_track_position(self, channel_name:str, time_position:int) -> tuple[bool, bool]:
        """
        Check if the time position of the active track on the requested audio channel is the expected one.\n
        = Interfaces =\n
        IN_1: ``channel_name`` (str): Name of the audio channel.\n
        IN_2: ``time_position`` (int): Expected time position of the active track.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``bResult`` (bool): Result feedack (True/False).
        """

        # init local variables
        ack = None
        result = None

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An audio channel with the given name is not existing.", level='WARN')
            return False, None

        if isinstance(time_position, bool) or not isinstance(time_position, int):
            BuiltIn().log(message="'time_position' has wrong type (expected: int).", level='WARN')
            return False, None

        ack, value = self.get_track_position(channel_name)

        # check if 'value' is the expected track position
        if ack is True:
            result = bool(value == time_position)

        return ack, result

######################### Audio recorder keywords #########################

    @keyword
    def select_channels_for_recording(self, channel_names:list) -> bool:
        """
        Select the audio channel(s) for recording.\n
        = Interfaces =\n
        IN: ``channel_names`` (list): List of audio channel names.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # check if the audio recorder is able to receive data
        if self.recorder.state in ['recording','paused']:
            return None

        # check if the channel input list is valid
        if not isinstance(channel_names, list):
            BuiltIn().log(message="Input is not a list.", level='WARN')
            return False

        for channel_name in channel_names:
            if not self.check_if_channel_exists(channel_name):
                BuiltIn().log(message="An audio channel with the given name is not existing.",
                level='WARN')
                return False

        # extract selected audio channels from 'audio_channels' dictionary
        dict_item = {key:value for key,value in self.manager.audio_channels.items() if key in channel_names}

        # update 'selected_channels' distionary
        self.recorder.set_channel_for_recording(dict_item)

        return True


    @keyword
    def start_recording(self) -> bool:
        """
        Start the recording on the selected audio channel(s).\n
        = Interfaces =\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'audio_input.Start Recording'."

        if self.recorder.state not in ['initialized','stopped']:
            BuiltIn().log(message="Audio recorder is in wrong state (expected: 'initialized' or 'stopped').",
            level='WARN')
            return False

        ack = self.recorder.start_recording()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def stop_recording(self) -> bool:
        """
        Stop the recording on the selected audio channel(s).\n
        = Interfaces =\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'audio_input.Stop Recording'."

        if self.recorder.state not in ['paused','recording']:
            BuiltIn().log(message="Audio recorder is in wrong state (expected: 'paused' or 'recording').",
            level='WARN')
            return False

        ack = self.recorder.stop_recording()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def pause_recording(self) -> bool:
        """
        Pause the recording on the selected audio channel(s).\n
        = Interfaces =\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'audio_input.Pause Recording'."

        if self.recorder.state != 'recording':
            BuiltIn().log(message="Audio recorder is in wrong state (expected: 'recording').",
            level='WARN')
            return False

        ack = self.recorder.pause_recording()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def resume_recording(self) -> bool:
        """
        Resume the recording on the selected audio channel(s).\n
        = Interfaces =\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'audio_input.Resume Recording'."

        if self.recorder.state != 'paused':
            BuiltIn().log(message="Audio recorder is in wrong state (expected: 'paused').", level='WARN')
            return False

        ack = self.recorder.resume_recording()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack
