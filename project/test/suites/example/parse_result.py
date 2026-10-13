#!/usr/bin/python
from robot.api import ExecutionResult, ResultVisitor
from robot.libraries.BuiltIn import BuiltIn
import sys, json, re
import os
from datetime import datetime
import mysql.connector

class MyResultVisitor(ResultVisitor):
    def __init__(self, categories):
        self.results = []
        self.AUTO_FLASHING_FAIL = 0
        self.AUTO_FLASHING_PASS = 0
        self.AUTO_FLASHING_TOTAL = 0
        self.AUTO_FLASHING_EXECUTIONTIME = 0
        self.ENTRY_FAIL = 0
        self.ENTRY_PASS = 0
        self.ENTRY_TOTAL = 0
        self.ENTRY_EXECUTIONTIME = 0
        self.FULLTEST_FAIL = 0
        self.FULLTEST_PASS = 0
        self.FULLTEST_TOTAL = 0
        self.FULLTEST_EXECUTIONTIME = 0
        self.categories = categories
        self.category_stats = {category: {'total_tests': 0, 'pass_tests': 0, 'fail_tests': 0, 'execution_time': 0} for category in categories}
        self.requirement_status = {}

    def _extract_fids_from_tags(self, tags):
        fids = set()
        for tag in tags:
            matches = re.findall(r'FID-([\d\.,\s]+)', str(tag))
            for match in matches:
                for fid in match.split(","):
                    fid = fid.strip().strip(".")
                    if "." in fid:
                        fid = fid.split(".")[-1]
                    fid = re.sub(r"\D", "", fid)
                    if fid:
                        fids.add(fid)
        return fids

    def _update_requirement_status(self, fid, status):
        if status == "SKIP":
            return
        if status in ["FAIL", "UNKNOWN"]:
            self.requirement_status[fid] = "FAILED"
        elif status == "PASS":
            if self.requirement_status.get(fid) != "FAILED":
                self.requirement_status[fid] = "PASSED"

    def visit_test(self, test):
        testcase_id = ""
        requirements = []
        for tag in test.tags:
            tag_clean = tag.strip()
            tag_upper = tag_clean.upper()

            # TCID extraction (case insensitive)
            if tag_upper.startswith("TCID-"):
               testcase_id = tag_clean[5:].strip()

            # FID extraction (case insensitive)
            if tag_upper.startswith("FID-"):
               fid_value = tag_clean[4:].strip()
               fid_parts = fid_value.split(",")

               for fid in fid_parts:
                  fid = fid.strip()
                  if "." in fid:
                     req = fid.split(".")[-1].strip()
                  else:
                     req = fid

                  requirements.append(req)

        # remove duplicates
        requirements = list(set(requirements))

        self.results.append({
            'TESTCASE_ID': testcase_id,
            'REQUIREMENTS': requirements,
            'TESTCASE': test.name,
            'STATUS': test.status,
            'REASON': test.message
        })

        execution_time = float(test.elapsedtime)

        if "AUTO_FLASHING" in test.tags:
            self.AUTO_FLASHING_TOTAL += 1
            self.AUTO_FLASHING_EXECUTIONTIME += execution_time
            if test.status in ['FAIL', 'UNKNOWN']:
                self.AUTO_FLASHING_FAIL += 1
            elif test.status == 'PASS':
                self.AUTO_FLASHING_PASS += 1

        if "ENTRY" in test.tags:
            self.ENTRY_TOTAL += 1
            self.ENTRY_EXECUTIONTIME += execution_time
            if test.status in ['FAIL', 'UNKNOWN']:
                self.ENTRY_FAIL += 1
            elif test.status == 'PASS':
                self.ENTRY_PASS += 1

        if "FULLTEST" in test.tags:
            self.FULLTEST_TOTAL += 1
            self.FULLTEST_EXECUTIONTIME += execution_time
            if test.status in ['FAIL', 'UNKNOWN']:
                self.FULLTEST_FAIL += 1
            elif test.status == 'PASS':
                self.FULLTEST_PASS += 1

        for category in self.categories:
            if category in test.tags:
                self.category_stats[category]['total_tests'] += 1
                self.category_stats[category]['execution_time'] += execution_time
                if test.status == 'PASS':
                    self.category_stats[category]['pass_tests'] += 1
                elif test.status in ['FAIL', 'UNKNOWN']:
                    self.category_stats[category]['fail_tests'] += 1
                break

        for fid in self._extract_fids_from_tags(test.tags):
            self._update_requirement_status(fid, test.status)


if __name__ == '__main__':
    try:
        if len(sys.argv) == 4:
            categories = ['SWDOWNLOAD','POWER','CustomerDiagnostic','SAFETY','COMMUNICATION','SOC','Memory','Mcu']
            test_results_json_path = sys.argv[2]
            BUILD_NUMBER = sys.argv[3]
            result = ExecutionResult(sys.argv[1])
            result.configure()
            visitor = MyResultVisitor(categories)
            result.visit(visitor)

            TOTAL_AUTO_FLASHING = visitor.AUTO_FLASHING_TOTAL
            TOTAL_ENTRY = visitor.ENTRY_TOTAL
            TOTAL_FULLTEST = visitor.FULLTEST_TOTAL

            PASS_AUTO_FLASHING = visitor.AUTO_FLASHING_PASS
            PASS_ENTRY = visitor.ENTRY_PASS
            PASS_FULLTEST = visitor.FULLTEST_PASS

            FAIL_AUTO_FLASHING = visitor.AUTO_FLASHING_FAIL
            FAIL_ENTRY = visitor.ENTRY_FAIL
            FAIL_FULLTEST = visitor.FULLTEST_FAIL

            print("error here")
            AUTO_FLASHING_EXECUTION_TIME = (visitor.AUTO_FLASHING_EXECUTIONTIME/1000)
            print("error here")
            ENTRY_EXECUTION_TIME = (visitor.ENTRY_EXECUTIONTIME/1000)
            FULLTEST_EXECUTION_TIME = (visitor.FULLTEST_EXECUTIONTIME/1000)

            AUTO_FLASHING_PASS_PERCENT = (PASS_AUTO_FLASHING/TOTAL_AUTO_FLASHING)*100 if TOTAL_AUTO_FLASHING > 0 else 0.0
            print("error here")
            ENTRY_PASS_PERCENT = (PASS_ENTRY/TOTAL_ENTRY)*100 if TOTAL_ENTRY > 0 else 0.0
            FULLTEST_PASS_PERCENT = (PASS_FULLTEST/TOTAL_FULLTEST)*100 if TOTAL_FULLTEST > 0 else 0.0

            AUTO_FLASHING_TIME_MMSS = "{:02}:{:02}".format(*divmod(int(AUTO_FLASHING_EXECUTION_TIME), 60))
            ENTRY_TIME_MMSS = "{:02}:{:02}".format(*divmod(int(ENTRY_EXECUTION_TIME), 60))
            FULLTEST_TIME_MMSS = "{:02}:{:02}".format(*divmod(int(FULLTEST_EXECUTION_TIME), 60))

            total = AUTO_FLASHING_TIME_MMSS + ENTRY_TIME_MMSS + FULLTEST_TIME_MMSS
            total1 = AUTO_FLASHING_EXECUTION_TIME + ENTRY_EXECUTION_TIME + FULLTEST_EXECUTION_TIME
            
            
            
            
            # Totals
            PASS_TOTAL = visitor.AUTO_FLASHING_PASS + visitor.ENTRY_PASS + visitor.FULLTEST_PASS
            FAIL_TOTAL = visitor.AUTO_FLASHING_FAIL + visitor.ENTRY_FAIL + visitor.FULLTEST_FAIL

            data = {
                "total_pass": PASS_TOTAL,
                "total_fail": FAIL_TOTAL,
                "testcase_info": visitor.results
            }

 # Extract statistics for each category
            category_stats = []
            total_tests_sum = 0
            pass_tests_sum = 0
            fail_tests_sum = 0
            total_execution_time_sum = 0

            for category in categories:
                total_tests = visitor.category_stats[category]['total_tests']
                pass_tests = visitor.category_stats[category]['pass_tests']
                fail_tests = visitor.category_stats[category]['fail_tests']
                execution_time = (visitor.category_stats[category]['execution_time'])/1000
                execution_time_str = "{:02}:{:02}".format(*divmod(int(execution_time), 60))

                pass_percentage = (pass_tests / total_tests) * 100 if total_tests > 0 else 0.0

                category_stats.append({
                    'component_name': category,
                    'total_tests': total_tests,
                    'pass_tests': pass_tests,
                    'fail_tests': fail_tests,
                    'execution_time': execution_time_str,
                    'pass_percentage': pass_percentage
                })

                total_tests_sum += total_tests
                pass_tests_sum += pass_tests
                fail_tests_sum += fail_tests
                total_execution_time_sum += execution_time

            overall_pass_percentage = (pass_tests_sum / total_tests_sum) * 100 if total_tests_sum > 0 else 0.0
            total_execution_time_str = "{:02}:{:02}".format(*divmod(int(total_execution_time_sum), 60))
            summary = {
                'component_name': 'Total',
                'total_tests': total_tests_sum,
                'pass_tests': pass_tests_sum,
                'fail_tests': fail_tests_sum,
                'pass_percentage': overall_pass_percentage,
                'execution_time': total_execution_time_str
            }
            category_stats.append(summary)
            print(f"{category_stats}")


            testcase_info = visitor.results
            updated_testcase_info = []
            for item in testcase_info:
                if item['STATUS'] == 'SKIP':
                    continue
                elif item['STATUS'] == 'UNKNOWN':
                    item['STATUS'] = 'FAIL'
                updated_testcase_info.append(item)

            req_status = visitor.requirement_status  # {"123":"PASSED", "124":"FAILED"}
            total_requirements = len(req_status)
            passed_requirements = sum(1 for v in req_status.values() if v == "PASSED")
            failed_requirements = sum(1 for v in req_status.values() if v == "FAILED")

            req_pass_percent = (passed_requirements / total_requirements) * 100 if total_requirements else 0.0
            req_fail_percent = (failed_requirements / total_requirements) * 100 if total_requirements else 0.0

            # Optional: list for reporting
            requirements_status_list = [
                {"Requirement": k, "Status": v}
                for k, v in sorted(req_status.items(), key=lambda x: float(x[0]))
            ]
            data = {}
 
            data['total_auto_flashing'] = TOTAL_AUTO_FLASHING
            data['total_entry'] = TOTAL_ENTRY
            data['total_fulltest'] = TOTAL_FULLTEST

            data['auto_flashing_passed'] = PASS_AUTO_FLASHING
            data['entry_passed'] = PASS_ENTRY
            data['fulltest_passed'] = PASS_FULLTEST

            data['auto_flashing_failed'] = FAIL_AUTO_FLASHING
            data['entry_failed'] = FAIL_ENTRY
            data['fulltest_failed'] = FAIL_FULLTEST

            data['milli_sec_autoflashing_execution_time'] = AUTO_FLASHING_TIME_MMSS
            data['milli_sec_entry_execution_time'] = ENTRY_TIME_MMSS
            data['milli_sec_fulltest_execution_time'] = FULLTEST_TIME_MMSS

            data['total_time'] = "{:02}:{:02}".format(*divmod(int(AUTO_FLASHING_EXECUTION_TIME + ENTRY_EXECUTION_TIME + FULLTEST_EXECUTION_TIME), 60)) if (AUTO_FLASHING_EXECUTION_TIME + ENTRY_EXECUTION_TIME + FULLTEST_EXECUTION_TIME) > 0 else 0.0

            data['autoflashing_execution_time'] = AUTO_FLASHING_TIME_MMSS
            data['entry_execution_time'] = ENTRY_TIME_MMSS
            data['fulltest_execution_time'] = FULLTEST_TIME_MMSS

            data['autoflashing_pass_percent'] = "{:.2f}".format(AUTO_FLASHING_PASS_PERCENT)
            data['entry_pass_percent'] = "{:.2f}".format(ENTRY_PASS_PERCENT)
            data['fulltest_pass_percent'] = "{:.2f}".format(FULLTEST_PASS_PERCENT)

            pass_percentage = ((PASS_AUTO_FLASHING + PASS_ENTRY + PASS_FULLTEST)/ (TOTAL_AUTO_FLASHING +TOTAL_ENTRY + TOTAL_FULLTEST)) * 100 if (TOTAL_AUTO_FLASHING +TOTAL_ENTRY + TOTAL_FULLTEST) > 0 else 0.0
            data['total_pass_per'] = "{:.2f}".format(pass_percentage)

            data['testcase_summary'] = category_stats
            data['testcase_info'] = updated_testcase_info

            data['total_requirements'] = total_requirements
            data['passed_requirements'] = passed_requirements
            data['failed_requirements'] = failed_requirements
            data['requirements_pass_percent'] = "{:.2f}".format(req_pass_percent)
            data['requirements_fail_percent'] = "{:.2f}".format(req_fail_percent)

            data['requirements_status'] = requirements_status_list

            with open(test_results_json_path, 'w') as json_file:
                json.dump(data, json_file, indent=4)

            # ==============================
            #  REQUIREMENTS COUNT (NEW)
            # ==============================
            passed_requirements = 0
            failed_requirements = 0

            for status in visitor.requirement_status.values():
                if status == "PASSED":
                    passed_requirements += 1
                elif status == "FAILED":
                    failed_requirements += 1
                    # Save main JSON
                    with open(test_results_json_path, 'w') as f:
                        json.dump(data, f, indent=4)

            # ==============================
            #  DB INSERT (NEW)
            # ==============================
            conn = mysql.connector.connect(
                host="10.214.83.236",
                user="testuser",
                password="Maasdev@12345",
                database="maas_blade_test_results"
            )

            cursor = conn.cursor()

            cursor.execute("""
            INSERT INTO testcase_summary (build_number, timestamp, total_pass, total_fail)
            VALUES (%s, NOW(), %s, %s)
            """, (
                BUILD_NUMBER,
                PASS_TOTAL,
                FAIL_TOTAL
            ))

            cursor.execute("""
            INSERT INTO requirements_summary (build_number, timestamp, passed_requirements, failed_requirements)
            VALUES (%s, NOW(), %s, %s)
            """, (
                BUILD_NUMBER,
                passed_requirements,
                failed_requirements
            ))

            conn.commit()
            # ======================
            # FETCH LAST 10 (TESTCASE)
            # ======================
            cursor.execute("""
            SELECT build_number, timestamp, total_pass, total_fail
            FROM testcase_summary
            ORDER BY timestamp DESC
            LIMIT 10
            """)
            tc_data = cursor.fetchall()[::-1]

            # ======================
            # FETCH LAST 10 (REQUIREMENTS)
            # ======================
            cursor.execute("""
            SELECT build_number, timestamp, passed_requirements, failed_requirements
            FROM requirements_summary
            ORDER BY timestamp DESC
            LIMIT 10
            """)
            req_data = cursor.fetchall()[::-1]

            cursor.close()
            conn.close()

            # ======================
            # CHARTS
            # ======================
            import matplotlib.pyplot as plt
            import numpy as np



            # ===== TESTCASE CHART =====
            if tc_data:
                labels = [f"{b}\n{t.strftime('%H:%M:%S')}" for b,t,_,_ in tc_data]
                pass_vals = [p for _,_,p,_ in tc_data]
                fail_vals = [f for _,_,_,f in tc_data]

                x = np.arange(len(labels))

                plt.figure()
                plt.bar(x-0.2, pass_vals, 0.4, label="Pass")
                plt.bar(x+0.2, fail_vals, 0.4, label="Fail")

                plt.xticks(x, labels, rotation=45)
                plt.legend()
                plt.tight_layout()
                base_dir = os.path.dirname(test_results_json_path)
                plt.savefig(os.path.join(base_dir, "testcase_chart.png"))
                plt.close()

            # ===== REQUIREMENTS CHART =====
            if req_data:
                labels = [f"{b}\n{t.strftime('%H:%M:%S')}" for b,t,_,_ in req_data]
                pass_vals = [p for _,_,p,_ in req_data]
                fail_vals = [f for _,_,_,f in req_data]

                x = np.arange(len(labels))

                plt.figure()
                plt.bar(x-0.2, pass_vals, 0.4, label="Pass")
                plt.bar(x+0.2, fail_vals, 0.4, label="Fail")

                plt.xticks(x, labels, rotation=45)
                plt.legend()
                plt.tight_layout()

                plt.savefig(os.path.join(base_dir, "requirements_chart.png"))
                plt.close()

            print("Charts generated from DB")
        else:
            BuiltIn().log(f"Insufficient or too many arguments: {str(len(sys.argv) - 1)} provided,Expected {3}", 'INFO', False, True)
    except Exception as e:
        BuiltIn().log(f"Error: {e}", 'ERROR')
        sys.exit(1)
