*** Settings ***
Documentation    Checking on ssh
Library    QConnectBase.ConnectionManager


*** Variables ***
${host}        192.168.42.1
${username}    root
${password}    root


*** Test Cases ***
SSH Connection
    [Documentation]    Testing on ssh communication
    # Create config for connection.
    ${config_string}=    catenate
    ...   {
    ...   "address": "192.168.42.1",
    ...   "port": 22,
    ...   "username": "root",
    ...   "password": "root",
    ...   "authentication": "password",
    ...   "key_filename": null
    ...   }
    ${config}=             evaluate        json.loads('''${config_string}''')    json

    # Connect to the target with above configurations.
    connect             conn_name=test_ssh
    ...                 conn_type=SSHClient
    ...                 conn_conf=${config}

    # ${result}=    Verify    conn_name=test_ssh
    # ...                     search_pattern=.*
    # ...                     send_cmd=ls
    # Log To Console    ***${result}***

    # Send Command    conn_name=test_ssh
    # ...             command=cd 00_Helpers/
    ${res}=     verify      conn_name=test_ssh
    ...                     search_pattern=.*
    ...                     fetch_block=True
#   ...                    eob_pattern=^\~\~END(\\d*)\~\~
    ...                     send_cmd=ls -l /home/root/00_Helpers

    Log To Console    ***${res}***

    Disconnect  test_ssh
