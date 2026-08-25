import os
import subprocess
import sys
import sysconfig
import unittest


PROJECT_ROOT = os.path.dirname(os.path.dirname(__file__))
FREE_THREADED = bool(sysconfig.get_config_var("Py_GIL_DISABLED"))
IMPORT_WITHOUT_GIL = """
import sys
import sysconfig

assert sysconfig.get_config_var("Py_GIL_DISABLED") == 1
assert not sys._is_gil_enabled()
import sqlcipher3._sqlite3
assert not sys._is_gil_enabled()
"""


@unittest.skipUnless(FREE_THREADED, "requires a free-threaded Python build")
class FreeThreadingTests(unittest.TestCase):
    def test_ImportDoesNotEnableGil(self):
        env = os.environ.copy()
        env["PYTHON_GIL"] = "0"
        env["PYTHONWARNINGS"] = "error::RuntimeWarning"
        result = subprocess.run(
            [sys.executable, "-c", IMPORT_WITHOUT_GIL],
            cwd=PROJECT_ROOT,
            env=env,
            capture_output=True,
            check=False,
            text=True,
        )
        self.assertEqual(
            result.returncode,
            0,
            f"stdout:\n{result.stdout}\nstderr:\n{result.stderr}",
        )


def suite():
    return unittest.defaultTestLoader.loadTestsFromTestCase(FreeThreadingTests)

