'''
Generic testbench audio input module library. This implements all methods and attributes
of the audio input recorder.
'''

from robot.libraries.BuiltIn import BuiltIn


class AudioRecorder():
    """ Methods and attributes of the audio recorder. """

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
        """ Start the recording on the selected audio channel(s). """

        check = BuiltIn().run_keyword('prj.testbench.audio.input.start_recording', self.selected_channels)

        if check is True:
            self.state = 'recording'
        else:
            self.state = 'error'

        return check


    def stop_recording(self) -> bool:
        """ Stop the recording on the selected audio channel(s). """

        check = BuiltIn().run_keyword('prj.testbench.audio.input.stop_recording', self.selected_channels)

        if check is True:
            self.state = 'stopped'

        return check


    def pause_recording(self) -> bool:
        """ Pause the recording on the selected audio channel(s). """

        check = BuiltIn().run_keyword('prj.testbench.audio.input.pause_recording', self.selected_channels)

        if check is True:
            self.state = 'paused'

        return check


    def resume_recording(self) -> bool:
        """ Resume the recording on the selected audio channel(s). """

        check = BuiltIn().run_keyword('prj.testbench.audio.input.resume_recording', self.selected_channels)

        if check is True:
            self.state = 'recording'

        return check
