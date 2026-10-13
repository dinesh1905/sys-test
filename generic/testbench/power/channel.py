'''
Generic testbench power module library. This implements all methods and attributes
of a single power channel.
'''

from robot.libraries.BuiltIn import BuiltIn


class PowerChannel():
    """ Methods and attributes of a single power channel. """

    def __init__(self, name, config):
        self.name = name
        self.output_voltage_limit_min = config['output']['voltage']['limit']['min']
        self.output_voltage_limit_max = config['output']['voltage']['limit']['max']
        self.output_voltage_id = config['output']['voltage']['id']
        self.output_voltage_initial_value = None
        self.measurement_voltage_id = config['measurement']['voltage']['id']
        self.measurement_current_id = config['measurement']['current']['id']


    def check_output_voltage_range(self, voltage:float) -> bool:
        """ Checks if the set value 'voltage' is within the limits defined in the configuration. """

        # Check ouput limits
        if voltage > self.output_voltage_limit_max or voltage < self.output_voltage_limit_min:
            return False

        return True


    def set_output_voltage(self, voltage: float) -> bool:
        """ Sets output voltage to a given value. """

        check = self.check_output_voltage_range(voltage)
        if not check:
            BuiltIn().skip(msg='Output voltage out of the defined limits (min, max).')

        check = BuiltIn().run_keyword('prj.testbench.power.set_output_voltage',
                                      self.output_voltage_id, voltage)

        return check


    def measure_current(self) -> tuple[bool, float]:
        """ Triggers a single measurement of electric current. """

        check, current = BuiltIn().run_keyword('prj.testbench.power.measure_current', self.measurement_current_id)

        return check, current


    def measure_voltage(self) -> tuple[bool, float]:
        """ Triggers a single measurement of electric voltage. """

        check, voltage = BuiltIn().run_keyword('prj.testbench.power.measure_voltage', self.measurement_voltage_id)

        return check, voltage
