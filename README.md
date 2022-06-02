# rotki-pysqlcipher3

Configuration for providing pre-build [pysqlcipher3](https://github.com/rigglemania/pysqlcipher3) wheels for [rotki](https://github.com/rotki/rotki).

## Description

This is a collections of patches and scripts to build wheels for rotki and publish them on PyPI.

It builds wheels for CPython 3.9 for the following architectures:

- Linux x86_64
- Linux aarch64
- Windows amd64
- macOS x86_64
- macOS arm64
- macOS universal2

The package is intended to be a drop-in replacement for the [pysqlcipher3 package](https://pypi.org/project/pysqlcipher3/).
And it is statically linked with [SQLCipher](https://github.com/sqlcipher/sqlcipher) 4.x and [OpenSSL](https://github.com/openssl/openssl) 1.1.x.

## License
The following license applies to the scripts and patches of this repo. 
For the submodules their respective licenses apply.

```
MIT License

Copyright (c) 2022 Rotki Solutions GmbH

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```