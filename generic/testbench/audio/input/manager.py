'''
Generic testbench audio input module library. This manages all available audio input channels.
'''

from generic.testbench.audio.input.reader import AudioReader
from generic.testbench.audio.input.channel import AudioChannel
from generic.testbench.audio.input.source import AudioSource


class AudioManager():
    """ Manages all available audio channels. """

    def __init__(self):
        self.initialized = False
        self.config = {}
        self.reader = AudioReader()
        self.audio_channels = {}
        self.audio_sources = {}
        self.create_sources_from_config()
        self.create_channels_from_config()
        self.channel_list = None


    def create_sources_from_config(self) -> bool:
        """ Create all audio sources defined in the given config. """

        check, config = self.reader.get_sources()
        if check:
            for source_name in config.keys():
                self.audio_sources.update({source_name:AudioSource(source_name, config[source_name])})
        else:
            return False

        return True


    def get_source_property(self, source_name:str, feature:str) -> tuple[bool, object]:
        """ Get a specific property of an audio source. """

        exist = source_name in self.audio_sources
        if exist:
            try:
                value = self.audio_sources.get(source_name)
                result = getattr(value, feature)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Source is not existing."

        return True, result


    def create_channels_from_config(self) -> bool:
        """ Create all audio channels defined in the given config. """

        check, self.config = self.reader.get_config()
        if check:
            for channel_name in self.config.keys():
                self._add_channel(channel_name, self.config[channel_name])
            self.channel_list = list(self.audio_channels)
        else:
            return False

        return True


    def _add_channel(self, channel_name:str, config:dict) -> None:
        """ Add a audio channel to the 'audio_channels' dictionary. """

        exist = channel_name in self.audio_channels
        if not exist:
            self.audio_channels.update({channel_name:AudioChannel(channel_name, config)})


    def _update_channel(self, channel_name:str, config:dict) -> None:
        """ Update an existing audio channel in the 'audio_channels' dictionary. """

        exist = channel_name in self.audio_channels
        if exist:
            self.audio_channels.update({channel_name:AudioChannel(channel_name, config)})


    def _remove_channel(self, channel_name:str) -> None:
        """ Remove a audio channel from the 'audio_channels' dictionary. """

        exist = channel_name in self.audio_channels
        if exist:
            self.audio_channels.pop(channel_name)


    def get_channel_properties(self, channel_name:str) -> tuple[bool, object]:
        """ Get all properties of an audio channel. """

        exist = channel_name in self.audio_channels
        if exist:
            try:
                value = self.audio_channels.get(channel_name)
                result = vars(value)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result


    def get_channel_property(self, channel_name:str, feature:str) -> tuple[bool, object]:
        """ Get a specific property of an audio channel. """

        exist = channel_name in self.audio_channels
        if exist:
            try:
                value = self.audio_channels.get(channel_name)
                result = getattr(value, feature)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result
