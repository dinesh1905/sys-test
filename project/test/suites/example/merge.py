#!/usr/bin/env python
import sys
import os
from robot import rebot_cli



def collect_xmls(path, xmls):
    for filename in os.listdir(path):
        file_path = os.path.join(path,filename)
    
        if filename.endswith('.xml'):
            fullname = os.path.join(path, filename)
            xmls.append(file_path)
        
        if os.path.isdir(filename):
            collect_xmls(file_path, xmls)

root_folder = sys.argv[1]
rebot_args = []
collect_xmls(root_folder, rebot_args)
rebot_cli(rebot_args)