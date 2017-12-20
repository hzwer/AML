import os

tests = ["arith", "if", "loop", "variable", "comment", "function", "block", "vector", "io", "global_variable", "array", "ternary"]
tests_agent = ["demo1", "demo2"]

l = len(tests)
for i, test in zip(range(l), tests):
    os.system("./main.native tests/aml/{0}.aml > tests/cpp/{0}.cpp".format(test))
    if (os.system("diff tests/cpp/{0}.cpp tests/std/{0}.cpp".format(test)) == 0):
        print("Pass the test {0} ({0} / {1}) ({2})".format(i + 1, l, test))
    else :
        print("Fail the test {0} ({0} / {1}) ({2})".format(i + 1, l, test))

l = len(tests_agent)    
for i, test in zip(range(len(tests_agent)), tests_agent):
    os.system("./main.native tests/aml/{0}.aml --agent > tests/cpp/{0}.cpp".format(test))
    if (os.system("diff tests/cpp/{0}.cpp tests/std/{0}.cpp".format(test)) == 0):
        print("Pass the demo {0} ({0} / {1}) ({2})".format(i + 1, l, test))
    else :
        print("Fail the demo {0} ({0} / {1}) ({2})".format(i + 1, l, test))    
