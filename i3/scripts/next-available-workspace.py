#!/usr/bin/python3
import json
from subprocess import check_output

workspaces = json.loads(check_output(["i3-msg", "-t", "get_workspaces"]))
workspace_nums = [ws["num"] for ws in workspaces]

for next_num in range(1, 50):  # start counting from currently focused workspace.
    if next_num not in workspace_nums:
        print(next_num)
        break
