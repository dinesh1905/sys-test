'''
Generic testbench audio input module library. This implements all audio input methods and attributes
of a single audio input source.
'''


class AudioSource(): #pylint: disable=C0103:invalid-name disable=R0903:too-few-public-methods
    """ Methods and attributes of a single audio source. """

    def __init__(self, name, config):
        self.name = name
        self.source_type = config['type']
        self.source_id = config['id']
