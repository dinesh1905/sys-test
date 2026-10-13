'''
Generic testbench tuner_rds module library. This implements all methods and attributes
of a single tuner_rds channel.
'''

from robot.libraries.BuiltIn import BuiltIn


class TunerChannelRDS():
    """ Methods and attributes of a single tuner_rds channel. """

    def __init__(self, name, config):
        self.name = name
        self.device_id = config['device']['id'] # id of the device (integer)
        self.frequency = config['frequency'] # in MHz (float number)
        self.level = config['level'] # in dBuV (float number)
        self.tone = config['tone'] # in Hz (integer)
        self.slot_number = config['slot'] # a number between 0 and 63 (integer)


    def set_coder_defaults(self) -> bool:
        """ Configure a RDS coder for tuner output (default settings of  tuner channel). """

        check = BuiltIn().run_keyword('prj.testbench.tuner.rds.set_coder_defaults',
                                    self.device_id, self.frequency, self.level, self.tone, self.slot_number)
        return check


    def set_parameter(self, parameter:str, value) -> bool:
        """
        Set a single parameter of a RDS coder. Only predefined parameter of a FM_RDS
        tuner channel can be modified with this keyword.
        """

        check = BuiltIn().run_keyword('prj.testbench.tuner.rds.set_parameter',
                                    self.device_id, parameter, value)

        return check


    def load_slot_list(self, file_path:str) -> bool:
        """ Load a slot list into a RDS Coder. """

        check = BuiltIn().run_keyword('prj.testbench.tuner.rds.load_slot_list',
                                    self.device_id, file_path)
        return check
