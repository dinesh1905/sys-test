

# -*- coding: utf-8 -*-
"""
Created on Thu Mar 19 21:29:18 2026

@author: WUB1COB
"""

import pandas as pd
import re
import os
import sys

DEFAULT_SHEET = "MaaS_Blade"

DID_FORMAT_MAP = {
    "F192": {"prefix": "62 F1 92", "var": "SystemSupplierECUHardwareNumber_Resp", "mode": "ascii"},
    "F191": {"prefix": "62 F1 91", "var": "VWEcuHWPartNumber_Resp", "mode": "ascii"},
    "F193": {"prefix": "62 F1 93", "var": "SystemSupplierECUHardwareVersionNumber_Resp", "mode": "ascii"},
    "F1A3": {"prefix": "62 F1 A3", "var": "VWECUHWVersionNumber_Resp", "mode": "ascii"},
    "F1B8": {"prefix": "62 F1 B8", "var": "VWSystemFirmwareVersion_Resp", "mode": "ascii_with_01"},
    "F189": {"prefix": "62 F1 89", "var": "VWApplicationSoftwareVersionNumber_Resp", "mode": "ascii"},
    "F194": {"prefix": "62 F1 94", "var": "SystemSupplierECUSWNumber_Resp", "mode": "raw"},
    "F195": {"prefix": "62 F1 95", "var": "SystemSupplierECUSoftwareVersionNumber_Resp", "mode": "raw_group"},
    "FD07": {"prefix": "62 FD 07", "var": "ECUExtractAR_CVersionNumber_Resp", "mode": "raw"},
    "F19E": {"prefix": "62 F1 9E", "var": "ASAMODXFileIdentifier_Resp", "mode": "ascii_hex_brackets"},
    "F1A2": {"prefix": "62 F1 A2", "var": "ASAMODXFileVersion_Resp", "mode": "ascii"},
    "F1B4": {"prefix": "62 F1 B4", "var": "TechnicalSpecificationsVersion_Resp", "mode": "direct"},
    "F1AB": {"prefix": "62 F1 AB", "var": "VWLogicalSoftwareBlockVersion_Resp", "mode": "ascii_group"},
    "031F": {"prefix": "62 03 1F", "var": "SoC_SWVersion_Resp", "mode": "ascii_full"},
    "F1AF": {"prefix": "62 F1 AF", "var": "AUTOSARStandardApplicationSoftwareIdentification_Resp", "mode": "direct"},
    "F15A": {"prefix": "", "var": "Fingerprint_Resp", "mode": "direct_no_prefix"},
}


def ascii_hex(txt):
    return " ".join(f"{ord(c):02X}" for c in str(txt))


def ascii_hex_full(val):
    return " ".join(f"{ord(c):02X}" for c in str(val))


def raw_hex(val):
    return " ".join(str(val).split("."))


def ascii_hex_brackets(val):
    text = re.split(r"\[", str(val))[0]
    base = ascii_hex(text)

    extra = re.findall(r"\[0x([0-9A-Fa-f]{2})\]", str(val))

    return f"{base} {' '.join(e.upper() for e in extra)}".strip()



def f192_value(val):
    val = str(val).strip()

    match = re.search(
        r"([0-9A-Fa-f]+)\s*\(Development sample\)",
        val,
        re.IGNORECASE
    )

    if match:
        return match.group(1)

    return val


def extract_did(txt):

    if pd.isna(txt):
        return None

    matches = re.findall(r"[A-F0-9]{4}", str(txt).upper())

    for match in matches:
        if match in DID_FORMAT_MAP:
            return match

    return None


def extract_sw_from_aurix(version_string):

    match = re.search(r"PI.*?(?=\(|$)", version_string)

    if match:
        return match.group(0).strip()

    raise ValueError(f"SW version not found in: {version_string}")

def sw_header_match(sw, header):

    sw = str(sw).strip()
    header = str(header).strip()

    pattern = rf"{re.escape(sw)}(?!\s*\.\d)"

    return re.search(pattern, header, re.IGNORECASE) is not None


def update_jsonp_all(payload_map, jsonp_path):

    with open(jsonp_path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    new_lines = []

    for line in lines:

        replaced = False

        for var, payload in payload_map.items():

            if f"${{params.global.sut.diag.{var}}}" in line:

                new_lines.append(
                    f'${{params.global.sut.diag.{var}}}: "{payload}",\n'
                )

                replaced = True
                break

        if not replaced:
            new_lines.append(line)

    with open(jsonp_path, "w", encoding="utf-8") as file:
        file.writelines(new_lines)


def main():

    aurix_version = sys.argv[1]
    excel_path = sys.argv[2]
    jsonp_path = sys.argv[3]

    print("Received AURIX Version:", aurix_version)
    print("Received Excel Path:", excel_path)
    print("Received JSONP Path:", jsonp_path)

    sw = extract_sw_from_aurix(aurix_version)

    print("Extracted SW Version:", sw)

    df = pd.read_excel(
        excel_path,
        sheet_name=DEFAULT_SHEET,
        header=None
    )

    df = df.ffill(axis=1)

    headers = df.iloc[0, 26:].astype(str).tolist()

    col = None

    for i, header in enumerate(headers):

        if sw_header_match(sw, header):
            col = i + 26
            print(f"Matched SW column: {header}")
            break

    if col is None:
        raise ValueError("SW column not found")

    verify_txt = os.path.join(
        os.path.dirname(jsonp_path),
        "Diagnostics_Partnumber_Update_Reference.txt"
    )

    payload_map = {}

    f195_buf = []
    f1ab_buf = []

    with open(verify_txt, "w", encoding="utf-8") as out:

        for row in range(1, len(df)):

            name = df.iloc[row, 0]

            did = extract_did(name)

            if did not in DID_FORMAT_MAP:
                continue

            val = df.iloc[row, col]

            if pd.isna(val):
                continue

            val = str(val).strip()

            cfg = DID_FORMAT_MAP[did]

            if cfg["mode"] == "raw_group":
                f195_buf.append(raw_hex(val))
                continue

            if cfg["mode"] == "ascii_group":
                f1ab_buf.append(ascii_hex(val))
                continue

            if cfg["mode"] == "direct":
                payload = val

            elif cfg["mode"] == "direct_no_prefix":
                payload = val

            elif cfg["mode"] == "ascii":


                if did == "F192":
                    val = f192_value(val)

                payload = ascii_hex(val)

            elif cfg["mode"] == "ascii_with_01":
                payload = "01 " + ascii_hex(val)

            elif cfg["mode"] == "ascii_full":
                payload = ascii_hex_full(val)

            elif cfg["mode"] == "raw":
                payload = raw_hex(val)

            else:
                payload = ascii_hex_brackets(val)

            if cfg["mode"] == "direct_no_prefix":
                full_payload = payload
            else:
                full_payload = f'{cfg["prefix"]} {payload}'

            payload_map[cfg["var"]] = full_payload

            out.write(
                f'${{params.global.sut.diag.{cfg["var"]}}}: "{full_payload}"\n'
            )

            print("Updated", did)

        if f195_buf:

            cfg = DID_FORMAT_MAP["F195"]

            payload = " ".join(f195_buf)

            full_payload = f'{cfg["prefix"]} {payload}'

            payload_map[cfg["var"]] = full_payload

            out.write(
                f'${{params.global.sut.diag.{cfg["var"]}}}: "{full_payload}"\n'
            )

            print("Updated F195")

        if f1ab_buf:

            cfg = DID_FORMAT_MAP["F1AB"]

            payload = " ".join(f1ab_buf)

            full_payload = f'{cfg["prefix"]} {payload}'

            payload_map[cfg["var"]] = full_payload

            out.write(
                f'${{params.global.sut.diag.{cfg["var"]}}}: "{full_payload}"\n'
            )

            print("Updated F1AB")

    update_jsonp_all(payload_map, jsonp_path)

    print("JSONP updated successfully")
    print("Verification TXT created:", verify_txt)


if __name__ == "__main__":

    try:
        main()

    except Exception as error:
        print("ERROR:", error)
        sys.exit(1)