""" Generic sut tuner am module """

# import Robotframework API
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


@library
class keywords():  #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic sut tuner am keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    @keyword
    def set_audio_source(self, source:str) -> bool:
        """
        Set AM as the active audio source and select an AM band.\n
        = Interfaces =\n
        IN:  ``source`` (str): AM band (AM1, AM2, ...) to set.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_am.Set Audio Source'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.am: Set audio source', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_audio_source(self, source:str) -> tuple[bool, bool]:
        """
        Check if an AM is the active audio source and a specific AM band is selected.\n
        = Interfaces =\n
        IN:    ``source`` (str): AM band (AM1, AM2, ...) to check.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init local variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'tuner_am.Check Audio Source'."

        ack, result = BuiltIn().run_keyword('prj.sut.tuner.am: Check audio source', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result


    @keyword
    def set_frequency(self, source:str, frequency:float) -> bool:
        """
        Set a frequency as tuned AM frequency.\n
        = Interfaces =\n
        IN_1: ``source`` (str): AM band (AM1, AM2, ...).\n
        IN_2: ``frequency`` (float): AM frequency (in kHz) to set.\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_am.Set Frequency'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.am: Set frequency', source, frequency)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_tuned_frequency(self, source:str, frequency:float) -> tuple[bool, bool]:
        """
        Check if a frequency is the tuned AM frequency.\n
        = Interfaces =\n
        IN_1:  ``source`` (str): AM band (AM1, AM2, ...).\n
        IN_2:  ``frequency`` (float): AM frequency (in kHz) to check.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init local variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'tuner_am.Check Tuned Frequency."

        ack, result = BuiltIn().run_keyword('prj.sut.tuner.am: Check tuned frequency', source, frequency)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result


    @keyword
    def skip_to_previous_frequency(self, source:str) -> bool:
        """
        Skip to the previous AM frequency. Does not mean the previous AM station.\n
        = Interfaces =\n
        IN:  ``source`` (str): AM band (AM1, AM2, ...).\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_am.Skip To Previous Frequency'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.am: Skip to previous frequency', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def skip_to_next_frequency(self, source:str) -> bool:
        """
        Skip to the next AM frequency. Does not mean the next AM station.\n
        = Interfaces =\n
        IN:  ``source`` (str): AM band (AM1, AM2, ...).\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_am.Skip To Next Frequency'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.am: Skip to next frequency', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def store_tuned_station_as_preset(self, source:str, preset:int) -> bool:
        """
        Store a tuned AM station as preset.\n
        = Interfaces =\n
        IN_1: ``source`` (str): AM band (AM1, AM2, ...).\n
        IN_2: ``preset`` (int): Preset number ('electronic bookmark').\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_am.Store Tuned Station As Preset."

        ack = BuiltIn().run_keyword('prj.sut.tuner.am: Store tuned station as preset', source, preset)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def activate_preset(self, source:str, preset:int) -> bool:
        """
        Tune a preset AM station.\n
        = Interfaces =\n
        IN_1: ``source`` (str): AM band (AM1, AM2, ...).\n
        IN_2: ``preset`` (int): Preset number ('electronic bookmark') to activate.\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'tuner_am.Activate Preset'."

        ack = BuiltIn().run_keyword('prj.sut.tuner.am: Activate preset', source, preset)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_preset(self, source:str, preset:int) -> tuple[bool, bool]:
        """
        Check if a tuned AM station is successfully stored as preset or if it was activated.\n
        = Interfaces =\n
        IN_1:  ``source`` (str): AM band (AM1, AM2, ...).\n
        IN_2:  ``preset`` (int): Preset number ('electronic bookmark') to check.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init LOCAL variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'tuner_am.Check Preset."

        ack, result = BuiltIn().run_keyword('prj.sut.tuner.am: Check preset', source, preset)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result
