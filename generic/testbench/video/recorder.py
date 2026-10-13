'''
Generic testbench video module library. This implements all methods and attributes
of the video recorder.
'''

from robot.libraries.BuiltIn import BuiltIn


class VideoRecorder():
    """ Methods and attributes of the video recorder. """

    states = ['error','initialized','stopped','recording','paused']
    # [0] = 'error'; [1] = 'initialized'; [2] = 'stopped'; [3] = 'recording'; [4] = 'paused'


    def __init__(self):
        self.selected_channels = {}
        self.state = None


    def set_channel_for_recording(self, item:dict) -> None:
        """ Helper function: Set an audio channel for recording. """

        self.selected_channels.clear()

        self.selected_channels.update(item)

        self.state = 'initialized'


    def start_recording(self) -> bool:
        """ Start the recording on the selected video channel(s). """

        check = BuiltIn().run_keyword('prj.testbench.video.start_recording', self.selected_channels)

        if check is True:
            self.state = 'recording'
        else:
            self.state = 'error'

        return check


    def stop_recording(self) -> bool:
        """ Stop the recording on the selected video channel(s). """

        check = BuiltIn().run_keyword('prj.testbench.video.stop_recording', self.selected_channels)

        if check is True:
            self.state = 'stopped'

        return check


    def pause_recording(self) -> bool:
        """ Pause the recording on the selected video channel(s). """

        check = BuiltIn().run_keyword('prj.testbench.video.pause_recording', self.selected_channels)

        if check is True:
            self.state = 'paused'

        return check


    def resume_recording(self) -> bool:
        """ Resume the recording on the selected video channel(s). """

        check = BuiltIn().run_keyword('prj.testbench.video.resume_recording', self.selected_channels)

        if check is True:
            self.state = 'recording'

        return check
