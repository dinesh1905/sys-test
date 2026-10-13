from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword, library  # required when using @keyword, @library decorators
import os
import re
import glob
import time
import traceback
import msvcrt
#from project.framework.libraries.adb_commands import *
fname = "c:/tmp/_bits_rf/sequencer_cmd.txt"
fname_running = "c:/tmp/_bits_rf/sequencer_running.txt"
    
# http://patorjk.com/software/taag/#p=display&f=Small&t=PASS
SPASS = r"""^<ESC^>[92m [92m
  ___  _   ___ ___ 
 | _ \/_\ / __/ __|
 |  _/ _ \\__ \__ \
 |_|/_/ \_\___/___/
[0m"""
SFAIL = r"""^<ESC^>[91m [91m
  ___ _   ___ _    
 | __/_\ |_ _| |   
 | _/ _ \ | || |__ 
 |_/_/ \_\___|____|
[0m
"""
SERR = r"""^<ESC^>[93m [93m
  ___ ___ ___ 
 | __| _ \ _ \
 | _||   /   /
 |___|_|_\_|_\
[0m
"""


def touch_simulation(c, x_size=1280, y_size=720):
    ''' send user  touch from the vision system preview window to the scara 
    '''

    # C:\BITS_Platform\Log\VISION_IN_2021.07.03.log
    list_of_files = glob.glob(r'C:\BITS_Platform\Log\VISION_IN_*')
    latest_file = max(list_of_files, key=os.path.getctime)
    old_size = os.path.getsize(latest_file)
    x_start = 320
    x_end = 950
    
    orig_x = 1624
    orig_y = 1728
    
    #x_factor = orig_x / x_size
    x_factor = orig_x / (x_end-x_start)
    y_factor = orig_y / y_size
    while True:
        if  msvcrt.kbhit():
            msvcrt.getch()
            break
        res = check_for_ext_cmd_file(delete=False)
        if res != None:            
            break
        # check if there is a change in file
        time.sleep(0.1)
        new_size = os.path.getsize(latest_file)
        if new_size == old_size:
            continue
        old_size = new_size
        try:
            with open(latest_file, "r") as f:
                # read last line from log file
                entry = f.readlines()[-1]
        except Exception:
            #BuiltIn().log("Error: %s" % ex, console=True)
            continue        
        
        res = re.search("Vision Touch XY \((\d+) (\d+)\) (.*)", entry)        
        if res:
            
            # calculate the correct position in real device
            cmd = res.group(3)
            x1 =  int(res.group(1))
            y =  int(res.group(2))
            if x1 < x_start or x1 > x_end:
                continue
            
            # remove the offset of left border
            x = x1 - x_start
            #BuiltIn().log(f"{x1} :: {x} :: {x_start} :: {x_factor}" , console=True)
            
            x_ = int ( x * x_factor )
            y_ = int ( y * y_factor )  
            BuiltIn().log( f"Touch {x_} {y_} :: " + entry.strip(), console=True)
             
            #BuiltIn().log(f"in:{x} {y} {cmd}  new:{x_}  {y_}", console=True)            
            if cmd== "up":
                #c._run_keyword("bits.testbench.hmi: Touch and release xy", f"{x_} {y_}")
                c._run_keyword("bits.testbench.hmi: Touch and release xy", x_, y_,0.2)
            elif cmd == "down":                
                pass
                   
    
def check_for_ext_cmd_file(delete=True):
    # check if there is a external cmd file
    res = None
    if os.path.isfile(fname):        
        f = open(fname,"r")
        res =  f.readline().strip()
        f.close() 
        if delete:
            os.remove(fname) 
        BuiltIn().log("File %s %s'!" %(fname,res), console=True)
    
    if not os.path.isfile(fname_running):
        f = open(fname_running,"w")
        f.close()
        
    return res   
    
def putstr(str):
    # inject str to keyboard
    for c in str:
        msvcrt.putch(c.encode())

def input(prompt="", default=None):
    # wait for user input
    putstr(prompt)
    from_ext_file = False
    if default is None:
        data = []
    else:
        data = list(default)
        putstr(data)
    while True:
        if msvcrt.kbhit() == False:
            res = check_for_ext_cmd_file()
            if res!= None:
                from_ext_file=True
                data=list(res)
                break
                
            time.sleep(0.1)
            continue
        c = msvcrt.getch()
        o = c
        try:
            c = str(c, 'utf-8')
        except Exception as Ex:
            print (Ex)
            continue
        if c in '\r\n':
            break
        elif c == '\003': # Ctrl-C
            putstr('\r\n')
            raise KeyboardInterrupt
        elif c == '\b': # Backspace
            if data:
                putstr('\b \b') # Backspace and wipe the character cell
                data.pop()
        elif c in '\0\xe0': # Special keys
            msvcrt.getch()
        else:
            msvcrt.putch(o)
            data.append(c)
    putstr('\r\n')
    return ''.join(data), from_ext_file

@library
class sequencer:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_AUTO_KEYWORDS = False  # only decorated methods are keywords

    def __init__(self):
        self._abort_allowed = False

    def __del__(self):
        pass

    @keyword
    def checkvision(self, sParam):
        sExpected = "1"
        if "==" in sParam:
            sParam, sExpected = sParam.split("==")
            if sExpected.strip().lower() == "false" or sExpected.strip().lower() == "0":
                sExpected = "0"
            
        #sDeviceDefault = BuiltIn().get_variable_value( "${dTESTBENCH['vision']['sDefaultUnit']}" )
        #tmp_testpointname = "$[dTESTBENCH['hmi']['testpoints']['%s']['sDisplay']" % sParam.strip()               
        #sDevice = BuiltIn().get_variable_value(tmp_testpointname, sDeviceDefault)
        
        bAck, bResult = BuiltIn().run_keyword("prj.testbench.vision: Check Testpoint", sParam.strip())
        # BuiltIn().log("[%s, %s]" % (bAck, bResult), console=True)
        return bAck == True and bResult == sExpected //arshita

    @keyword
    def checkview(self, sParam):
        bResult = False
        sResult = BuiltIn().run_keyword("adb_commands.view_check_command", sParam.strip())
        BuiltIn().log("Checkwiew result: [%s]" % (sResult), console=True)
        if sResult == "True":
            bResult = True
        return bResult

    @keyword
    def checkaudio(self, sParam):
        bExpected = True
        if "==" in sParam:
            sParam, sExpected = sParam.split("==")
            if sExpected.strip().lower() == "false":
                bExpected = False

        #bAck, bResult = BuiltIn().run_keyword("testbench.Audio: Check audio", sParam.strip())
        bAck, bResult = BuiltIn().run_keyword("prj.testbench.Audio: Check audio", sParam.strip())
        
        # BuiltIn().log("[%s, %s]" % (bAck, bResult), console=True)
        return bAck == True and bResult == bExpected

    @keyword
    def touch(self, sParam):
        if "%" in sParam:
            bRelativ = True
            sParam = sParam.replace("%", "")
        else:
            bRelativ = False
        sParam1, sParam2 = sParam.split(" ")
        #bAck = BuiltIn().run_keyword("prj.sut.hmi: Touch and release xy", sParam1, sParam2, bRelativ)
        bAck = BuiltIn().run_keyword ("adb_commands.sk_command", sParam1, sParam2)
        # BuiltIn().log("[%s]" % (bAck), console=True)
        return bAck

    @keyword
    def swipe(self, sParam):
        try:
            sParam1, sParam2, sParam3, sParam4, sParam5 = sParam.split(" ")
            #bAck = BuiltIn().run_keyword("prj.sut.hmi: Touch and release xy", sParam1, sParam2, bRelativ)
            bAck = BuiltIn().run_keyword ("adb_commands.swipe_command", sParam1, sParam2, sParam3, sParam4, sParam5)
            # BuiltIn().log("[%s]" % (bAck), console=True)
        except:
            sParam1, sParam2, sParam3, sParam4 = sParam.split(" ")
            bAck = BuiltIn().run_keyword ("adb_commands.swipe_command", sParam1, sParam2, sParam3, sParam4)
        return bAck

    @keyword
    def keyevent(self, sParam):
        try:
            sParam1, sParam2 = sParam.split(" ")
        except:
            sParam1 = sParam
            sParam2 = None
        bAck = BuiltIn().run_keyword("adb_commands.key_command", sParam1, sParam2)
        # BuiltIn().log("[%s]" % bAck, console=True)
        return bAck

    @keyword
    def move_arm(self, sParam):
        if "%" in sParam:
            bRelativ = True
            sParam = sParam.replace("%", "")
        else:
            bRelativ = False
        sParam1, sParam2 = sParam.split(" ")
        bAck = BuiltIn().run_keyword("prj.sut.hmi: Move arm xy", sParam1, sParam2, bRelativ)
        # BuiltIn().log("[%s]" % (bAck), console=True)
        return bAck

    @keyword
    def swc_hu(self, sParam):
        bAck = BuiltIn().run_keyword("prj.testbench.swc: HU-Side press and release", sParam)
        # BuiltIn().log("[%s]" % bAck, console=True)
        return bAck

    def swc_ic(self, sParam):
        bAck = BuiltIn().run_keyword("prj.testbench.Audio: Check audio", sParam)
        # BuiltIn().log("[%s]" % bAck, console=True)
        return bAck

    def _sequences_get_config_path(self):
        path_ = BuiltIn().get_variable_value("${CONFIG_DIR_PROJECT}", None) + "\main_config.json"
        path_ = path_.replace("\\", "/")
        return path_

    def _sequences_reload_config(self):
        BuiltIn().run_keyword("testsuites.Testsuite_Setup", self._sequences_get_config_path())

    def _sequences_get_all(self):
        sequences = BuiltIn().get_variable_value("${SUT['hmi']['sequences']}", None)
        return sequences

    def _run_keyword(self, keyword, *sParam):
        if self._abort_allowed and msvcrt.kbhit():
            # print ("you pressed",msvcrt.getch(),"so now i will quit"
            # done = True
            raise Exception("User abort %s" % msvcrt.getch())
        
        loglevel = BuiltIn().get_variable_value("${KeywordLogging}" , 0)
        
        if int(loglevel) <= 1:
            to_console = False
        else:
            to_console = True
                        
        msg = f"Call {keyword} with {sParam}"
        BuiltIn().log( msg, console=to_console)
        if sParam != (None,) :
            res = BuiltIn().run_keyword(keyword, *sParam)
        else:
            res = BuiltIn().run_keyword(keyword)
            # BuiltIn().log("%s returns %s" % (keyword,res), console=True)
        msg = f"{keyword} returned:{res}" 
        BuiltIn().log( msg, console=to_console)
        return res

    def _execute_cmds(self, lCmds):
        res = True
        if lCmds == None:
            lCmds = []
        for raw in lCmds:
            if type(raw) == int or str(raw).isdigit():
                raw = str(raw)

            cmd = raw.strip()
            sParam = None
            sExpectedResult = True
            waittimeaftercmd = 0.1
            if "==" in raw:
                _, sExpectedResult = raw.split("==")
                # handle sleep time
            if raw.isdigit():
                raw = "sleep %s" % raw

            if raw.upper() in ["MENU", "OK", "UP", "DOWN", "LEFT", "RIGHT", "BACK"]:
                raw = "swc_hu " + raw.upper()

 
            if raw.lower().startswith("wait") or raw.lower().startswith("sleep"):
                cmd = "Sleep"
                _, sParam = raw.split(" ")
                waittimeaftercmd = 0
                sExpectedResult = None
                
            elif raw.lower().startswith("checkvision"):
                cmd = "checkvision"
                _, sParam = raw.split(" ")
            elif raw.lower().startswith("checkview"):
                cmd = "checkview"
                _, sParam = raw.split(" ")
            elif raw.lower().startswith("checkaudio"):
                cmd = "checkaudio"
                _, sParam = raw.split(" ")
            elif raw.lower().startswith("keyword"):
                cmd = raw[8:]
                if "==" in cmd:
                    cmd, _ = cmd.split("==")
                if "[" in cmd:
                    cmd,sParam = cmd.split("[")
                    sParam=sParam.replace("]","")
                    if "," in sParam:
                        sParam = sParam.split(",")
            elif raw.lower().startswith("swc_hu"):
                cmd = "swc_hu"
                _, sParam = raw.split(" ")
                sParam = sParam.upper()
            elif raw.lower().startswith("swc_ic"):
                _, sParam = raw.split(" ")
            elif raw.lower().startswith("touch"):
                cmd = "sequencer.touch"
                _, sParam1, sParam2 = raw.split(" ")
                sParam = sParam1 + " " + sParam2
            elif raw.lower().startswith("swipe"):
                cmd = "sequencer.swipe"
                try:
                    _, sParam1, sParam2, sParam3, sParam4, sParam5 = raw.split(" ")
                    sParam = sParam1 + " " + sParam2 + " " + sParam3 + " " + sParam4 + " " + sParam5
                    BuiltIn().log("long touch", console=True)
                except:
                    _, sParam1, sParam2, sParam3, sParam4 = raw.split(" ")
                    sParam = sParam1 + " " + sParam2 + " " + sParam3 + " " + sParam4
                    
            elif raw.lower().startswith("keyevent"):
                cmd = "sequencer.keyevent"
                #_, sParam1, sParam2 = raw.split(" ")
                try: 
                    _, sParam1, sParam2 = raw.split(" ")
                    sParam = sParam1 + " " + sParam2
                    BuiltIn().log("longpress", console=True)
                except:
                    _, sParam = raw.split(" ")
                    
            elif raw.lower().startswith("move_arm"):
                cmd = "sequencer.move_arm"
                _, sParam1, sParam2 = raw.split(" ")
                sParam = sParam1 + " " + sParam2
            elif raw.lower().startswith("callseq"):
                cmd = "sequence_execute"

                sExpectedResult = True, True
                
                _, sParam = raw.split(" ")
            else:
                raise Exception("Unknown sequence: %s" % raw)
            try:
                if type(sParam)==list:
                    ret = self._run_keyword( cmd, *sParam)
                else:
                    ret = self._run_keyword( cmd, sParam)
            except Exception as ex:
                trc = traceback.format_exc().split("\n")
                BuiltIn().log("%s" % trc, console=True, level="ERROR")
                BuiltIn().log("%s" % ex, console=True, level="ERROR")
                
            # if res != sExpectedResult:
            # BuiltIn().log(ret, console=True)
            if """%s""" % str(ret) != """%s""" % str(sExpectedResult):
                BuiltIn().log("Expected result not matching %s  is:%s  expected:%s" % (cmd, ret, sExpectedResult),
                              console=True)
                res = False
            time.sleep(waittimeaftercmd)
        return res

    def _get_setting(self, sName, sValue):
        default = BuiltIn().get_variable_value("${SUT['hmi']['sequences']['Default']['%s']}" % sValue, None)
        return  BuiltIn().get_variable_value("${SUT['hmi']['sequences']['%s']['%s']}" % (sName, sValue), default)

    def _do_checks(self, sVision, sView,  sAudio, tries=3):
        for x in range(1, tries + 1):
            if x != 1:
                time.sleep(1)
            if sVision == None:
                res1 = True
                BuiltIn().log("Sequencer: No vision check!", console=True)
            else:
                res1 = self.checkvision(sVision)
                # BuiltIn().log("Check Vision %s: %s" % (sVision,res1), console=True)
            if sView == None:
                res2 = True
                BuiltIn().log("Sequencer: No view check!", console=True)
            else:
                res2 = self.checkview(sView)
                #BuiltIn().log("Check View %s: %s" % (sView,res2), console=True)
            if sAudio == None:
                res3 = True
                BuiltIn().log("Sequencer: No audio check!", console=True)
            else:
                res3 = self.checkaudio(sAudio)
                # BuiltIn().log("Audio %s: %s" %(sAudio, res3), console=True)

            if True == res1 == res2 == res3:
                #BuiltIn().log("Result %s  %s  %s" %(res1, res2, res3), console=True)
                break

        return True == res1 == res2 == res3
 
    
    @keyword
    def sequence_execute(self, sName, direct_cmd=False, bExecuteChecksOnly=False):
        """
        Check the response from the previous executed keyword.
        Previous keyword have to return at least a ${bAck}.
        If ${bAck} != True the test is set to Unknown and stopped.
        | Input:
        | * sName      | Name of seqeunce to be executed
        | * direct_cmd | True: if sName is a keyword and not a sequence
        | * bExecuteChecksOnly     | True: Only checks are executed
        | Output:
        | * ${bAck} 
        | * ${sResult}
        """
        # lChecks      = self._get_setting(sName, "lChecks")
        res=BuiltIn().get_variable_value("${SUT['hmi']['sequences']['%s']}" % sName, None)
        if direct_cmd==False and res==None:
            return False, f"{sName} not exists!"
        
        sVision = self._get_setting(sName, "sVision")
        sView = self._get_setting(sName, "sView")
        sAudio = self._get_setting(sName, "sAudio")
        if direct_cmd==False:
            lSteps = self._get_setting(sName, "lSteps")
            if lSteps != None:
                for e in lSteps:
                    
                    if e==str and "  " in e:
                        return False, f"{sName} to many spaces in '{e}'!"
                        
        else:
            lSteps = [sName]
        nTries = self._get_setting(sName, "nTries")
        nSleep = self._get_setting(sName, "nSleep")
        bChecksFirst = self._get_setting(sName, "bChecksFirst")
        

        if bExecuteChecksOnly:
            BuiltIn().log("Sequencer: Execute check only for %s now " % sName, console=True)
            res = self._do_checks(sVision, sView, sAudio)            
            return res

        if bChecksFirst and (sVision != None or sView != None or sAudio != None):
            res = self._do_checks(sVision, sView, sAudio, 2)

        else:
            res = False
        
        if res != True:
            for count in range(1, nTries + 1):
                BuiltIn().log("Sequencer: Execute %s try %s of %s  sleep:%s" % (sName, count, nTries, nSleep), console=True)
                if self._execute_cmds(lSteps) != True:
                    time.sleep(nSleep)
                    continue
                if sVision != None and sVision != None and sAudio != None:
                    time.sleep(nSleep)
                res = self._do_checks(sVision, sView, sAudio)
                if res:
                    break
            
        return True, res

    @keyword
    def sequences_test(self):
        self._abort_allowed = True
        print_selection=True
         
        while True:
            #self._run_keyword("Set Additional Video Text", "wait for user input")

            defaults_found = False
            direct_cmd     = False
            
            #self._sequences_reload_config()
            

            BuiltIn().log(
                "-------------------------------------- Select a sequence -----------------------------------------------",
                console=True)
            seq = self._sequences_get_all()
            for i in range(0, len(seq.keys())):
                k = list(seq.keys())[i]
                if k == "Default":
                    defaults_found = True

                # lChecks      = self._get_setting(k, "lChecks")
                sAudio = self._get_setting(k, "sAudio")
                sVision = self._get_setting(k, "sVision")

                lSteps = self._get_setting(k, "lSteps")
                nTries = self._get_setting(k, "nTries")
                nSleep = self._get_setting(k, "nSleep")
                bChecksFirst = self._get_setting(k, "bChecksFirst")
                if print_selection:
                    BuiltIn().log("%s : %s  Vision:%s  Audio:%s   Tries:%s  ChecksFirst:%s  Sleep:%s  Seq:%s" % (
                        i + 1, k, sVision, sAudio, nTries, bChecksFirst, nSleep, lSteps), console=True)
            if defaults_found == False:
                raise ValueError("DEFAULT values not found sequence")

            BuiltIn().log("Please enter number to execute:", console=True)
            try:
                n, from_ext_file = input()
                if from_ext_file:
                    print_selection=False
                else:
                    print_selection=True
                
                        
                if n == "EXIT":
                    break
                if n == "TOUCH_SIMULATION":
                    touch_simulation(self)
                    continue                
                if  n.lower().startswith("keyword "):
                    direct_cmd = True
                    name = n
                elif n in seq:
                    name = n                                
                elif n.isdigit():
                    n = int(n)
                    if n < 0 or n > len(seq.keys()):                
                        raise RuntimeError("Selection '%s' not exists!" % n)
                    name = list(seq.keys())[n - 1]
                else:                
                    BuiltIn().log("Unexpected input:'%s'!" %n, console=True)
                    continue
                
                self._sequences_reload_config()
                                
                #BuiltIn().run_keyword("Set Additional Video Text", "Sequence: %s" % name)
                _, res = self.sequence_execute(name,direct_cmd)
                if res == True:
                    BuiltIn().log("\n" + SPASS, console=True)
                else:
                    BuiltIn().log("\n" + SFAIL, console=True)
                    BuiltIn().log("Expected: True  Is:%s" % res, console=True)
            except Exception as ex:
                trc = traceback.format_exc().split("\n")
                BuiltIn().log("%s" % ex, console=True, level="ERROR")
                BuiltIn().log( "%s" % traceback.format_exc(), console=True)

                # for e in trc:
                #    BuiltIn().log( e, console=True )
                BuiltIn().log("\n" + SERR, console=True)

                continue
        if os.path.exists(fname_running):
            os.remove(fname_running)
        
    @keyword
    def select_current_source(self, iTestCaseTotalCount):
        #sSource = "GOTO_TUNER_FM,GOTO_TUNER_AM"
        sSource = BuiltIn().get_variable_value("${dTESTS['reliability']['sSources']}", 0) 
        #iSourceSwitchValue = 3
        iSourceSwitchValue = BuiltIn().get_variable_value("${dTESTS['reliability']['nSourceSwitchValue']}", 0) 
        #iTestCaseTotalCount = BuiltIn().get_variable_value("${dTESTS['poweroffon']['nIterations']}", 0)
        srcmap = []
        for e in sSource.split(","):
            srcmap += [e] * iSourceSwitchValue
        if iTestCaseTotalCount == 0:
            activesrc = srcmap[ iTestCaseTotalCount % len (srcmap)].strip()
        else:
            activesrc = srcmap[ iTestCaseTotalCount % len (srcmap) -1 ].strip()
        tt = "cycle %s '%s'" % (iTestCaseTotalCount , activesrc) 
        BuiltIn().log("SourceLastRound %s" % tt, console=True)
        return activesrc

    @keyword
    def select_current_powerofftime(self, iTestCaseTotalCount):
        sCommand = BuiltIn().get_variable_value("${SUT['reliability']['poweroffon']['runtimewait']}", 0)
        iCommandSwitchValue = BuiltIn().get_variable_value("${SUT['reliability']['poweroffon']['ntimerswitch']}", 0) 
        cmdmap = []
        for e in sCommand.split(","):
            cmdmap += [e] * iCommandSwitchValue
        if iTestCaseTotalCount == 0:
            activesrc = cmdmap[ iTestCaseTotalCount % len (cmdmap)].strip()
        else:
            activesrc = cmdmap[ iTestCaseTotalCount % len (cmdmap) -1 ].strip()
        tt = "cycle %s '%s'" % (iTestCaseTotalCount , activesrc) 
        BuiltIn().log("poweroffontimerlastround %s" % tt, console=True)
        return activesrc

    @keyword
    def select_current_wuwrespond(self, iTestCaseTotalCount):
        sWuwrespond = BuiltIn().get_variable_value("${SUT['audio']['tts']['nwuwrespond']}", 0)
        iCommandSwitchValue = BuiltIn().get_variable_value("${SUT['audio']['tts']['ncommandswitch']}", 0) 
        wuwresmap = []
        for e in sWuwrespond.split(","):
            wuwresmap += [e] * iCommandSwitchValue
        if iTestCaseTotalCount == 0:
            activeid = wuwresmap[ iTestCaseTotalCount % len (wuwresmap)].strip()
        else:
            activeid = wuwresmap[ iTestCaseTotalCount % len (wuwresmap) -1 ].strip()
        tt = "cycle %s '%s'" % (iTestCaseTotalCount , activeid) 
        BuiltIn().log("WuwResLastRound %s" % tt, console=True)
        return activeid
