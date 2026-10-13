'''
Generic testbench power module library. This checks if the configuration
of the power module is valid.
'''

import re
from RobotFramework_TestsuitesManagement.Config.CConfig import DotDict
from robot.libraries.BuiltIn import BuiltIn, RobotNotRunningError


PARAM_PATHS_1 = [['output','voltage','id'],
                 ['measurement','voltage','id'],
                 ['measurement','current','id']]
PARAM_PATHS_2 = [['output','voltage','limit','max'],
                 ['output','voltage','limit','min']]
PATH_DEPTH = 5
"""
level 1: channel name;
level 2: ['output','measurement'];
level 3: ['voltage','current'];
level 4: ['id','limit'];
level 5: ['max','min']
"""


class PowerReader():
    """ Checks if a given dictionary is valid. """

    def __init__(self):
        self.power_config = None


    @classmethod
    def get_test_config(cls) -> dict:
        """ Helper function to load a special configuration in case of test mode. """

        test_config = {
            "SUT_Power" : {
                "output" : {
                    "voltage" : {
                        "id" : "Battery",
                        "limit" : {
                            "max" : 12.0,
                            "min" : 1.0
                        }
                    }
                },
                "measurement" : {
                    "voltage" : {
                        "id" : "U0meas"
                    },
                    "current" : {
                        "id" : "Battery_Current"
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


    def get_depth(self, config: dict) -> int:
        """ Helper function to determine the dictionary path depth. """

        return max(self.get_depth(v) if isinstance(v,dict) else 0 for v in config.values()) + 1


    def get_config(self) -> tuple[bool, dict]:
        """ Main method of the reader class. """

        try:
            # in robot running mode

            # in dryrun mode, get dummy data
            if BuiltIn().dry_run_active:
                self.power_config = self.get_test_config()
                return True, self.power_config

            self.power_config = BuiltIn().get_variable_value("${testbench.power.channels}")
        except RobotNotRunningError:
            # test mode
            self.power_config = self.get_test_config()

        # dictionary ${testbench.power.channels} is not existing
        if self.power_config is None:
            BuiltIn().unknown(msg='Power configuration was not found.')

        result, info = self.validate_config(self.power_config)

        if not result:
            BuiltIn().log(message=info, level='ERROR')
            BuiltIn().fatal_error(msg='Power configuration is not valid.')

        return True, self.power_config


    def validate_config(self, config: dict) -> tuple[bool, str]:
        """ Validates a provided power config for rule violations. """

        # check the input data type (expected: DotDict.DotDict)
        check = type(config) in [dict,DotDict]
        if check is False:
            return False, "No dictionary detected."

        # check if the dictionary is empty (expected: not empty)
        check = bool(config)
        if check is False:
            return False, "Dictionary is empty."

        # check the path depth of the dictionary (expected: 4)
        check = self.get_depth(config)
        if check != PATH_DEPTH:
            return False, "Dictionary has wrong path depth (expected: " + str(PATH_DEPTH) + ")."

        # check if all channel names fulfill the naming conventions
        check = self.validate_naming_conventions(config)

        if check[0]:
            # check if all channels contain the predefined parameters
            check = self.validate_missing_parameters(config)

            if check[0]:
                # check if all identifier values are unique within the dictionary
                check = self.validate_duplicate_paramters(config)

                if check[0]:
                    # check if all output voltage limits within the dictionary are numbers
                    check = self.validate_type_violations(config)

                    if check[0]:
                        # check if all output voltage ranges are valid
                        check = self.validate_voltage_limits(config)

        return check[0], check[1]


    @classmethod
    def validate_naming_conventions(cls, config: dict) -> tuple[bool, str]:
        """
        Validates a provided power config for naming convention violations.
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
        Validates a provided power config for missing parameters.
        Rule for every channel: All predifined parameters must exist.
        """

        _config = config.keys()
        for channel in _config:
            for path in PARAM_PATHS_1+PARAM_PATHS_2:
                check = self.dictionary_should_contain_parameter(config[channel], path)
                if check[0] is False:
                    return False, str(path) + " not found in channel definition: '" + channel + "'."

        return True, None


    def validate_duplicate_paramters(self, config: dict) -> tuple[bool, str]:
        """
        Validates a provided power config for duplicate parameters.
        Rule for the dictionary: All identifier values must be unique (no duplicates allowed).
        """

        identifiers = []
        info_msg = "Duplicate 'id' value detected."

        _config = config.keys()
        for channel in _config:
            for path in PARAM_PATHS_1:
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


    def validate_type_violations(self, config: dict) -> tuple[bool, str]:
        """
        Validates a provided power config for type violations.
        Rule for every channel: data type of 'max' and 'min' are not defined as strings.
        """

        info_msg = "Type violation detected (limits): '"

        _config = config.keys()
        for channel in _config:
            for path in PARAM_PATHS_2:
                check = self.dictionary_should_contain_parameter(config[channel], path)
                if check[0]:
                    result = type(check[1]) in [int,float]
                    if result is False:
                        return False, info_msg + channel + "'"
                else:
                    return False, str(path) + " not found in channel definition: '" + channel + "'."

        return True, None


    def validate_voltage_limits(self, config: dict) -> tuple[bool, str]:
        """
        Validates a provided power config for output voltage limit violations.
        Rule for every channel: 0 <= min < max
        """

        info_msg = "Rule violation detected (voltage limits): '"

        _config = config.keys()
        for channel in _config:
            limits = []
            for path in PARAM_PATHS_2:
                check = self.dictionary_should_contain_parameter(config[channel], path)
                if check[0]:
                    limits.append(check[1])
                else:
                    return False, str(path) + " not found in channel definition: '" + channel + "'."
            if limits[0] <= limits[1] or limits[1] < 0:
                return False, info_msg + channel + "'"

        return True, None
