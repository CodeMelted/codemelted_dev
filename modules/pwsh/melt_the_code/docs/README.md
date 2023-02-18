<h1><img style="height: 30px;" src="https://codemelted.dev/website-nav/icons/ps_black_64.png" /> melt_the_code pwsh Module</h1>

**Table of Contents**

- [Getting Started](#getting-started)
- [SDK Help](#sdk-help)
  - [Main API](#main-api)


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