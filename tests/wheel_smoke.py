from sqlcipher3 import dbapi2 as sqlite


connection = sqlite.connect(':memory:')
try:
    cipher_version = connection.execute('PRAGMA cipher_version').fetchone()
    if not cipher_version or not cipher_version[0]:
        raise RuntimeError('The wheel is not linked against SQLCipher')
finally:
    connection.close()
