'''
Generic testbench tuner module library. This checks if the configuration
of the tuner module is valid.
'''

import re
from RobotFramework_TestsuitesManagement.Config.CConfig import DotDict
from robot.libraries.BuiltIn import BuiltIn, RobotNotRunningError

PARAM_PATHS_ALL = [['device','id'],
                   ['frequency'],
                   ['level']]
PARAM_PATHS_AM  = [['depth'],['tone']]
PARAM_PATHS_DAB = []
PARAM_PATHS_FM  = [['deviation'],['tone']]
PARAM_PATHS_RDS = [['slot'],['tone']]


class TunerReader():
    """ Checks if a given dictionary is valid. """

    def __init__(self, submodule):
        self.tuner_config = None
        self.submodule = submodule


    @classmethod
    def get_test_config(cls) -> dict:
        """ Helper function to load a special configuration in case of test mode """

        test_config = {
            "SG1_FM" : {
                "device" : {
                    "id" : 1
                },
                "frequency" : 98.0, # MHz
                "level" : 70.0, # dBuV
                "tone" : 1000, # Hz
                "deviation" : 22, # kHz
                "depth" : None, # in %
                "slot" : None # a number between 0 and 63
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
                self.tuner_config = self.get_test_config()
                return True, self.tuner_config

            if self.submodule == "AM":
                self.tuner_config = BuiltIn().get_variable_value("${testbench.tuner.am.channels}")
            elif self.submodule == "DAB":
                self.tuner_config = BuiltIn().get_variable_value("${testbench.tuner.dab.channels}")
            elif self.submodule == "FM":
                self.tuner_config = BuiltIn().get_variable_value("${testbench.tuner.fm.channels}")
            elif self.submodule == "RDS":
                self.tuner_config = BuiltIn().get_variable_value("${testbench.tuner.rds.channels}")
            else:
                self.tuner_config = None
        except RobotNotRunningError:
            # test mode
            self.tuner_config = self.get_test_config()

        if self.tuner_config is None:
            BuiltIn().unknown(msg='Tuner configuration was not found.')

        result, info = self.validate_config(self.tuner_config)
        if not result:
            BuiltIn().log(message=info, level='ERROR')
            BuiltIn().fatal_error(msg='Tuner configuration is not valid.')

        return True, self.tuner_config


    def validate_config(self, config: dict) -> tuple[bool, str]:
        """ Validates a provided tuner config for rule violations. """

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

        return check[0], check[1]


    @classmethod
    def validate_naming_conventions(cls, config: dict) -> tuple[bool, str]:
        """
        Validates a provided tuner config for naming convention violations.
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
        Validates a provided tuner config for missing parameters.
        Rule for every channel: All predifined parameters must exist.
        """

        # Determine submodule specific param paths
        if self.submodule == "AM":
            specific_param_paths = PARAM_PATHS_AM
        elif self.submodule == "DAB":
            specific_param_paths = PARAM_PATHS_DAB
        elif self.submodule == "FM":
            specific_param_paths = PARAM_PATHS_FM
        elif self.submodule == "RDS":
            specific_param_paths = PARAM_PATHS_RDS
        else:
            specific_param_paths = []

        _config = config.keys()
        for channel in _config:
            for path in PARAM_PATHS_ALL+specific_param_paths:
                check = self.dictionary_should_contain_parameter(config[channel], path)
                if check[0] is False:
                    return False, str(path) + " not found in channel definition: '" + channel + "'."

        return True, None
