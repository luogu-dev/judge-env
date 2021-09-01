#!/usr/bin/env python3
import os
import sys
import subprocess

print("Testing", sys.argv[2])
for root, _, files in os.walk(sys.argv[2]):
    for f in files:
        if f[-3:] != "out": continue
        o_out = os.path.join(root, f)
        p_ans = os.path.join(root, f[:-3] + "ans")
        print("testing", f[:-4] + "... ", end="")
        process = subprocess.Popen([sys.argv[1], "", o_out, p_ans], stderr=subprocess.PIPE)
        (output, _) = process.communicate()
        try:
            output = output.decode()
        except:
            output = str(output)
        process.wait()
        if "accepted" in output: print('\x1b[6;30;42m', end="")
        if "read" in output: print('\x1b[1;91m', end="")
        if "long" in output: print('\x1b[1;33m', end="")
        if "short" in output: print('\x1b[1;36m', end="")
        if "many" in output: print('\x1b[1;35m', end="")

        print(output, end="")
        print('\x1b[0m')
