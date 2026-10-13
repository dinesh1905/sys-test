'''
Generic testbench tuner_am module library. This implements all methods and attributes
of a single tuner_am channel.
'''

from robot.libraries.BuiltIn import BuiltIn


class TunerChannelAM():
    """ Methods and attributes of a single tuner_am channel. """

    def __init__(self, name, config):
        self.name = name
        self.device_id = config['device']['id'] # id of the device (integer)
        self.frequency = config['frequency'] # in kHz (integer)
        self.level = config['level'] # in dBuV (float number)
        self.tone = config['tone'] # in Hz (integer)
        self.depth = config['depth'] # in % (integer)


    def set_generator_defaults(self) -> bool:
        """ Configure a signal generator for tuner output (default settings of a tuner channel). """

        check = BuiltIn().run_keyword('prj.testbench.tuner.am.set_generator_defaults', self.device_id,
                                    self.frequency, self.level, self.tone, self.depth)
        return check


    def set_parameter(self, parameter:str, value) -> bool:
        """
        Set a single parameter of a signal generator. Only predefined parameter of a AM
        tuner channel can be modified with this keyword.
        """

        check = BuiltIn().run_keyword('prj.testbench.tuner.am.set_parameter',
                                    self.device_id, parameter, value)

        return check
