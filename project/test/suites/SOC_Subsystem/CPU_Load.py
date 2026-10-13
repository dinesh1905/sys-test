import re
 
 
def get_average_cpu_user_percent(top_output):
    matches = re.findall(r"CPU states:\s+([\d.]+)%\s+user", top_output)
    if not matches:
        raise ValueError("No CPU states lines found in top output")
    values = [float(x) for x in matches]
    average = round(sum(values) / len(values), 2)
    print(f"*INFO* CPU user% samples: {values}")
    print(f"*INFO* Average CPU user%: {average}%")
    return average
 
 
def validate_cpu_load_difference(before, during, threshold=15.0):
    diff = round(abs(during - before), 2)
    if diff > threshold:
        raise AssertionError(
            f"CPU load difference {diff}% exceeds allowed threshold of {threshold}%. "
            f"Before: {before}%, During: {during}%"
        )
    print(f"*INFO* Before avg: {before}%, During avg: {during}%, diff: {diff}% — PASS")