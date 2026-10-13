#!/usr/bin/python
# Robotframework API
# -*- coding: utf-8 -*-

# **************************************************************************************************************
# Initial Library modified by Annette Arpana (XC-CP/ESS5-Pg)
# Initial library taken from project team Paccar
#
# **************************************************************************************************************

sThisModuleName    = "artifactory.py"
sThisModuleVersion = "0.1.0"
sThisModuleDate    = "19.03.2024"
sThisModule        = sThisModuleName + " v. " + sThisModuleVersion + " / " + sThisModuleDate



from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword, library # required when using @keyword, @library decorators
from robot.libraries.Remote import Remote
from robot.api import logger
import json
import socket
import getopt
import re,sys
import subprocess,time,os
import platform
from _socket import timeout
from datetime import datetime

import os
import requests
import hashlib
import logging
import time
from urllib.parse import urlparse
@library
class artifactory():
    """
    The library helps download file from Artifactory with given credentials.
    Checksum is performed by default for each download.
    Support multiple credentials for different hostname.
    """
    def __init__(self, credentials={}):
        """
        Constructor to initialize class and logger
        """
        self.logging = logging.getLogger(__name__)
        if "" in credentials:
            self.logging.error("Error: hostname cannot be empty")
        if all([
                True if (
                    "username" in credentials[k]
                    and
                    "password" in credentials[k]
                    and
                    "cacert" in credentials[k]
                ) else False for k in credentials.keys()
        ]):
            self.credentials = credentials
        else:
            self.logging.error("Error: each credential must have username, password and cacert")
    @keyword
    def set_credentials(self, hostname, username, password, cacert):
        """
        To set credentials for specific hostname.
        Can add multiple credentials by multiple line or comma separated line (must have equal pair of credentials).
        - ``hostname`` - hostname
        - ``username`` - username for specified hostname
        - ``password`` - password for specified hostname
        - ``cacert`` - cacert for specified hostname
        *Examples*
        | Set Credentials | host1.artifactory.bosch.com | username1 | password1 | cacert1 |
        | Set Credentials | host2.artifactory.bosch.com | username2 | password2 | cacert2 |
        | Set Credentials | host3.artifactory.bosch.com,host4.artifactory.bosch.com | username3,username4 | password3,password4 | cacert3,cacert4 |
        """
        # cacertdrive = BuiltIn().get_variable_value("${sut.auto_flash.artifactory.bosch_pem1}")
        # cacertpath = BuiltIn().get_variable_value("${sut.auto_flash.artifactory.bosch_pem3}")
        # cacert1 = cacertdrive + ":" + cacertpath
        # cacert2 = cacertdrive + ":" + cacertpath
        # cacert3 = cacertdrive + ":" + cacertpath
        # cacert = cacert1 + "," + cacert2 + "," + cacert3
        if hostname != "":
            if "," in hostname:
                if (
                    len(hostname.split(",")) == len(username.split(","))
                    and
                    len(hostname.split(",")) == len(password.split(","))
                    and
                    len(hostname.split(",")) == len(cacert.split(","))
                ):
                    for i in range(len(hostname.split(","))):
                        self.credentials[hostname.split(",")[i]] = {
                          "username": username.split(",")[i],
                          "password": password.split(",")[i],
                          "cacert": cacert.split(",")[i],
                        }
                else:
                    self.logging.error("Error: Not equal pair of username, password and cacert")
            else:
                self.credentials[hostname] = {
                  "username": username,
                  "password": password,
                  "cacert": cacert,
                }
        else:
            self.logging.error("Error: hostname cannot be empty")
    @keyword
    def download_file(self, url, save_as_filename=None, verify_checksum=True, disable_http_proxy=True, chunk_size=8192, force_download=False, http_debug=False):
        """
        Download file with the given parameter.
        Will skip download if ``save_as_filename`` already exists with same checksum. Unless ``force_download`` is set to ``True``.
        - ``url`` - full url to the file
        - ``save_as_filename`` - path of output filename
        - ``verify_checksum`` - verify checksum after download
        - ``disable_http_proxy`` - disable http proxy for the connection
        - ``chunk_size`` - chunk size of file download and checksum calculation
        - ``force_download`` - force download to start even if ``save_as_filename`` already exists with same checksum.
        - ``http_debug`` - enable http client debug logging
        *Examples*
        | Download File | https://artifactory.bosch.com/somefile.zip |
        | Download File | https://artifactory.bosch.com/somefile.zip | file.zip |
        | Download File | https://artifactory.bosch.com/somefile.zip | path/to/file.zip | verify_checksum=False | disable_http_proxy=False |
        | Download File | https://artifactory.bosch.com/somefile.zip | path/to/file.zip | chunk_size=4096 | http_debug=True |
        """
        # saveas1 = BuiltIn().get_variable_value("${sut.auto_flash.drive}")
        # saveas2 = BuiltIn().get_variable_value("${sut.auto_flash.artifactory.aurix_saveasfile2}")
        # save_as_filename = saveas1 + ":" + saveas2
        # url1 = BuiltIn().get_variable_value("${sut.auto_flash.artifactory.url1}")
        # url2 = BuiltIn().get_variable_value("${sut.auto_flash.artifactory.url2}")
        # url = url1 + ":" + url2

        if disable_http_proxy:
            proxies = {
                "http": "",
                "https": "",
            }
        else:
            proxies = None
        if save_as_filename:
            filename = save_as_filename
        else:
            filename = os.path.basename(url)
        if http_debug:
            import http.client
            http.client.HTTPConnection.debuglevel = 5
        self.logging.info("url: " + str(url))
        self.logging.info("save as: " + str(filename))
        try:
            url_result = urlparse(url)
            if url_result.hostname in self.credentials:
                self.logging.debug("detected url hostname: " + url_result.hostname)
                with requests.get(
                        url,
                        verify=self.credentials[url_result.hostname]["cacert"],
                        stream=True,
                        auth=(
                            self.credentials[url_result.hostname]["username"],
                            self.credentials[url_result.hostname]["password"]
                        ),
                        proxies=proxies,
                        timeout=60
                    ) as r:
                    r.raise_for_status()
                    if os.path.exists(filename) and not force_download:
                        file_hash = hashlib.md5()
                        with open(filename, "rb") as f:
                            for chunk in iter(lambda: f.read(chunk_size), b""):
                                file_hash.update(chunk)
                        self.logging.debug("local exist with md5: " + str(file_hash.hexdigest()))
                        if "X-Checksum-Md5" in r.headers:
                            self.logging.debug("md5 remote: " + str(r.headers["X-Checksum-Md5"]))
                            if r.headers["X-Checksum-Md5"] == file_hash.hexdigest():
                                self.logging.info("remote and existing local md5: matched and skip download")
                                return True
                            else:
                                self.logging.info("Remote and local md5 not matched, proceed to download")
                        else:
                            self.logging.error("Error: Unable to get remote md5")
                            return False
                    with open(filename, "wb") as f:
                        file_hash = hashlib.md5()
                        start = time.time()
                        last_update = 0
                        for chunk in r.iter_content(chunk_size=chunk_size):
                            file_hash.update(chunk)
                            f.write(chunk)
                            if time.time() - last_update > 1:
                                self.logging.debug("file size written: " + str(f.tell()) + " of " + str(r.headers["Content-Length"]) + " (" + str(int(int(f.tell()) / int(r.headers["Content-Length"]) * 100)) + "%)")
                                last_update = time.time()
                        self.logging.debug("time elapsed(seconds): " + str(time.time() - start))
                        if verify_checksum:
                            self.logging.debug("md5 local: " + str(file_hash.hexdigest()))
                            if "X-Checksum-Md5" in r.headers:
                                self.logging.debug("md5 remote: " + str(r.headers["X-Checksum-Md5"]))
                            else:
                                self.logging.error("Error: Unable to get remote md5")
                                return False
                            if r.headers["X-Checksum-Md5"] == file_hash.hexdigest():
                                self.logging.info("md5: matched")
                            else:
                                self.logging.error("Error: Remote and local md5 not matched")
                                return False
            else:
                self.logging.error("Error: No matching credential for hostname")
                return False
        except Exception as e:
            self.logging.error("Exception: " + str(e))
            return False
        self.logging.info("status code: " + str(r.status_code))
        return r.ok