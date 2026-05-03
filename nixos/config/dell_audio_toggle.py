import subprocess
import itertools
import glob
import time


# Configuration
DEVICE_NAME="Dell Inc AWPRO H Wireless Game"
OFF_SIG = b'\x08\xc0\x09\x03\x00\x01\xdd\x1e'
ON_SIG = b'\x08\xc0\x09\x03\x00\x01\xcc\x0f'
ANALOG_NAME = "Built-in Audio"
HEADSET_NAME = "AWPRO H Wireless Game"
HDMI_NAME = "HDMI"


def notify(title, message, icon="audio-headphones"):
    cmd = [
        "notify-send", "-a", "Audio Switcher",
        "-i", icon, title, message
    ]
    try:
        subprocess.run(cmd, check=False)
    except Exception:
        pass

def find_sink(names):
    sinks = parse_wpctl_status()
    for n in names:
        for s in sinks:
            if n in s["name"]:
                return s

def set_sink(names):
    sink = find_sink(names)

    print(f"SINKS {sink}")
    if sink:
        print(f"DEBUG: Attempting to switch to {sink["name"]} ({sink["id"]})")
        result = subprocess.run(
            ["wpctl", "set-default", sink["id"]],
            capture_output=True
        )
        if result.returncode == 0:
            notify("Audio Output Changed", f"Active: {sink["name"]}")
        else:
            print(f"ERROR: wpctl could not find {sink["name"]}")
    else:
        print(f"ERROR: Could not find any sinks for {names}")
        print(f"ERROR: Availabe {sinks}")

### Example snippet from wpctl status
# Audio
#  ├─ Devices:
#  │      60. Built-in Audio                      [alsa]
#  │      61. GB206 High Definition Audio Controller [alsa]
#  │      62. AWPRO H Wireless Game               [alsa]
#  │  
#  ├─ Sinks:
#  │      49. Built-in Audio Analog Stereo        [vol: 0.52]
#  │  *   59. AWPRO H Wireless Game Analog Stereo [vol: 0.54]
#  │  
#  ├─ Sources:
#  │  *   54. AWPRO H Wireless Game Mono          [vol: 1.00 MUTED]
#  │      71. Built-in Audio Analog Stereo        [vol: 1.00]
#  │  
def parse_wpctl_status():
    output = str(subprocess.check_output("wpctl status", shell=True, encoding='utf-8'))

    # Why tf can't wpctl have an machine readible option
    lines = output.replace("─", "") \
        .replace("├", "") \
        .replace("│", "") \
        .replace("└", "") \
        .splitlines()

    not_sinks = (lambda line: "Sinks:" not in line)
    stripped = (lambda line: line.strip())
    # after Sinks:
    after_lines = list(itertools.dropwhile(not_sinks, lines))[1:]
    # before next empty
    sinks = itertools.takewhile(stripped, after_lines)

    sinks_dict = [parse_sink(sink) for sink in sinks]

    return sinks_dict

def parse_sink(sink):
    split = sink \
        .split("[vol:")[0] \
        .strip() \
        .replace("*", "") \
        .strip() \
        .split(".")
    id, name, *tail = split
    return {"id": str(int(id)), "name": name.strip()}


def find_hid_node():
    # Look specifically for the node that supports Report ID 8
    # Based on your hid-recorder output, we know it's a Dell device
    paths = glob.glob("/sys/class/hidraw/hidraw*/device/uevent")

    # We check them in reverse because the 'special' nodes
    # like hidraw7 are often created last.
    for path in reversed(sorted(paths)):
        try:
            with open(path, 'r') as f:
                content = f.read()
                if DEVICE_NAME in content:
                    node = "/dev/" + path.split('/')[4]
                    return node
        except Exception:
            continue
    return None


def main():
    sink_dict = parse_wpctl_status()
    print(sink_dict)
    while True:
        node = find_hid_node()
        if node:
            # This print will show up in journalctl
            print(f"INFO: Monitoring {node} for Alienware Pro signals...")
            old = None
            try:
                with open(node, 'rb') as f:
                    while True:
                        # Read one byte at a time to find the start of a signal
                        # This handles alignment issues better than f.read(8)
                        chunk = f.read(8)
                        if not chunk:
                            break

                        if ON_SIG in chunk and old != "on":
                            old = "on"
                            set_sink([HEADSET_NAME])
                        elif OFF_SIG in chunk and old != "off":
                            old = "off"
                            set_sink([HDMI_NAME, ANALOG_NAME])
                        time.sleep(0.1)
            except (PermissionError, FileNotFoundError) as e:
                print(f"ERROR: {e}. Retrying in 5s...")
        else:
            print(node)
        time.sleep(5)


if __name__ == "__main__":
    main()


