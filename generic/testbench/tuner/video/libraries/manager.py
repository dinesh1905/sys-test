'''
Generic testbench video module library. This manages all available video channels.
'''

from generic.testbench.video.libraries.reader import VideoReader
from generic.testbench.video.libraries.channel import VideoChannel
from generic.testbench.video.libraries.source import VideoSource


class VideoManager():
    """ Manages all available video channels. """

    def __init__(self):
        self.initialized = False
        self.config = {}
        self.reader = VideoReader()
        self.video_channels = {}
        self.video_sources = {}
        self.create_sources_from_config()
        self.create_channels_from_config()
        self.channel_list = None        


    def create_sources_from_config(self) -> bool:
        """ Create all video sources defined in the given config. """

        check, config = self.reader.get_sources()
        if check:
            for source_name in config.keys():
                self.video_sources.update({source_name:VideoSource(source_name, config[source_name])})
        else:
            return False

        return True


    def get_source_property(self, source_name:str, feature:str) -> tuple[bool, object]:
        """ Get a specific property of an video source. """

        exist = source_name in self.video_sources
        if exist:
            try:
                value = self.video_sources.get(source_name)
                result = getattr(value, feature)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Source is not existing."

        return True, result


    def create_channels_from_config(self) -> bool:
        """ Create all video channels defined in the given config. """

        check, self.config = self.reader.get_config()
        if check:
            for channel_name in self.config.keys():
                self._add_channel(channel_name, self.config[channel_name])
            self.channel_list = list(self.video_channels)
        else:
            return False

        return True


    def _add_channel(self, channel_name:str, config:dict) -> None:
        """ Add a video channel to the 'video_channels' dictionary. """

        exist = channel_name in self.video_channels
        if not exist:
            self.video_channels.update({channel_name:VideoChannel(channel_name, config)})


    def _update_channel(self, channel_name:str, config:dict) -> None:
        """ Update an existing video channel in the 'video_channels' dictionary. """

        exist = channel_name in self.video_channels
        if exist:
            self.video_channels.update({channel_name:VideoChannel(channel_name, config)})


    def _remove_channel(self, channel_name:str) -> None:
        """ Remove a audio channel from the 'video_channels' dictionary. """

        exist = channel_name in self.video_channels
        if exist:
            self.video_channels.pop(channel_name)


    def get_channel_properties(self, channel_name:str) -> tuple[bool, object]:
        """ Get all properties of an video channel. """

        exist = channel_name in self.video_channels
        if exist:
            try:
                value = self.video_channels.get(channel_name)
                result = vars(value)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result


    def get_channel_property(self, channel_name:str, feature:str) -> tuple[bool, object]:
        """ Get a specific property of an video channel. """

        exist = channel_name in self.video_channels
        if exist:
            try:
                value = self.video_channels.get(channel_name)
                result = getattr(value, feature)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result
