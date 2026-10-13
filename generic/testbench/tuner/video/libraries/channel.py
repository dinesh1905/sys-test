'''
Generic testbench video module library. This implements all methods and attributes
of a single video channel.
'''

from robot.libraries.BuiltIn import BuiltIn


class VideoChannel():
    """ Methods and attributes of a single video channel. """

    states = ['initialized','stopped','capturing'] # [0] = 'initialized'; [1] = 'stopped'; [2] = 'capturing'


    def __init__(self, name, config):
        self.name = name
        self.source = config['source']['sId']
        self.volume_level = config['volume']['sId']
        self.track_id = config['track']['sId']
        self.track_position = config['track']['position']['sId']
        self.state = None


    def get_video_source(self) -> tuple[bool, str]:
        """ Get the allocated source on the requested video channel. """

        check, source = BuiltIn().run_keyword('prj.testbench.video.get_video_source', self.source)

        return check, source


    def get_volume(self) -> tuple[bool, int]:
        """ Get the volume on the requested video channel. """

        check, volume = BuiltIn().run_keyword('prj.testbench.video.get_volume', self.volume_level)

        return check, volume


    def get_track_id(self) -> tuple[bool, int]:
        """ Get the id of the active track on the requested video channel. """

        check, track_id = BuiltIn().run_keyword('prj.testbench.video.get_track_id', self.track_id)

        return check, track_id


    def get_track_position(self) -> tuple[bool, int]:
        """ Get the time position of the active track on the requested video channel. """

        check, track_position = BuiltIn().run_keyword('prj.testbench.video.get_track_position',
                                                    self.track_position)

        return check, track_position
