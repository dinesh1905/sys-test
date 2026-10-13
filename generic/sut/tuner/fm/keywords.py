""" Generic sut tuner fm module """

# import Robotframework API
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


@library
class keywords():  #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic sut tuner fm keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    @keyword
    def set_audio_source(self, source:str) -> bool:
        """
        Set FM as the active audio source and select an FM band.\n
        = Interfaces =\n
        IN:  ``source`` (str): FM band (FM1, FM2, ...) to set.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        #ack = False
        info_text = "Found unknown error while executing 'tuner_tuner.Set Audio Source'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.tuner: Set audio source', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_audio_source(self, source:str) -> tuple[bool, bool]:
        """
        Check if an FM is the active audio source and a specific FM band is selected.\n
        = Interfaces =\n
        IN:    ``source`` (str): FM band (FM1, FM2, ...) to check.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init local variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'tuner_tuner.Check Audio Source'."

        ack, result = BuiltIn().run_keyword('prj.sut.tuner.tuner: Check audio source', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result


    @keyword
    def set_frequency(self, source:str, frequency:float) -> bool:
        """
        Set a frequency as tuned FM frequency.\n
        = Interfaces =\n
        IN_1: ``source`` (str): FM band (FM1, FM2, ...).\n
        IN_2: ``frequency`` (float): FM frequency (in MHz) to set.\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_tuner.Set Frequency'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.tuner: Set frequency', source, frequency)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_tuned_frequency(self, source:str, frequency:float) -> tuple[bool, bool]:
        """
        Check if a frequency is the tuned FM frequency.\n
        = Interfaces =\n
        IN_1:  ``source`` (str): FM band (FM1, FM2, ...).\n
        IN_2:  ``frequency`` (float): FM frequency (in MHz) to check.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init local variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'tuner_tuner.Check Tuned Frequency."

        ack, result = BuiltIn().run_keyword('prj.sut.tuner.tuner: Check tuned frequency', source, frequency)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result


    @keyword
    def skip_to_previous_frequency(self, source:str) -> bool:
        """
        Skip to the previous FM frequency. Does not mean the previous FM station.\n
        = Interfaces =\n
        IN:  ``source`` (str): FM band (FM1, FM2, ...).\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_tuner.Skip To Previous Frequency'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.tuner: Skip to previous frequency', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def skip_to_next_frequency(self, source:str) -> bool:
        """
        Skip to the next FM frequency. Does not mean the next FM station.\n
        = Interfaces =\n
        IN:  ``source`` (str): FM band (FM1, FM2, ...).\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_tuner.Skip To Next Frequency'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.tuner: Skip to next frequency', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def store_tuned_station_as_preset(self, source:str, preset:int) -> bool:
        """
        Store a tuned FM station as preset.\n
        = Interfaces =\n
        IN_1: ``source`` (str): FM band (FM1, FM2, ...).\n
        IN_2: ``preset`` (int): Preset number ('electronic bookmark').\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_tuner.Store Tuned Station As Preset."

        ack = BuiltIn().run_keyword('prj.sut.tuner.tuner: Store tuned station as preset', source, preset)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def activate_preset(self, source:str, preset:int) -> bool:
        """
        Tune a preset FM station.\n
        = Interfaces =\n
        IN_1: ``source`` (str): FM band (FM1, FM2, ...).\n
        IN_2: ``preset`` (int): Preset number ('electronic bookmark') to activate.\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_tuner.Activate Preset'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.tuner: Activate preset', source, preset)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_preset(self, source:str, preset:int) -> tuple[bool, bool]:
        """
        Check if a tuned FM station is successfully stored as preset or if it was activated.\n
        = Interfaces =\n
        IN_1:  ``source`` (str): FM band (FM1, FM2, ...).\n
        IN_2:  ``preset`` (int): Preset number ('electronic bookmark') to check.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init LOCAL variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'tuner_tuner.Check Preset."

        ack, result = BuiltIn().run_keyword('prj.sut.tuner.tuner: Check preset', source, preset)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result
