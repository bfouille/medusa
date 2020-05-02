import subprocess
import sys
import os                                                                                                                                  
                                                                                                                                           
SMA_PATH= os.environ['SMA_PATH']                                                                                                                                                                                                                                                   
subprocess.call([SMA_PATH + '/venv/bin/python3', SMA_PATH + '/postSickbeardMod.py'] + sys.argv[1:]) 

#subprocess.call(['$SMA_PATH/venv/bin/python3', '$SMA_PATH/postSickbeard.py'] + sys.argv[1:])
# If you need to run more scripts (optional)
# subprocess.call(['my_cmd2', 'my_script2'] + sys.argv[1:])
