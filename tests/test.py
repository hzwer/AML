import os

tests = ["arith", "loop", "agent", "variable"]

for test in tests:
    print(test + " test")
    os.system("./main.native tests/" + test + ".aml" + " > tests/cpp/" + test + ".cpp")
    os.system("diff tests/cpp/" + test + ".cpp " + "tests/std/" + test + ".cpp")
