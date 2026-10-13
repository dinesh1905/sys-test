from robot.api.deco import keyword
import re

@keyword("Convert Hex to ASCII")
def convert_hex_to_ascii(hex_string):
    """Converts a space-separated hexadecimal string to an ASCII string,
    removing trailing zeros and cleaning null bytes.

    Args:
        hex_string: The space-separated hexadecimal string to convert.

    Returns:
        The ASCII string, or None if the input is invalid.
    """
    try:
        print(f"Input hex_string: {hex_string}")  # Debugging Log

        # 1. Remove spaces from the input string
        hex_string = hex_string.replace(" ", "")
        print(f"Hex string after removing spaces: {hex_string}")

        # 2. Remove trailing "0" characters from the hex string
        while hex_string and hex_string.endswith("0"):
            hex_string = hex_string[:-1]
            print(f"After removing trailing 0: {hex_string}")  # Debugging Log

        # 3.Check if string has only hexadecimal after zero removal
        if not re.match(r'^[0-9a-fA-F]*$', hex_string):
                print("The string contains Non-hex characters. Returning None")
                return None

        # 4. If the resulting hex string has an odd length, it's invalid. Return None
        if len(hex_string) % 2 != 0:
            print("Odd length detected. Returning None.")  # Debugging Log
            return None

        # Convert the cleaned hex string to bytes
        bytes_object = bytes.fromhex(hex_string)
        print(f"bytes_object: {bytes_object}") #Debugging Log


        # Decode the bytes to ASCII, ignoring errors
        ascii_string = bytes_object.decode('ascii', errors='ignore')

        # Clean null bytes from result
        cleaned_ascii_string = ascii_string.replace('\x00', '')
        print(f"Cleaned ASCII string: {cleaned_ascii_string}") #Debugging Log
        return cleaned_ascii_string

    except ValueError as e:
        print(f"ValueError: {e}. Returning None.")  # Debugging Log
        return None
