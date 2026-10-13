#!/usr/bin/env python3
"""UDS SecurityAccess (0x27) key calculator for SA2-based seed/key.

This CLI implements the same key logic used in this project:
- 5 rounds
- Rotate-left by 1 on 32-bit value
- If LSB is 1 after rotate, XOR with configured ECU constant

Default ECU constant is taken from project config:
SWUpdate/Config/Autosar/BL/Appl/GenData/SecM_cfg.h

Examples:
  python uds_sa2_key_cli.py --seed 58A8F1BD
  python uds_sa2_key_cli.py --seed "58 A8 F1 BD"
    python uds_sa2_key_cli.py --response 67 11 58 A8 F1 BD
  python uds_sa2_key_cli.py --seed 0x58A8F1BD --const 0x2594FCE3
  python uds_sa2_key_cli.py --seed 58A8F1BD --print-request

Expected for seed 58A8F1BD with default const 0x2594FCE3:
  key = 72902974
  bytes = 72 90 29 74
"""

from __future__ import annotations

import argparse
import re
import sys

DEFAULT_ECU_CONST = 0x2594FCE3


def parse_hex_bytes(value: str) -> list[int]:
    """Parse a byte stream from common hex formats."""
    raw = value.strip()
    cleaned = raw.replace("0x", "").replace("0X", "")
    cleaned = re.sub(r"[^0-9A-Fa-f]", "", cleaned)

    if len(cleaned) == 0:
        raise ValueError(f"No hex data found in '{value}'.")
    if (len(cleaned) % 2) != 0:
        raise ValueError(
            f"Hex stream must contain full bytes (even number of hex chars), got '{value}'."
        )

    return [int(cleaned[i : i + 2], 16) for i in range(0, len(cleaned), 2)]


def parse_u32_hex(value: str) -> int:
    """Parse a 32-bit hex value from common formats.

    Accepted input examples:
    - 58A8F1BD
    - 0x58A8F1BD
    - 58 A8 F1 BD
    - 58-A8-F1-BD
    - 58:A8:F1:BD
    """
    cleaned = "".join(f"{b:02X}" for b in parse_hex_bytes(value))

    if len(cleaned) != 8:
        raise ValueError(
            f"Expected exactly 4 bytes (8 hex chars), got '{value}'."
        )

    parsed = int(cleaned, 16)
    if parsed < 0 or parsed > 0xFFFFFFFF:
        raise ValueError(f"Value out of 32-bit range: '{value}'.")
    return parsed


def seed_from_positive_response(value: str) -> int:
    """Extract 4-byte seed from positive response payload '67 11 <seed4>'."""
    data = parse_hex_bytes(value)
    if len(data) < 6:
        raise ValueError(
            "Expected at least 6 bytes for response: '67 11 <seed4>'."
        )
    if data[0] != 0x67 or data[1] != 0x11:
        raise ValueError(
            "Expected positive seed response starting with '67 11'."
        )

    seed_bytes = data[2:6]
    return (
        (seed_bytes[0] << 24)
        | (seed_bytes[1] << 16)
        | (seed_bytes[2] << 8)
        | seed_bytes[3]
    )


def compute_sa2_key(seed: int, ecu_const: int) -> int:
    """Compute 32-bit key using project SA2 logic."""
    temp = seed & 0xFFFFFFFF
    for _ in range(5):
        temp = ((temp << 1) | (temp >> 31)) & 0xFFFFFFFF
        carry = temp & 0x01
        if carry != 0:
            temp ^= ecu_const
    return temp & 0xFFFFFFFF


def to_bytes_be_u32(value: int) -> tuple[int, int, int, int]:
    """Return big-endian 4-byte tuple from 32-bit value."""
    v = value & 0xFFFFFFFF
    return ((v >> 24) & 0xFF, (v >> 16) & 0xFF, (v >> 8) & 0xFF, v & 0xFF)


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Compute UDS 0x27 SecurityAccess key for SA2 algorithm used in this ECU."
        )
    )
    input_group = parser.add_mutually_exclusive_group(required=True)
    input_group.add_argument(
        "--seed",
        nargs="+",
        help="Seed from ECU (e.g. 58A8F1BD or '58 A8 F1 BD').",
    )
    input_group.add_argument(
        "--response",
        nargs="+",
        help="Positive response bytes (e.g. '67 11 58 A8 F1 BD').",
    )
    parser.add_argument(
        "--const",
        default=[f"0x{DEFAULT_ECU_CONST:08X}"],
        nargs="+",
        help=(
            "ECU constant in hex. Default: "
            f"0x{DEFAULT_ECU_CONST:08X}"
        ),
    )
    parser.add_argument(
        "--print-request",
        action="store_true",
        help="Also print ready-to-send UDS request bytes: '27 12 <key>'.",
    )
    args = parser.parse_args()

    try:
        if args.seed is not None:
            seed = parse_u32_hex(" ".join(args.seed))
        else:
            seed = seed_from_positive_response(" ".join(args.response))
        ecu_const = parse_u32_hex(" ".join(args.const))
    except ValueError as exc:
        print(f"Input error: {exc}", file=sys.stderr)
        return 2

    key = compute_sa2_key(seed, ecu_const)
    seed_b = to_bytes_be_u32(seed)
    key_b = to_bytes_be_u32(key)

    print(f"seed_u32: 0x{seed:08X}")
    print("seed_bytes: " + " ".join(f"{b:02X}" for b in seed_b))
    print(f"const_u32: 0x{ecu_const:08X}")
    print(f"key_u32: 0x{key:08X}")
    print("key_bytes: " + " ".join(f"{b:02X}" for b in key_b))

    if args.print_request:
        print("uds_27_12_request: 27 12 " + " ".join(f"{b:02X}" for b in key_b))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
