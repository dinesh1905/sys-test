'''
Generic testbench audio input module library. This checks if the configuration
of the audio input module is valid.
'''

import re
from RobotFramework_TestsuitesManagement.Config.CConfig import DotDict
from robot.libraries.BuiltIn import BuiltIn, RobotNotRunningError


PARAM_PATHS_CHANNEL = [['source','id'], ['volume','id'], ['track','id'], ['track','position','id']]
PARAM_PATHS_SOURCE = [['type'], ['id']]


class AudioReader():
    """ Checks if a given dictionary is valid. """

    def __init__(self):
        self.audio_config = None
        self.sources_config = None


    @classmethod
    def get_test_sources(cls) -> dict:
        """ Helper function to load a special source configuration in case of test mode. """

        test_config = {
            "DAB_1" : {
                "type"  : "Tuner",
                "id" : 512
            },
            "USB_1" : {
                "type"  : "Media",
                "id" : 1536
            }
        }

        return test_config

    @classmethod
    def get_test_config(cls) -> dict:
        """ Helper function to load a special configuration in case of test mode. """

        test_config = {
            "Front_Left" : {
                "source" : {
                    "id" : "LF_Source"
                },
                "volume" : {
                    "id" : "LF_Volume"
                },
                "track" : {
                    "id" : "LF_TrackID",
                    "position" : {
                        "id" : "LF_TimePos"
                    }
                }
            },
            "Front_Right" : {
                "source" : {
                    "id" : "RF_Source"
                },
                "volume" : {
                    "id" : "RF_Volume"
                },
                "track" : {
                    "id" : "RF_TrackID",
                    "position" : {
                        "id" : "RF_TimePos"
                    }
                }
            }
        }

        return test_config


    @classmethod
    def dictionary_should_contain_parameter(cls, config:dict, params:list) -> tuple[bool, object]:
        """ Helper function used by the validate functions. """

        try:
            for item in params:
                if item in config.keys():
                    config = config[item]
                else:
                    return False, None
        except (TypeError, AttributeError) as exc_info:
            return None, str(exc_info)

        return True, config


    def get_sources(self) -> tuple[bool, dict]:
        """ Entry point method of the reader class. """

        try:
            # in robot running mode

            # in dryrun mode, get dummy data
            if BuiltIn().dry_run_active:
                self.sources_config = self.get_test_sources()
                return True, self.sources_config

            self.sources_config = BuiltIn().get_variable_value("${testbench.audio.input.sources}")
        except RobotNotRunningError:
            # test mode
            self.sources_config = self.get_test_sources()

        # dictionary ${testbench.audio.sources} is not existing
        if self.sources_config is None:
            BuiltIn().unknown(msg='Audio input sources configuration was not found.')

        return True, self.sources_config


    def get_config(self) -> tuple[bool, dict]:
        """ Main method of the reader class. """

        try:
            # in dryrun mode, get dummy data
            if BuiltIn().dry_run_active:
                self.audio_config = self.get_test_config()
                return True, self.audio_config

            self.audio_config = BuiltIn().get_variable_value("${testbench.audio.input.channels}")
        except RobotNotRunningError:
            # test mode
            self.audio_config = self.get_test_config()

        # dictionary ${testbench.audio.channels} is not existing
        if self.audio_config is None:
            BuiltIn().unknown(msg='Audio input configuration was not found.')

        result, info = self.validate_config(self.audio_config)

        if not result:
            BuiltIn().log(message=info, level='ERROR')
            BuiltIn().fatal_error(msg='Audio configuration is not valid.')

        return True, self.audio_config


    def validate_config(self, config: dict) -> tuple[bool, str]:
        """ Validates a provided audio config for rule violations. """

        # check the input data type (expected: DotDict.DotDict)
        check = type(config) in [dict,DotDict]
        if check is False:
            return False, "No dictionary detected."

        # check if the dictionary is empty (expected: not empty)
        check = bool(config)
        if check is False:
            return False, "Dictionary is empty."

        # check if all channel names fulfill the naming conventions
        check = self.validate_naming_conventions(config)

        if check[0]:
            # check if all channels contain the predefined parameters
            check = self.validate_missing_parameters(config)

            if check[0]:
                # check if all identifier values are unique within the dictionary
                check = self.validate_duplicate_paramters(config)

        return check[0], check[1]


    @classmethod
    def validate_naming_conventions(cls, config: dict) -> tuple[bool, str]:
        """
        Validates a provided audio config for naming convention violations.
        Rule for every channel: Only letters, digits and underscores are allowed.
        """

        pattern =  '^[a-zA-Z_0-9]+$'
        info_msg = "Not allowed characters detected: '"

        _config = config.keys()
        for channel in _config:
            if len(channel) > 0:
                check = re.match(pattern, channel)
                if check is None:
                    return False, info_msg + channel + "'"
            else:
                return False, "Empty channel name detected: '" + channel + "'"

        return True, None


    def validate_missing_parameters(self, config: dict) -> tuple[bool, str]:
        """
        Validates a provided audio config for missing parameters.
        Rule for every channel: All predifined parameters must exist.
        """

        _config = config.keys()
        for channel in _config:
            for path in PARAM_PATHS_CHANNEL:
                check = self.dictionary_should_contain_parameter(config[channel], path)
                if check[0] is False:
                    return False, str(path) + " not found in channel definition: '" + channel + "'."

        return True, None


    def validate_duplicate_paramters(self, config: dict) -> tuple[bool, str]:
        """
        Validates a provided audio config for duplicate parameters.
        Rule for the dictionary: All identifier values must be unique (no duplicates allowed).
        """

        identifiers = []
        info_msg = "Duplicate 'id' value detected."

        _config = config.keys()
        for channel in _config:
            for path in PARAM_PATHS_CHANNEL:
                check = self.dictionary_should_contain_parameter(config[channel], path)
                if check[0]:
                    identifiers.append(check[1])
                else:
                    return False, str(path) + " not found in channel definition: '" + channel + "'."
            a_set = set(identifiers)
            found = len(identifiers) == len(a_set)
            if found is False:
                return False, info_msg

        return True, None
