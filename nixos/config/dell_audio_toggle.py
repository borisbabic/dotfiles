import glob
import itertools
import subprocess
import time

# Configuration
DEVICE_NAME = "Dell Inc AWPRO H Wireless Game"
OFF_SIG = b"\x08\xc0\x09\x03\x00\x01\xdd\x1e"
ON_SIG = b"\x08\xc0\x09\x03\x00\x01\xcc\x0f"
ANALOG_NAME = "Built-in Audio"
HEADSET_NAME = "AWPRO H Wireless Game"
WIRED_HEADSET_NAME = "AWPRO H Wired Game"
HDMI_NAME = "HDMI"


def notify(title, message, icon="audio-headphones"):
    cmd = ["notify-send", "-a", "Audio Switcher", "-i", icon, title, message]
    try:
        subprocess.run(cmd, check=False)
    except Exception:
        pass


def parse_sink(sink_line):
    try:
        clean = (
            sink_line.split("[vol:")[0]
            .strip()
            .replace("*", "")
            .strip()
        )
        parts = clean.split(".", 1)
        if len(parts) == 2:
            sink_id = str(int(parts[0].strip()))
            sink_name = parts[1].strip()
            return {"id": sink_id, "name": sink_name}
    except Exception:
        pass
    return None


def parse_wpctl_status():
    try:
        output = subprocess.check_output(
            ["wpctl", "status"], encoding="utf-8", stderr=subprocess.DEVNULL
        )
    except Exception as e:
        print(f"ERROR: Failed to run wpctl status: {e}")
        return []

    lines = (
        output.replace("─", "")
        .replace("├", "")
        .replace("│", "")
        .replace("└", "")
        .splitlines()
    )

    not_sinks = lambda line: "Sinks:" not in line
    stripped = lambda line: line.strip()

    after_lines = list(itertools.dropwhile(not_sinks, lines))[1:]
    sinks_raw = itertools.takewhile(stripped, after_lines)

    sinks_dict = [parse_sink(s) for s in sinks_raw]
    return [s for s in sinks_dict if s is not None]


def find_sink(names):
    sinks = parse_wpctl_status()
    for n in names:
        for s in sinks:
            if n in s["name"]:
                return s
    return None


def set_sink(sink, target_names=None):
    if sink:
        name = sink["name"]
        sink_id = sink["id"]
        print(f"DEBUG: Attempting to switch to {name} ({sink_id})")
        result = subprocess.run(
            ["wpctl", "set-default", sink_id],
            capture_output=True,
            text=True,
        )
        if result.returncode == 0:
            notify("Audio Output Changed", f"Active: {name}")
        else:
            print(f"ERROR: wpctl failed to set {name}: {result.stderr}")
    else:
        print(f"ERROR: Could not find any sink matching {target_names}")


def find_and_set_sink(names):
    sink = find_sink(names)
    set_sink(sink, target_names=names)


def find_hid_node():
    paths = glob.glob("/sys/class/hidraw/hidraw*/device/uevent")
    for path in reversed(sorted(paths)):
        try:
            with open(path, "r") as f:
                content = f.read()
                if DEVICE_NAME in content:
                    return "/dev/" + path.split("/")[4]
        except Exception:
            continue
    return None


def main():
    while True:
        node = find_hid_node()
        if node:
            print(f"INFO: Monitoring {node} for Alienware Pro signals...")
            old = None
            try:
                with open(node, "rb") as f:
                    while True:
                        chunk = f.read(8)
                        wired_sink = find_sink([WIRED_HEADSET_NAME])

                        wired_available = wired_sink is not None
                        wireless_available = bool(chunk and ON_SIG in chunk)
                        use_fallback = not wired_available and not wireless_available

                        if wired_available and old != "wired":
                            old = "wired"
                            set_sink(wired_sink, [WIRED_HEADSET_NAME])

                        elif wireless_available and old != "wireless":
                            old = "wireless"
                            find_and_set_sink([HEADSET_NAME])

                        elif use_fallback and old != "fallback":
                            old = "fallback"
                            find_and_set_sink([HDMI_NAME, ANALOG_NAME])

                        time.sleep(0.1)
            except (PermissionError, FileNotFoundError, OSError) as e:
                # Catching OSError prevents crashes on unplug (Errno 5 Input/output error)
                print(f"DISCONNECTED/ERROR on {node}: {e}. Retrying in 2s...")
        else:
            # Device not plugged in yet
            pass

        time.sleep(2)


if __name__ == "__main__":
    main()
