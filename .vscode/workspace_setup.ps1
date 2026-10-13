# path of executed script
$SCRIPT_DIR = $PSScriptRoot

# path of the workspace
$TAF_PATH = Split-Path -Path $SCRIPT_DIR -Parent

# check if db_client is installed
$dbc_installed = [System.IO.File]::Exists("${env:DB_CLIENT_PATH}/interfaces/db_client_interface.py")

# check if bits_platform is installed
$bp_installed =  [System.IO.File]::Exists("${env:BITS_PLATFORM_INSTALL_PATH}/interfaces/robotframework/bits_platform.py")

# contents of settings.json
$contentToAdd = @"
{
    "editor.renderWhitespace": "all",
    "editor.rulers": [
        {"column": 125, "color": "#ff0000"}
    ],
    "workbench.colorTheme": "Default Light+",
    "workbench.colorCustomizations": {
        "tree.indentGuidesStroke": "#444444"
    },
    "workbench.tree.indent": 18,

    "terminal.integrated.defaultProfile.windows": "PowerShell",

    "python.defaultInterpreterPath": "`${env:RobotPythonPath}/python.exe",

    "python.envFile": "`${workspaceFolder}/.vscode/.env",
    "python.analysis.diagnosticMode": "workspace",

    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "python.linting.pylintArgs": [
        "--rcfile=`${workspaceFolder}/.pylintrc"
    ],

    "robot.variables": {
        "TESTBENCH_CONFIG_PATH" : "project/testbench/bench_local",
        //"TESTBENCH_CONFIG_PATH" : "project/testbench/bench_remote",
        "SUT_CONFIG_PATH" : "project/sut/all_sut",
        "SETUP_CONFIG_PATH" : "project/setup/default",
        "TEST_CONFIG_PATH" : "project/test/default",
        "FRAMEWORK_CONFIG_PATH" : "project/framework/default",
        "testbench_configuration" : "bench_local",
        "sut_configuration" : "all_sut",
        "setup_configuration" : "default",
        "test_configuration" : "default",
        "framework_configuration" : "default",
"@

if ($bp_installed) { $contentToAdd += @"
`n        "BP_PATH": "`${env:BITS_PLATFORM_INSTALL_PATH}",
"@
}

$contentToAdd += @"
`n        "TAF_PATH": "`${workspaceFolder}"
    },
    "robot.lint.enabled": true,
    "robot.lint.robocop.enabled": true,

    "robot.language-server.python": "`${env:RobotPythonPath}/python.exe",
    "robot.python.executable": "`${env:RobotPythonPath}/python.exe",
    "robot.pythonpath": [
"@

if ($bp_installed) { $contentToAdd += @"
`n        "`${env:BITS_PLATFORM_INSTALL_PATH}",
"@
}

if ($dbc_installed) { $contentToAdd += @"
`n        "`${env:DB_CLIENT_PATH}/interfaces",
"@
}

$contentToAdd += @"
`n        "`${workspaceFolder}"
    ],
"@

if ($dbc_installed) { $contentToAdd += @"
`n`n
    "robot.libraries.libdoc.needsArgs": [
        "db_client_interface"
    ],
"@
}

$contentToAdd += @"
`n`n    "launch": {
        "configurations": [
            {
                "type": "robotframework-lsp",
                "name": "Robot Framework: Launch Template",
                "request": "launch",
                "terminal": "integrated",
                "args": [
                    "--listener", "`${workspaceFolder}/generic/framework/report/csv/update.py",
"@

if ($dbc_installed) { $contentToAdd += @"
`n                    "--listener", "`${workspaceFolder}/generic/framework/report/mbits/update.py",
"@
}

$contentToAdd += @"
`n                    "-A", "`${workspaceFolder}/.vscode/arguments.tmp"
                ],
                "preLaunchTask": "generate_robot_argument_file_windows"
            }
        ]
    }
}
"@

Set-Content -Path "${TAF_PATH}\.vscode\settings.json" -Value $contentToAdd


# contents of .env
$contentToAdd = "PYTHONPATH=${env:RobotPythonPath}\lib\site-packages;${TAF_PATH}"

if ($bp_installed) { $contentToAdd += ";${env:BITS_PLATFORM_INSTALL_PATH}" }

Set-Content -Path "${TAF_PATH}\.vscode\.env" -Value $contentToAdd

# add db_client library import 
if ($dbc_installed) {
    $filepath = "${TAF_PATH}\generic\framework\report\import.resource"
    $filecontent = Get-Content $filepath
    # check if library import is already existing
    if ($filecontent -notcontains "Library    db_client_interface    sReportFolder=`${OUTPUT DIR}") {
        $num_lines = $filecontent.Length
        $filecontent[$num_lines-1] += "`nLibrary    db_client_interface    sReportFolder=`${OUTPUT DIR}"
        $filecontent | Set-Content $filepath
    }
}
