'''
Generic testbench relays module library. This implements all methods and attributes
of a single relay channel.
'''

from robot.libraries.BuiltIn import BuiltIn


class RelaysChannel():
    """ Methods and attributes of a single relay channel. """

    def __init__(self, name, config):
        self.name = name
        self.port = config['port']['id']


    def set_switch_position(self, switch_position:str) -> bool:
        """ Set the switch position. """

        check = BuiltIn().run_keyword('prj.testbench.relays.set_switch_position', self.port, switch_position)

        return check


    def get_switch_position(self) -> tuple[bool, object]:
        """" Get the switch position. """

        check, switch_position = BuiltIn().run_keyword('prj.testbench.relays.get_switch_position', self.port)

        return check, switch_position
