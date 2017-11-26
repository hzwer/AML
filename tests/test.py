import os

tests = ["calc", "loop", "agent", "variable"]

for test in tests:
    os.system("./main.native tests/" + test + ".aml" + " > tests/output/" + test + ".cpp")
    os.system("diff tests/output/" + test + ".cpp " + "tests/std/" + test + ".cpp")
