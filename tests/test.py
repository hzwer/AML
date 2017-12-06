import os

tests = ["arith", "if", "loop", "variable", "comment", "function", "block", "vector"]
tests_agent = ["agent"]

for test in tests:
    print(test + " test")
    os.system("./main.native tests/aml/" + test + ".aml" + " > tests/cpp/" + test + ".cpp")
    os.system("diff tests/cpp/" + test + ".cpp " + "tests/std/" + test + ".cpp")

for test in tests_agent:
    print(test + " test")
    os.system("./main.native tests/aml/" + test + ".aml --agent" + " > tests/cpp/" + test + ".cpp")
    os.system("diff tests/cpp/" + test + ".cpp " + "tests/std/" + test + ".cpp")
