'''
Generic testbench tuner module library. This manages all available tuner channels.
'''

from generic.testbench.tuner.reader import TunerReader
from generic.testbench.tuner.am.channel import TunerChannelAM
from generic.testbench.tuner.dab.channel import TunerChannelDAB
from generic.testbench.tuner.fm.channel import TunerChannelFM
from generic.testbench.tuner.rds.channel import TunerChannelRDS


class TunerManager():
    """ Manages all available tuner channels (for all submodules). """

    def __init__(self, submodule):
        self.submodule = submodule
        self.reader = TunerReader(submodule)
        self.config = {} # validated tuner configuration
        self.tuner_channels = {}
        self.create_channels_from_config()


    def determine_channel_library(self, channel_name:str, config:dict) -> object:
        """
        Determine the required channel library based on the submodule and create
        a channel object.
        """

        if self.submodule == "AM":
            channel_object = TunerChannelAM(channel_name, config)
        elif self.submodule == "DAB":
            channel_object = TunerChannelDAB(channel_name, config)
        elif self.submodule == "FM":
            channel_object = TunerChannelFM(channel_name, config)
        elif self.submodule == "RDS":
            channel_object = TunerChannelRDS(channel_name, config)
        else:
            return None

        return channel_object


    def create_channels_from_config(self) -> bool:
        """
        Create all tuner channels defined in the given config (after successful
        validation). This method is executed only once during instanciation.
        """

        check, self.config = self.reader.get_config()
        if check:
            for channel_name in self.config.keys():
                self._add_channel(channel_name, self.config[channel_name])
        else:
            return False
        return True


    def _add_channel(self, channel_name:str, config:dict) -> None:
        """ Add a tuner channel to the 'tuner_channels' dictionary. """

        exist = channel_name in self.tuner_channels
        if not exist:
            channel_object = self.determine_channel_library(channel_name, config)
            if channel_object is not None:
                self.tuner_channels.update({channel_name:channel_object})


    def _update_channel(self, channel_name:str, config:dict) -> None:
        """ Update an existing tuner channel in the 'tuner_channels' dictionary. """

        exist = channel_name in self.tuner_channels
        if exist:
            channel_object = self.determine_channel_library(channel_name, config)
            if channel_object is not None:
                self.tuner_channels.update({channel_name:channel_object})


    def _remove_channel(self, channel_name:str) -> None:
        """ Remove a tuner channel from the 'tuner_channels' dictionary. """

        exist = channel_name in self.tuner_channels
        if exist:
            self.tuner_channels.pop(channel_name)


    def add_channel_properties(self, channel_name:str, features:dict) -> tuple[bool, str]:
        """
        Adds additional properties to a tuner channel. This method updates the validated
        tuner configuration and the 'tuner_channels' dictionary.
        """

        check = type(features) in [dict]
        if check is False:
            return False, "No dictionary detected."

        exist = channel_name in self.tuner_channels
        if exist:
            for feature in features.items():
                self.config[channel_name].update({feature})
            self._update_channel(channel_name, self.config[channel_name])
        else:
            return False, "Channel is not existing."

        return True, "Channel properties are updated."


    def set_channel_property(self, channel_name:str, feature:str, new_value) -> tuple[bool, str]:
        """
        Set a specific property of a tuner channel. This method updates the validated
        tuner configuration and the 'tuner_channels' dictionary.
        """

        exist = channel_name in self.tuner_channels
        if exist:
            try:
                # check if the requested tuner channel property is existing
                value = self.tuner_channels.get(channel_name)
                getattr(value, feature)
            except (AttributeError) as exc_info:
                return False, str(exc_info)
        else:
            return False, "Channel is not existing."

        # update the validated tuner configuration
        self.config[channel_name].update({feature:new_value})

        # update the 'tuner_channels' dictionary.
        self._update_channel(channel_name, self.config[channel_name])

        return True, "Channel property is updated."


    def get_channel_properties(self, channel_name:str) -> tuple[bool, object]:
        """ Get all properties of a tuner channel. """

        exist = channel_name in self.tuner_channels
        if exist:
            try:
                value = self.tuner_channels.get(channel_name)
                result = vars(value)
            except (AttributeError) as exc_info:
                return None, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result


    def get_channel_property(self, channel_name:str, feature:str) -> tuple[bool, object]:
        """ Get a specific property of a tuner channel. """

        exist = channel_name in self.tuner_channels
        if exist:
            try:
                value = self.tuner_channels.get(channel_name)
                result = getattr(value, feature)
            except (AttributeError) as exc_info:
                return False, str(exc_info)
        else:
            return False, "Channel is not existing."

        return True, result
