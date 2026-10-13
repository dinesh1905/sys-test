'''
Generic testbench tuner module library. This implements all methods and attributes
of a single tuner channel.
'''

from robot.libraries.BuiltIn import BuiltIn


class TunerChannelDAB():
    """ Methods and attributes of a single tuner channel. """

    def __init__(self, name, config):
        self.name = name
        self.device_id = config['device']['id'] # id of the device (integer)
        self.frequency = config['frequency'] # a in MHz (float number)
        self.level = config['level'] # in dBuV (float number)


    def set_generator_defaults(self) -> bool:
        """ Configure a signal generator for tuner output (default settings of a tuner channel). """

        check = BuiltIn().run_keyword('prj.testbench.tuner.dab.set_generator_defaults',
                                    self.device_id, self.frequency, self.level)
        return check


    def set_parameter(self, parameter:str, value) -> bool:
        """
        Set a single parameter of a signal generator. Only predefined parameter of a DAB
        tuner channel can be modified with this keyword.
        """

        check = BuiltIn().run_keyword('prj.testbench.tuner.dab.set_parameter',
                                    self.device_id, parameter, value)

        return check
