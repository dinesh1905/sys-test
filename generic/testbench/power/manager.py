'''
Generic testbench power module library. This manages all available power channels.
'''

from generic.testbench.power.reader import PowerReader
from generic.testbench.power.channel import PowerChannel


class PowerManager():
    """ Manages all available power channels. """

    def __init__(self):
        self.initialized = False
        self.config = {}
        self.reader = PowerReader()
        self.power_channels = {}
        self.create_channels_from_config()
        self.channel_list = None


    def create_channels_from_config(self) -> bool:
        """ Create all power channels defined in the given config. """

        check, self.config = self.reader.get_config()
        if check:
            for channel_name in self.config.keys():
                self._add_channel(channel_name, self.config[channel_name])
            self.channel_list = list(self.power_channels)
        else:
            return False

        return True


    def _add_channel(self, channel_name:str, config:dict) -> None:
        """ Add a power channel to the 'power_channels' dictionary. """

        exist = channel_name in self.power_channels
        if not exist:
            self.power_channels.update({channel_name:PowerChannel(channel_name, config)})


    def _update_channel(self, channel_name:str, config:dict) -> None:
        """ Update an existing power channel in the 'power_channels' dictionary. """

        exist = channel_name in self.power_channels
        if exist:
            self.power_channels.update({channel_name:PowerChannel(channel_name, config)})


    def _remove_channel(self, channel_name:str) -> None:
        """ Remove a power channel from the 'power_channels' dictionary. """

        exist = channel_name in self.power_channels
        if exist:
            self.power_channels.pop(channel_name)


    def get_channel_properties(self, channel_name:str) -> tuple[bool, object]:
        """ Get all properties of a power channel. """

        exist = channel_name in self.power_channels
        if exist:
            try:
                value = self.power_channels.get(channel_name)
                result = vars(value)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result


    def get_channel_property(self, channel_name:str, feature:str) -> tuple[bool, object]:
        """ Get a specific property of a power channel. """

        exist = channel_name in self.power_channels
        if exist:
            try:
                value = self.power_channels.get(channel_name)
                result = getattr(value, feature)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result
