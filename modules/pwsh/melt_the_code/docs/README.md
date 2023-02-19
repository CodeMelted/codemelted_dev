<h1><img style="height: 30px;" src="https://codemelted.dev/website-nav/icons/ps_black_64.png" /> melt_the_code pwsh Module</h1>

**Table of Contents**

- [Getting Started](#getting-started)
- [SDK Help](#sdk-help)
  - [Main API](#main-api)
- [License](#license)

## Getting Started

TBD

## SDK Help

### Main API

```
NAME
    Invoke-MeltTheCode

SYNOPSIS
    Provides a command line interface (CLI) for the Mac, Linux, Windows
    operating systems to facilitate dev ops automation or just simple
    programs that just need a CLI.


SYNTAX
    Invoke-MeltTheCode [-use] <String> [-action] <String> [[-args] <Hashtable>] [<CommonParameters>]


DESCRIPTION
    melt-the-code -use [use_case] -action [action] ${}

    WHERE
        [use_case] A set of supported use cases one can choose from
        [action] The action associated with the selected use case
        [hashtable] A set of key / value pairs supporting the action


PARAMETERS
    -use <String>
        Help - Gets help about this cmdlet

    -action <String>
        The supporting action that can be carried out by the selected use case.
        Use the help system to get more details about the use case.

    -args <Hashtable>
        The supporting key / value pairs to carry out the use case action.
        Use the help system to get more details about the use case.

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).
```

## License

<img style="width: 250px;" src="https://codemelted.dev/website-nav/logos/logo-593x100.png" />

MIT License

© 2023 Mark Shaffer. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.