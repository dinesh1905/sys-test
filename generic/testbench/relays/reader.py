
'''
Generic testbench relays module library. This checks if the configuration
of the relays module is valid.
'''

import re
from RobotFramework_TestsuitesManagement.Config.CConfig import DotDict
from robot.libraries.BuiltIn import BuiltIn, RobotNotRunningError


PARM_PATHS_RELAYS = [ ['port','id'] ]


class RelaysReader():
    """ Checks if a given dictionary is valid. """

    def __init__(self):
        self.relays_config = None


    @classmethod
    def get_test_config(cls) -> dict:
        """ Helper function to load a special configuration in case of test mode """

        test_config = {
            "Conrad_1" : {
                "port" : {
                    "id" : "GPIB_PORT_1"
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


    def get_config(self) -> tuple[bool, dict]:
        """ Main method of the reader class. """

        try:
            # in robot running mode

            # in dryrun mode, get dummy data
            if BuiltIn().dry_run_active:
                self.relays_config = self.get_test_config()
                return True, self.relays_config

            self.relays_config = BuiltIn().get_variable_value("${testbench.relays.channels}")
        except RobotNotRunningError:
            # test mode
            self.relays_config = self.get_test_config()

        # dictionary ${testbench.relays.channels} is not existing
        if self.relays_config is None:
            BuiltIn().unknown(msg='Relays configuration was not found.')

        result, info = self.validate_config(self.relays_config)

        if not result:
            BuiltIn().log(message=info, level='ERROR')
            BuiltIn().fatal_error(msg='Relays configuration is not valid.')

        return True, self.relays_config


    def validate_config(self, config: dict) -> tuple[bool, str]:
        """ Validates a provided relays config for rule violations. """

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
        Validates a provided relays config for naming convention violations.
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
        Validates a provided relays config for missing parameters.
        Rule for every channel: All predifined parameters must exist.
        """

        _config = config.keys()
        for channel in _config:
            for path in PARM_PATHS_RELAYS:
                check = self.dictionary_should_contain_parameter(config[channel], path)
                if check[0] is False:
                    return False, str(path) + " not found in channel definition: '" + channel + "'."

        return True, None


    def validate_duplicate_paramters(self, config: dict) -> tuple[bool, str]:
        """
        Validates a provided relays config for duplicate parameters.
        Rule for the dictionary: All identifier values must be unique (no duplicates allowed).
        """

        identifiers = []
        info_msg = "Duplicate 'id' value detected."

        _config = config.keys()
        for channel in _config:
            for path in PARM_PATHS_RELAYS:
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
