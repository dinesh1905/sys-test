'''
Generic testbench power module. This implements all power commands in generic way by means of
abstract keywords indedepended from any specific testbench setup.
'''

from robotlibcore import DynamicCore, keyword
from robot.libraries.BuiltIn import BuiltIn
from generic.testbench.power.manager import PowerManager
from generic.framework.framework import framework


class keywords(DynamicCore): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic testbench power module. It contain all the implemented generic keywords
    that can be used in TA-Framework test cases. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        self.manager = PowerManager()
        libraries = []
        DynamicCore.__init__(self, libraries)


    def check_if_channel_exists(self, channel_name) -> bool:
        """ Helper function to check if a power channel with the given name exist. """

        if channel_name not in self.manager.power_channels:
            return False

        return True


    @keyword
    def set_output_voltage(self, channel_name, voltage) -> bool:
        """
        Sets provided power output channel to a given voltage.\n
        = Interfaces =\n
        IN_1: ``channel_name`` (str): Name of the power supply output channel, e.g. BATTERY.\n
        IN_2: ``voltage`` (float): Output voltage to be set on given power supply channel. Value
        in volts [V].\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'power.Set Output Voltage'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An power channel with the given name is not existing.",
                          level='WARN')
            return False

        # data type conversion for arguments
        try:
            voltage = float(voltage)
        except (TypeError, ValueError):
            BuiltIn().skip(msg=f"ValueError: Argument 'voltage' got value '{voltage}' that cannot \
            be converted to float.")

        try:
            channel_name = str(channel_name)
        except (TypeError, ValueError):
            BuiltIn().skip(msg=f"ValueError: Argument 'channel_name' got value '{channel_name}' \
            that cannot be converted to str.")

        ack = self.manager.power_channels[channel_name].set_output_voltage(voltage)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def measure_current(self, channel_name: str) -> tuple[bool, float]:
        """
        Triggers a single measurement of electric current on the requested power channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the power channel to be measured.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``current`` (float): Measured value of electric current [A].
        """

        # init local variables
        ack = None
        current = -9999
        info_text = "Found unknown error while executing 'power.Measure Current'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An power channel with the given name is not existing.",
                          level='WARN')
            return False, None

        ack, current = self.manager.power_channels[channel_name].measure_current()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        if ack and not isinstance(current, float):
            try:
                float(current)
            except TypeError:
                BuiltIn().log(message="'current' has the wrong type (expected: float) and cannot be converted.",
                              level='WARN')
                return False, None

        return ack, current


    @keyword
    def measure_voltage(self, channel_name: str) -> tuple[bool, float]:
        """
        Triggers a single measurement of electric voltage on the requested power channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the power channel to be measured.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``voltage``(float): Measured value of electric voltage [V].
        """

        # init local variables
        ack = None
        voltage = -9999
        info_text = "Found unknown error while executing 'power.Measure Voltage'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An power channel with the given name is not existing.",
                          level='WARN')
            return False, None

        ack, voltage = self.manager.power_channels[channel_name].measure_voltage()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        if ack and not isinstance(voltage, float):
            try:
                float(voltage)
            except TypeError:
                BuiltIn().log(message="'voltage' has the wrong type (expected: float) and cannot be converted.",
                              level='WARN')
                return False, None

        return ack, voltage
