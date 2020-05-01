import subprocess
import sys

subprocess.call(['$SMA_PATH/venv/bin/python3', '$SMA_PATH/postSickbeard.py'] + sys.argv[1:])
# If you need to run more scripts (optional)
# subprocess.call(['my_cmd2', 'my_script2'] + sys.argv[1:])
