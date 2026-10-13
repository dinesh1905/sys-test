pipeline {
    
    
    agent{
        label "PG9-C-001XA"
    }
    //label "testfarm"
    
    stages {
        stage("Lock resource") {
            steps {
                script {
                    properties([
                        parameters([
                            string(name: 'FRAMEWORK_PATH', defaultValue: 'C:/BITSRF/projects/CT_Execution/sys_test', description: 'Mention on which HW resources this test should be run', trim: true),
                            string(name: 'AURIX_URL', defaultValue: 'https://rb-cmbinex-pg-p1.apac.bosch.com/artifactory/maas-aurix-images/MAAS_AURIX_PI24.3.0_RC1/MAAS_AURIX_PI24.3.0_RC1_B1.zip', description: 'Mention the url to download aurix', trim: true),
                            string(name: 'SOC_HYPERVISOR_URL', defaultValue: 'https://rb-cmbinex-pg-p1.apac.bosch.com/artifactory/maas-soc-images/MAAS_SOC_hqx_4.5.6.0_r00006.3_PI24.3.0_RC1/MAAS_SOC_hqx_4.5.6.0_r00006.3_PI24.3.0_RC1.zip', description: 'Mention the url to download Hypervisor soc', trim: true),
                            string(name: 'SOC_SANDBOX_URL', defaultValue: 'https://rb-cmbinex-pg-p1.apac.bosch.com/artifactory/maas-soc-images/MAAS_SOC_hqx_4.5.6.0_r00006.3_PI24.3.0_RC1/MAAS_SOC_hqx_4.5.6.0_r00006.3_PI24.3.0_RC1.zip', description: 'Mention the url to download Sandbox soc', trim: true),
                            string(name: 'SOC_FLAT_URL', defaultValue: 'https://rb-cmbinex-pg-p1.apac.bosch.com/artifactory/maas-soc-images/MAAS_SOC_hqx_4.5.6.0_r000011.1_PI25.3.0_RC7/IMAGES/FLAT/rb_maas_out-flat_images_CSW.zip', description: 'Mention the url to download flat soc', trim: true),
                            string(name: 'SOC_FLAT_HYPERVISOR_URL', defaultValue: 'https://rb-cmbinex-pg-p1.apac.bosch.com/artifactory/maas-soc-images/MAAS_SOC_hqx_4.5.6.0_r00006.3_PI24.3.0_RC1/MAAS_SOC_hqx_4.5.6.0_r00006.3_PI24.3.0_RC1.zip', description: 'Mention the url to download flat Hypervisor soc', trim: true),
                            string(name: 'SOC_FLAT_SANDBOX_URL', defaultValue: 'https://rb-cmbinex-pg-p1.apac.bosch.com/artifactory/maas-soc-images/MAAS_SOC_hqx_4.5.6.0_r00006.3_PI24.3.0_RC1/MAAS_SOC_hqx_4.5.6.0_r00006.3_PI24.3.0_RC1.zip', description: 'Mention the url to download flat Sandbox soc', trim: true),
                            string(name: 'AURIXDEBUG_URL', defaultValue: 'https://rb-cmbinex-pg-p1.apac.bosch.com/artifactory/maas-aurix-images/MAAS_AURIX_PI25.1.0_RC2/MAAS_AURIX_PI25.1.0_RC2_B1_Debug.zip', description: 'Mention the url to download cdt', trim: true),
                            string(name: 'ETH_URL', defaultValue: 'https://rb-cmbinex-pg-p1.apac.bosch.com/artifactory/maas-generic/ETHSWT/MAAS_ETHSWT_25.04.00_SEC/MAAS_ETHSWT_25.04.00_SEC_PRJ.zip', description: 'Mention the url to download ETH Switch', trim: true),
                            string(name: 'AURIXDEBUG_VERSION', defaultValue: 'MAAS_AURIX_PI24.2.0_004_b1', description: 'Mention the version of aurix', trim: true),
                            string(name: 'AURIX_VERSION', defaultValue: 'MAAS_AURIX_PI24.2.0_004_b1', description: 'Mention the version of aurix', trim: true),
                            string(name: 'SOC_VERSION', defaultValue: 'MAAS_SOC_hqx_4.5.5.0_r00004.1b_PI24.2.0_003', description: 'Mention the version of soc', trim: true),
                            string(name: 'SAIL_VERSION', defaultValue: 'SAIL.SI.1.0.c3-00045-AU.LEMANS-1', description: 'Mention the version of sail', trim: true),
                            string(name: 'ETH_VERSION', defaultValue: 'MAAS_ETHSWT_25.04.00_SEC_PRJ', description: 'Mention the version of ETH Switch', trim: true),
                            string(name: 'PCSUTSERIALNUMBERJENKINS', defaultValue: 'F77C8595', description: 'Mention the version of soc', trim: true),
                            booleanParam(name: 'TRIGGER_REMOTE', defaultValue: false , description: 'remote trigger to send result'),
                            booleanParam(name: 'EMAIL_RESULTS', defaultValue: true, description: 'Do you want to send results via Email?'),
                            booleanParam(name: 'KDS_FLASH', defaultValue: true, description: 'Do you want to flash KDS?'),
                            booleanParam(name: 'HSM_ENABLE', defaultValue:true, description: 'IMPORTANT!!!'),
                            
                            
                        ])
                        ])
                        
                        def deletereportpath=" rm -f ${params.FRAMEWORK_PATH}/test_results.json && rm -r ${params.FRAMEWORK_PATH}/report/*"
                        def returnStatus_4 = sh(script:deletereportpath, returnStatus:true)

                        def flashingcommand = "C:/BITS/RobotFramework/python39/python -m robot.run --pythonpath ${params.FRAMEWORK_PATH} --pythonpath C:/BITS_Platform --pythonpath C:/BITS_RF/db_client/interfaces --variable TESTBENCH_CONFIG_PATH:project/testbench/bench_local --variable SUT_CONFIG_PATH:project/sut/all_sut --variable SETUP_CONFIG_PATH:project/setup/default --variable FRAMEWORK_CONFIG_PATH:project/framework/default --variable testbench_configuration:bench_local --variable sut_configuration:all_sut --variable setup_configuration:default --variable test_configuration:default --variable framework_configuration:default --variable TAF_PATH:${params.FRAMEWORK_PATH} --variable BP_PATH:C:/BITS_Platform --variable DB_PATH:C:/BITS_RF/db_client --variable Aurix_Version:${AURIX_VERSION} --variable SOC_Version:${SOC_VERSION} --variable ETH_Version:${ETH_VERSION} --variable Aurix_URL:${AURIX_URL} --variable SOC_HYPERVISOR_URL:${SOC_HYPERVISOR_URL} --variable SOC_SANDBOX_URL:${SOC_SANDBOX_URL} --variable ETH_URL:${ETH_URL} --variable SOC_FLAT_URL:${SOC_FLAT_URL} --variable SOC_FLAT_HYPERVISOR_URL:${SOC_FLAT_HYPERVISOR_URL} --variable SOC_FLAT_SANDBOX_URL:${SOC_FLAT_SANDBOX_URL} --variable KDS_FLASH:${KDS_FLASH} --variable HSM_ENABLE:${HSM_ENABLE} --variable PCSUTSERIALNUMBERJENKINS:${PCSUTSERIALNUMBERJENKINS} -b MessageLog.txt -d ${params.FRAMEWORK_PATH}/report/auto_flashing  --suite flashing_secureboot  ${params.FRAMEWORK_PATH}"
                        
                        def returnStatus = sh(script:flashingcommand, returnStatus:true)
                        print "Return status: $returnStatus"
                        
                        def proc = "curl -u toa8pg1:AP8UXuw7x3VGAEZXfPMKN9Ffk64 -sS https://rb-cmbinex-fe-p1.de.bosch.com:443/artifactory/maas-biaas-sys-test/pi_release_25.3/${env.build_number}/auto_flashing/ -T '{C:/BITSRF/projects/CT_Execution/sys_test/report/auto_flashing/log.html,C:/BITSRF/projects/CT_Execution/sys_test/report/auto_flashing/output.xml,C:/BITSRF/projects/CT_Execution/sys_test/report/auto_flashing/report.html}'"
                        // def res = sh(script:proc)
                        
                        //copy to a comman place for email later
                        def copyoutputfile_flashing = "cp C:/BITSRF/projects/CT_Execution/sys_test/report/auto_flashing/output.xml C:/BITSRF/projects/CT_Execution/sys_test/report/"
                        def copyoutputfile_flashing_2 = sh(script:copyoutputfile_flashing, returnStatus:true)
                        
                        if(returnStatus == 0){
                            echo 'Flashing was successfull.Now run the Entry Test '
                             
                            

                            def EntryTest = "C:/BITS/RobotFramework/python39/python -m robot.run --pythonpath ${params.FRAMEWORK_PATH} --pythonpath C:/BITS_Platform --pythonpath C:/BITS_RF/db_client/interfaces --variable TESTBENCH_CONFIG_PATH:project/testbench/bench_local --variable SUT_CONFIG_PATH:project/sut/all_sut --variable SETUP_CONFIG_PATH:project/setup/default --variable FRAMEWORK_CONFIG_PATH:project/framework/default --variable testbench_configuration:bench_local --variable sut_configuration:all_sut --variable setup_configuration:default --variable test_configuration:default --variable framework_configuration:default --variable TAF_PATH:${params.FRAMEWORK_PATH} --variable BP_PATH:C:/BITS_Platform --variable DB_PATH:C:/BITS_RF/db_client --variable Aurix_Version:${AURIX_VERSION} --variable SOC_Version:${SOC_VERSION} --variable Aurix_URL:${AURIX_URL} -b MessageLog.txt -d ${params.FRAMEWORK_PATH}/report/entry_test  --suite entry_test_nightly_build  ${params.FRAMEWORK_PATH}"
                            def returnStatusEntryTest = sh(script:EntryTest, returnStatus:true)
                            print "Return status: $returnStatusEntryTest"
                            
                            //copy to a comman place for email later
                            def copyoutputfile_entry = "cp 'C:/BITSRF/projects/CT_Execution/sys_test/report/entry_test/output.xml' C:/BITSRF/projects/CT_Execution/sys_test/report/output2.xml"
                            def copyoutputfile_entry_2 = sh(script:copyoutputfile_entry, returnStatus:true)
                            
                            // def entrytestres = "curl -u toa8pg1:AP8UXuw7x3VGAEZXfPMKN9Ffk64 -sS https://rb-cmbinex-fe-p1.de.bosch.com:443/artifactory/maas-biaas-sys-test/pi_release_25.3/${env.build_number}/entry_test/ -T '{C:/BITSRF/projects/CT_Execution/sys_test/report/entry_test/log.html,C:/BITSRF/projects/CT_Execution/sys_test/report/entry_test/output.xml,C:/BITSRF/projects/CT_Execution/sys_test/report/entry_test/report.html}'"
                            // def resupload = sh(script:entrytestres)
                            
                            if(returnStatusEntryTest == 0){
                                echo 'Entry test was successfull.'
                                echo 'Now run full test.'
                                
                                def FullTest = "C:/BITS/RobotFramework/python39/python -m robot.run --pythonpath ${params.FRAMEWORK_PATH} --pythonpath C:/BITS_Platform --pythonpath C:/BITS_RF/db_client/interfaces --variable TESTBENCH_CONFIG_PATH:project/testbench/bench_local --variable SUT_CONFIG_PATH:project/sut/all_sut --variable SETUP_CONFIG_PATH:project/setup/default --variable FRAMEWORK_CONFIG_PATH:project/framework/default --variable testbench_configuration:bench_local --variable sut_configuration:all_sut --variable setup_configuration:default --variable test_configuration:default --variable framework_configuration:default --variable TAF_PATH:${params.FRAMEWORK_PATH} --variable BP_PATH:C:/BITS_Platform --variable DB_PATH:C:/BITS_RF/db_client --variable Aurix_Version:${AURIX_VERSION} --variable SOC_Version:${SOC_VERSION} --variable Aurix_URL:${AURIX_URL} --variable SAIL_VERSION:${SAIL_VERSION} --variable SOC_HYPERVISOR_URL:${SOC_HYPERVISOR_URL} --variable SOC_SANDBOX_URL:${SOC_SANDBOX_URL} --variable KDS_FLASH:${KDS_FLASH} --variable HSM_ENABLE:${HSM_ENABLE} --variable PCSUTSERIALNUMBERJENKINS:${PCSUTSERIALNUMBERJENKINS} --variable AurixDebug_URL:${AURIXDEBUG_URL} --variable AurixDebug_Version:${AURIXDEBUG_VERSION} -b MessageLog.txt -d ${params.FRAMEWORK_PATH}/report/full_test  --suite Full_Test  ${params.FRAMEWORK_PATH}"
                                def returnStatusFullTest = sh(script:FullTest, returnStatus:true)
                                print "Return status: $returnStatusFullTest"
                                
                                //copy to a comman place for email later
                                def copyoutputfile_full = "cp 'C:/BITSRF/projects/CT_Execution/sys_test/report/full_test/output.xml' C:/BITSRF/projects/CT_Execution/sys_test/report/output3.xml"
                                def copyoutputfile_full_2 = sh(script:copyoutputfile_full, returnStatus:true)
                                
                                def fulltestres = "curl -u toa8pg1:AP8UXuw7x3VGAEZXfPMKN9Ffk64 -sS https://rb-cmbinex-fe-p1.de.bosch.com:443/artifactory/maas-biaas-sys-test/pi__release_25.3/full_test/ -T '{C:/BITSRF/projects/CT_Execution/sys_test/report/full_test/log.html,C:/BITSRF/projects/CT_Execution/sys_test/report/full_test/output.xml,C:/BITSRF/projects/CT_Execution/sys_test/report/full_test/report.html}'"
                                def resuploadFulltest = sh(script:fulltestres)
                                if(returnStatusFullTest == 0){
                                    echo 'Full test was successfull.'
                                  //  def Remote_trigger = "curl -X POST -u toa8pg1:1179b8633763fb5266e2eb49e87324c15a -sS https://rb-jmaas.de.bosch.com/XC_CT_PG_MAAS/job/MaaS/job/Nightly%20Build/job/SysTest_Completion_Trigger/buildWithParameters?token=NIGHTLY\\&ARTIFACTORY_LINK=https://rb-cmbinex-fe-p1.de.bosch.com:443/artifactory/maas-biaas-sys-test/nightly_build/${env.build_number}/"
                                 //   def Remote_trigger_launch = sh(script:Remote_trigger)
                                } else{
                                    echo 'Full test was not successful.'
                                 //   def Remote_trigger = "curl -X POST -u toa8pg1:1179b8633763fb5266e2eb49e87324c15a -sS https://rb-jmaas.de.bosch.com/XC_CT_PG_MAAS/job/MaaS/job/Nightly%20Build/job/SysTest_Completion_Trigger/buildWithParameters?token=NIGHTLY\\&ARTIFACTORY_LINK=https://rb-cmbinex-fe-p1.de.bosch.com:443/artifactory/maas-biaas-sys-test/nightly_build/${env.build_number}/"
                                  //  def Remote_trigger_launch = sh(script:Remote_trigger)
                                    currentBuild.result = 'FAILURE'
                                }
                                    
                            
                            } else{
                                echo 'Entry test was not successful.'
                               // def Remote_trigger = "curl -X POST -u toa8pg1:1179b8633763fb5266e2eb49e87324c15a -sS https://rb-jmaas.de.bosch.com/XC_CT_PG_MAAS/job/MaaS/job/Nightly%20Build/job/SysTest_Completion_Trigger/buildWithParameters?token=NIGHTLY\\&ARTIFACTORY_LINK=https://rb-cmbinex-fe-p1.de.bosch.com:443/artifactory/maas-biaas-sys-test/nightly_build/${env.build_number}/"
                               // def Remote_trigger_launch = sh(script:Remote_trigger)
                                currentBuild.result = 'FAILURE'
                            }
                        } else{
                            
                            print "Flashing was not successful with status code $returnStatus"
                            echo "Trigger  is ${env.TRIGGER_REMOTE}"
                           // def Remote_trigger = "curl -X POST -u toa8pg1:1179b8633763fb5266e2eb49e87324c15a -sS https://rb-jmaas.de.bosch.com/XC_CT_PG_MAAS/job/MaaS/job/Nightly%20Build/job/SysTest_Completion_Trigger/buildWithParameters?token=NIGHTLY\\&ARTIFACTORY_LINK=https://rb-cmbinex-fe-p1.de.bosch.com:443/artifactory/maas-biaas-sys-test/nightly_build/${env.build_number}/"
                            //def Remote_trigger_launch = sh(script:Remote_trigger)

                          
                            currentBuild.result = 'FAILURE'
                        }
                        
                     
                        
                                                
                       

                       
                    }
                }
            }
        }
    post{
        always{
            script {
                    print "hello"
                    parsed_list = []
                    ARTIFACTORY_REPORT_URL_autoflashing ="https://rb-cmbinex-fe-p1.de.bosch.com/artifactory/maas-biaas-sys-test/pi_release_25.3/${env.build_number}/auto_flashing/report.html#totals"
                    ARTIFACTORY_REPORT_URL_entrytest ="https://rb-cmbinex-fe-p1.de.bosch.com/artifactory/maas-biaas-sys-test/pi_release_25.3/${env.build_number}/entry_test/report.html#totals"
                    ARTIFACTORY_REPORT_URL_fulltest ="https://rb-cmbinex-fe-p1.de.bosch.com/artifactory/maas-biaas-sys-test/pi_release_25.3/${env.build_number}/full_test/report.html#totals"
                    print "hello000"
                    if (params.EMAIL_RESULTS){
                        stage('Send_Mail'){
                            print "************************************************************"
                            def emailoutput = "cd C:/BITSRF/projects/CT_Execution/sys_test/report && \"C:\\BITS\\RobotFramework\\python39\\python.exe\" -m robot.rebot -o merged.xml --merge output*.xml"
                            def returnStatus_3 = sh(script:emailoutput, returnStatus:true)


                            def output = "C:/BITS/RobotFramework/python39/python ${params.FRAMEWORK_PATH}/project/test/suites/example/parse_result.py ${params.FRAMEWORK_PATH}/report/merged.xml ${params.FRAMEWORK_PATH}/test_results.json \"${SOC_VERSION}\""

                            def returnStatus_2 = sh(script:output, returnStatus:true)
                            def testResultJson = readJSON(file:"${params.FRAMEWORK_PATH}/test_results.json")
                            //def sample = testResultJson['sample']
                            //def hw_part_no = testResultJson['hw_part_no']
                            //def aurix_sw = testResultJson['aurix_sw_ver']
                            
                            def total_auto_flashing = testResultJson['total_auto_flashing']
                            def total_entry = testResultJson['total_entry']
                            def total_fulltest = testResultJson['total_fulltest']
                            def auto_flashing_passed = testResultJson['auto_flashing_passed']
                            def entry_passed = testResultJson['entry_passed']
                            def fulltest_passed = testResultJson['fulltest_passed']
                            def auto_flashing_failed = testResultJson['auto_flashing_failed']
                            def entry_failed = testResultJson['entry_failed']
                            def fulltest_failed= testResultJson['fulltest_failed']
                
                            def autoflashing_execution_time = testResultJson['autoflashing_execution_time']
                            def entry_execution_time = testResultJson['entry_execution_time']
                            def fulltest_execution_time = testResultJson['fulltest_execution_time']
                            
                            def milli_sec_autoflashing_execution_time = testResultJson['milli_sec_autoflashing_execution_time']
                            def milli_sec_entry_execution_time = testResultJson['milli_sec_entry_execution_time']
                            def milli_sec_fulltest_execution_time = testResultJson['milli_sec_fulltest_execution_time']
                            def total_time = testResultJson['total_time']
                            
                            def autoflashing_pass_percent = testResultJson['autoflashing_pass_percent']
                            def entry_pass_percent = testResultJson['entry_pass_percent']
                            def fulltest_pass_percent = testResultJson['fulltest_pass_percent']
                            def total_pass_per = testResultJson['total_pass_per']
                                    
                            def testcase_summary = testResultJson['testcase_summary']
                            def testcase_info = testResultJson['testcase_info']
                            def critical_failed = testResultJson['critical_failed']
			    def total_requirements = testResultJson['total_requirements']
                            def passed_requirements = testResultJson['passed_requirements']
                            def failed_requirements = testResultJson['failed_requirements']
                            def requirements_pass_percent = testResultJson['requirements_pass_percent']
                            def requirements_fail_percent = testResultJson['requirements_fail_percent']
                            def sourcePath1 = "${env.FRAMEWORK_PATH}/results/testcase_chart.png"
                            def sourcePath2 = "${env.FRAMEWORK_PATH}/results/requirements_chart.png"
                            def destinationPath = "${env.WORKSPACE}".replace('\\', '/')

                            parse_output = sh(script:
                               """ "${env.RF_PATH}"  "${env.FRAMEWORK_PATH}/project/test/libraries/SWIT/trend_chart_analysis.py" "${sourcePath1}" "${destinationPath.replace('\\', '/')}" """, returnStdout: true).trim()
                            parse_output = sh(script:
                               """ "${env.RF_PATH}"  "${env.FRAMEWORK_PATH}/project/test/libraries/SWIT/trend_chart_analysis.py" "${sourcePath2}" "${destinationPath.replace('\\', '/')}" """, returnStdout: true).trim()
                            parsed_list = [testcase_summary,testcase_info,critical_failed,total_auto_flashing,total_entry,total_fulltest,auto_flashing_passed,entry_passed,fulltest_passed,auto_flashing_failed,entry_failed,fulltest_failed,autoflashing_execution_time,entry_execution_time,fulltest_execution_time,milli_sec_autoflashing_execution_time,milli_sec_entry_execution_time,milli_sec_fulltest_execution_time,autoflashing_pass_percent,entry_pass_percent,fulltest_pass_percent,total_pass_per,total_time,total_requirements,passed_requirements,failed_requirements,requirements_pass_percent,requirements_fail_percent]


                            }
                           
                    }
                       
            }
                emailext (
                     to:'anp1pg1@bosch.com ; kmi1pg1@bosch.com',
                     mimeType: 'text/html',
                     subject: "MaaS IDBuzz System Qualification Test Status (SYS.5)- ${params.AURIX_VERSION}",
                     body: """
                     <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "https://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
                     ${getStyle()}
                     ${get_sanity_report()}
                    
                     """,
		     attachmentsPattern: 'testcase_chart.png,requirements_chart.png'
                    )
                    println("Report Mail has been sent!")
        }
    }
       
}

def get_sanity_report()
{
    def htmlContent = """
    <html>
        <head>
            <style>
            
                td {
                        padding:10px;
                        vertical-align:center;
                        border: 1px solid black;
                    }

                .col2{
                    text-align:center;
                }
                 . tructable {
                    text-align: left;
                 }

                tr:nth-child(even){
                    background-color:#C3F8E2;
                }
                tr:nth-child(odd){
                    background-color:#D1E9DF;
                }
                th {
                        background-color: #4F81BD;
                        color: white;
                        text-align: center;
                        border: 1px solid black;
                    }
                .status-pass {
                    background-color: green;
                }

                .status-fail {
                    background-color: red;
                }

                .status-unknown {
                    background-color: blue;
                }

                .status-skip {
                    background-color: yellow;
                }

            </style>
        </head>
        <body>
                <p>Dear All,<br/><br/>
                    Please find the Automated <strong></strong> test results for - <strong>MaaS_Blade</strong></p>
                <p><u><strong>Test Details:</strong></u></p>
                <table>
                    <tr style="background-color:#8EB4E3;">
                        <td>Project</td>
                        <td class="col2">IDBUZZ</td>
                    </tr>
                    <tr style="background-color:#BDD7EE;">
                        <td>SOC Version</td>
                        <td class="col2">${params.SOC_VERSION}</td>
                    </tr>
                    <tr style="background-color:#8EB4E3;">
                        <td>Product_variant</td>
                        <td class="col2">MaaS Blade</td>
                    </tr>
                    <tr style="background-color:#BDD7EE;">
                        <td>Mode of Flash</td>
                        <td class="col2">PCAT(SOC) & FLASHGUI(AURIX)</td>
                    </tr>
                    <tr style="background-color:#8EB4E3;">
                        <td>HW Sample</td>
                        <td class="col2">B1</td>
                    </tr>
                    <tr style="background-color:#BDD7EE;">
                        <td>HW Part Number</td>
                        <td class="col2">NA</td>
                    </tr>
                    <tr style="background-color:#8EB4E3;">
                        <td>Aurix Version</td>
                        <td class="col2">${params.AURIX_VERSION}</td>
                    </tr>
                    <tr style="background-color:#BDD7EE;">
                        <td>Tower ID</td>
                        <td class="col2">PG1-UT-0784C</td>
                    </tr>
                </table>

				<p><u><strong>Requirement Summary:</strong></u></p>
				<table>
					<tr style="background-color:#8EB4E3;">
						<td>Total Requirements</td>
						<td class="col2">${parsed_list[23]}</td>
					</tr>
					<tr style="background-color:#BDD7EE;">
						<td>Passed Requirements</td>
						<td class="col2">${parsed_list[24]}</td>
					</tr>
					<tr style="background-color:#8EB4E3;">
						<td>Failed Requirements</td>
						<td class="col2">${parsed_list[25]}</td>
					</tr>
					<tr style="background-color:#BDD7EE;">
						<td>Requirements Pass %</td>
						<td class="col2">${parsed_list[26]}</td>
					</tr>
					<tr style="background-color:#8EB4E3;">
						<td>Requirements Fail %</td>
						<td class="col2">${parsed_list[27]}</td>
					</tr>
				</table>
                
                <p><u><strong>Test Summary:</strong></u></p>
                <table>
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Total Testcases</th>
                            <th>Pass</th>
                            <th>Fail</th>
                            <th>Pass %</th>
                            <th>Execution Time(mm:ss)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><a href="${ARTIFACTORY_REPORT_URL_autoflashing}">Auto Flashing</a></td>
                            <td>${parsed_list[3]}</td>
                            <td>${parsed_list[6]}</td>
                            <td>${parsed_list[9]}</td>
                            <td>${parsed_list[18]}</td>
                            <td>${parsed_list[15]}</td>
                        </tr>
                        <tr>
                            <td><a href="${ARTIFACTORY_REPORT_URL_entrytest}">Entry Test</a></td>
                            <td>${parsed_list[4]}</td>
                            <td>${parsed_list[7]}</td>
                            <td>${parsed_list[10]}</td>
                            <td>${parsed_list[19]}</td>
                            <td>${parsed_list[16]}</td>
                        </tr>
                        <tr>
                            <td><a href="${ARTIFACTORY_REPORT_URL_fulltest}">Full Test</a></td>
                            <td>${parsed_list[5]}</td>
                            <td>${parsed_list[8]}</td>
                            <td>${parsed_list[11]}</td>
                            <td>${parsed_list[20]}</td>
                            <td>${parsed_list[17]}</td>
                        </tr>
                        <tr>
                            <td>Total</td>
                            <td>${parsed_list[3]+parsed_list[4]+parsed_list[5]}</td>
                            <td>${parsed_list[6]+parsed_list[7]+parsed_list[8]}</td>
                            <td>${parsed_list[9]+parsed_list[10]+parsed_list[11]}</td>
                            <td>${parsed_list[21]}</td>
                            <td>${parsed_list[22]}</td>
                        </tr>
                    </tbody>
                </table>
                
                
                <p><u><strong>Component Details</strong></u></p>
                <table border='1' id="summaryTable">
                    <tr>
                        <th>Component Name</th>
                        <th>Total</th>
                        <th>Pass</th>
                        <th>Fail</th>
                        <th>Pass%</th>
                        <th>Execution Time(mm:ss)</th>
                    </tr>
        """
        parsed_list[0].each { entry ->
            def component_name = entry.component_name.replaceAll('"', '\\"')
            def total = entry.total_tests
            def pass = entry.pass_tests
            def fail = entry.fail_tests
            def passPercentage = entry.pass_percentage
            def executionTime = entry.execution_time

            htmlContent += """
            <tr>
                <td>${component_name}</td>
                <td>${total}</td>
                <td>${pass}</td>
                <td>${fail}</td>
                <td>${passPercentage}</td>
                <td>${executionTime}</td>
            </tr>
            """
        }
        htmlContent += """
                </table>
                
                
            <p><u><strong>TestCase Info:</strong></u></p>
                <table border='1' id="testTable">
                    <tr>
					    <th>Testcase ID</th>
                        <th>Requirements</th>
                        <th>Testcase</th>
                        <th>Status</th>
                        <th>Reason</th>
                    </tr>
        """

        parsed_list[1].each { entry ->

            def tcid = entry.TESTCASE_ID ?: ""
            
            def reqString = ""
            def reqs = entry['REQUIREMENTS']

            if (reqs != null) {
                for (r in reqs) {
                    if (reqString != "") {
                        reqString += ", "
                    }
                    reqString += r.toString()
                }
            }

            def testcase = entry.TESTCASE.replaceAll('"', '\\"')
            def status = entry.STATUS.replaceAll('"', '\\"')
            def reason = entry.REASON.replaceAll('"', '\\"')
            def statusClass = getStatusClass(status)

            htmlContent += """
            <tr>
                <td>${tcid}</td>
                <td>${reqString}</td>
                <td>${testcase}</td>
                <td class="${statusClass}">${status}</td>
                <td>${reason}</td>
            </tr>
            """
        }

        htmlContent += """
                </table>
		<p><u><strong>Testcase Trend Chart:</strong></u></p>
                <img src='cid:testcase_chart.png'/>
                <br/><br/>
                <p><u><strong>Requirements Trend Chart:</strong></u></p>
                <img src='cid:requirements_chart.png'/>
                <p>*******************This is an auto generated email. Please do not reply to this mail*******************</p>
                <br/><br/>
                <p>Regards,<br/><strong> Automation System Test Team</strong></p>
            </body>
        </html>
        """

        return htmlContent
}

def getStatusClass(status) {
    switch (status) {
        case 'PASS':
            return 'status-pass'
        case 'FAIL':
            return 'status-fail'
        case 'UNKNOWN':
            return 'status-unknown'
        case 'SKIP':
            return 'status-skip'
        default:
            return ''
    }
}

def getStyle() {
    """
<style type="text/css">
    body {
        margin: 0px;
        padding: 15px
    }

    body, td, th {
        font-family: Helvetica, Arial, Tahoma, sans-serif;
        font-size: 12pt
    }

    th {
        text-align: left
    }

    h1{
        margin-top: 0px
    }

    .status{
        background-color: #d3d3d3;
        font-size: 28px;
        font-weight: bold;
        color: #ffffff;
        width: 100%;
        height: 48px;
        margin-bottom: 18px;
        text-align: center;
        vertical-align: middle;
        border-collapse: collapse;
        background-repeat: no-repeat
    }

    .status .info {
        color: #ffffff!important;
        font-size: 32px;
        line-height: 26px;
        padding: 12px 0;
    }

    .console {
        background-color: #000000;
        width: 100%;
        height: 100%;
        color: #ffffff;
        font-size: 12px;
        font-family: monospace;
    }

</style>
"""
}
