#!/usr/bin/env python3
# -*- coding: ISO-8859-1 -*-
import os
import sys
import platform
from pathlib import Path

import click
import datetime
from jinja2 import Template

linux_arch = os.getenv('CIBW_ARCHS_LINUX')

if platform.system() == 'Linux':
    if linux_arch is None or linux_arch == 'native':
        linux_arch = platform.machine()

# When running on x86_64 cibuildwheel will put it in lib64 but aarch64 will still use the lib directory
if linux_arch == 'x86_64':
    openssl_lib_dir = "/usr/local/ssl/lib64/"
else:
    openssl_lib_dir = "/usr/local/ssl/lib/"


openssl = {
    "mac": {
        "lib": "./openssl/lib/",
        "include": "./openssl/include/",
    },
    "win": {
        "lib": ".\\openssl",
        "include": ".\\openssl\\include",
    },
    "linux": {
        "lib": openssl_lib_dir,
        "include": "/usr/local/ssl/include/",
    }
}


def default_version() -> str:
    strf = '%Y.%-m.1'
    if sys.platform == 'win32':
        strf = '%Y.%#m.1'

    today = datetime.date.today()
    return today.strftime(strf)


@click.command()
@click.option(
    '--platform',
    type=click.Choice(
        ['win', 'mac', 'linux'],
        case_sensitive=True,
    )
)
@click.option(
    '--version',
    envvar='LIB_VERSION',
    default=default_version()
)
def generate_patch(platform, version: str):
    diff = Path('pysqlcipher3.diff')

    if diff.exists():
        print(f'Removing old diff')
        diff.unlink()

    with open('pysqlcipher3.diff.j2', encoding="iso-8859-1") as f:
        template = Template(f.read(), keep_trailing_newline=True)
        openssl_paths = openssl.get(platform)
        lib = openssl_paths.get('lib')
        include = openssl_paths.get('include')

        with open('pysqlcipher3.diff', 'w', encoding="iso-8859-1") as output:
            output.write(
                template.render(
                    version=version,
                    openssl_lib_dir=lib,
                    openssl_include_dir=include,
                )
            )


if __name__ == '__main__':
    generate_patch()
