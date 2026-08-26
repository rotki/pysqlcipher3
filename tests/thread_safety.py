import threading
import unittest

from sqlcipher3 import dbapi2 as sqlite


def call_key_method(connection, method_name, errors):
    try:
        getattr(connection, method_name)("secret")
    except sqlite.ProgrammingError:
        return
    except Exception as exc:
        errors.append(f"raised {type(exc).__name__} instead of ProgrammingError")
    else:
        errors.append("did not raise ProgrammingError")


class KeyMethodThreadSafetyTests(unittest.TestCase):
    def setUp(self):
        self.connection = sqlite.connect(":memory:")

    def tearDown(self):
        self.connection.close()

    def test_KeyMethodsEnforceSameThread(self):
        for method_name in ("set_key", "reset_key"):
            with self.subTest(method=method_name):
                errors = []
                thread = threading.Thread(
                    target=call_key_method,
                    args=(self.connection, method_name, errors),
                )
                thread.start()
                thread.join()
                self.assertEqual(errors, [], "\n".join(errors))


def suite():
    return unittest.defaultTestLoader.loadTestsFromTestCase(
        KeyMethodThreadSafetyTests,
    )

