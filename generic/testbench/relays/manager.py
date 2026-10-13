'''
Generic testbench ralays module library. This manages all available relay channels.
'''

from generic.testbench.relays.reader import RelaysReader
from generic.testbench.relays.channel import RelaysChannel


class RelaysManager():
    """ Manages all available relay channels. """

    def __init__(self):
        self.initialized = False
        self.config = {}
        self.reader = RelaysReader()
        self.relays_channels = {}
        self.create_channels_from_config()
        self.channel_list = None


    def create_channels_from_config(self) -> bool:
        """ Create all relay channels defined in the given config. """

        check,self.config = self.reader.get_config()
        if check:
            for channel_name in self.config.keys():
                self._add_channel(channel_name, self.config[channel_name])
            self.channel_list = list(self.relays_channels)
        else:
            return False

        return True


    def _add_channel(self, channel_name:str, config:dict) -> None:
        """ Add a relay channel to the 'relays_channels' dictionary. """

        exist = channel_name in self.relays_channels
        if not exist:
            self.relays_channels.update({channel_name:RelaysChannel(channel_name, config)})


    def _update_channel(self, channel_name:str, config:dict) -> None:
        """ Update an existing relay channel in the 'relays_channels' dictionary. """

        exist = channel_name in self.relays_channels
        if exist:
            self.relays_channels.update({channel_name:RelaysChannel(channel_name, config)})


    def _remove_channel(self, channel_name:str) -> None:
        """ Remove a relay channel from the 'relays_channels' dictionary. """

        exist = channel_name in self.relays_channels
        if exist:
            self.relays_channels.pop(channel_name)


    def get_channel_properties(self, channel_name:str) -> tuple[bool, object]:
        """ Get all properties of a relay channel. """

        exist = channel_name in self.relays_channels
        if exist:
            try:
                value = self.relays_channels.get(channel_name)
                result = vars(value)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result


    def get_channel_property(self, channel_name:str, feature:str) -> tuple[bool, object]:
        """ Get a specific property of a relay channel. """

        exist = channel_name in self.relays_channels
        if exist:
            try:
                value = self.relays_channels.get(channel_name)
                result = getattr(value, feature)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result
