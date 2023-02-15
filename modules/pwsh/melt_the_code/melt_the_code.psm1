using namespace System.Runtime.InteropServices
# =============================================================================
# MIT License
#
# Copyright (c) 2022 Mark Shaffer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
# =============================================================================
[string]$_aboutModule = @'
TITLE:     melt_the_code pwsh Module
VERSION:   v0.0.0 (Released on 01 May 2022)
WEBSITE:   https://xplat-modules.codemeled.com/pwsh/melt_the_code/docs
LICENSE:   MIT / (c) 2022 Mark Shaffer. All Rights Reserved.
'@

# ----------------------------------------------------------------------------
# useMath() - Use Case Implementation
# ----------------------------------------------------------------------------
function Use-Math {
    param(
        [parameter(mandatory=$true, position=0)][ValidateSet(
            "help",
            "celsiusToFahrenheit",
            "celsiusToKelvin",
            "fahrenheitToCelsius",
            "fahrenheitToKelvin",
            "kelvinToCelsius",
            "kelvinToFahrenheit"
        )][string]$action,
        [parameter(mandatory=$false, position=1)][hashtable]$args
    )

    [double]$result = [double]::NaN
    if ($action -eq "celsiusToFahrenheit") {
        if ($args.ContainsKey("c")) {
            $result = $args["c"] * (9/5) + 32
        }
    } elseif ($action -eq "celsiusToKelvin") {
        if ($args.ContainsKey("c")) {
            $result = $args["c"] + 273.15
        }
    } elseif ($action -eq "fahrenheitToCelsius") {
        if ($args.ContainsKey("f")) {
            $result = ($args["f"] - 32.0) * (5/9)
        }
    } elseif ($action -eq "fahrenheitToKelvin") {
        if ($args.ContainsKey("f")) {
            $result = (($args["f"] - 32) * (5/9)) + 273.15
        }
    } elseif ($action -eq "kelvinToCelsius") {
        if ($args.ContainsKey("k")) {
            $result = $args["k"] - 273.15
        }
    } elseif ($action -eq "kelvinToFahrenheit") {
        if ($args.ContainsKey("k")) {
            $result = (($args["k"] - 273.15) * (9/5)) + 32
        }
    } else {
        Get-Help Use-Math -Full
        return
    }

    return $result
    <#
    .SYNOPSIS
        A collection of mathematical formulas one may need in an application.

    .DESCRIPTION
        melt-the-code -use Math -action [action] @{ [variable] = [value] ... }

        WHERE
            [action] - Represents the supported formula collection
            ${} - The hashtable of variables and values for the formula

    .PARAMETER action
        celsiusToFahrenheit,
        celsiusToKelvin,
        fahrenheitToCelsius,
        fahrenheitToKelvin,
        kelvinToCelsius,
        kelvinToFahrenheit

    .PARAMETER args
        The hashtable of the variables and values for the formula

    .OUTPUTS
        - Calculated double from executing the formula
        - NaN if the args did not contains the appropriate math variables for the formula.

    .EXAMPLE
        # Example of converting celsius to fahrenheit
        $result = melt-the-code -use Math -action celsiusToFahrenheit ${ c = 0.0 }

    .LINK
        https://xplat-modules.codemeled.com/pwsh/melt_the_code/docs
    #>
}

# -----------------------------------------------------------------------------
# Public API
# -----------------------------------------------------------------------------

function Invoke-MeltTheCode {
    param(
        [parameter(mandatory=$true, position=0)][validateSet(
            "Help",
            "Math"
        )][string]$use,
        [parameter(mandatory=$true, position=1)][AllowNull()][AllowEmptyString()]
            [string]$action,
        [parameter(mandatory=$false, position=2)][hashtable]$args
    )

    if ($use.ToLower() -eq "help" -and [string]::IsNullOrEmpty($action)) {
        $_aboutModule
        Get-Help Invoke-MeltTheCode -Full
    } elseif ($use.ToLower() -eq "math") {
        Use-Math $action $args
    }

    <#
    .SYNOPSIS
        Provides a command line interface (CLI) for the Mac, Linux, Windows
        operating systems to facilitate dev ops automation or just simple
        programs that just need a CLI.

    .DESCRIPTION
        melt-the-code -use [use_case] -action [action] ${}

        WHERE
            [use_case] A set of supported use cases one can choose from
            [action] The action associated with the selected use case
            [hashtable] A set of key / value pairs supporting the action

    .PARAMETER use
        Help - Gets help about this cmdlet
        Math - A collection of mathematical formulas one may need in an
               application.

    .PARAMETER action
        The supporting action that can be carried out by the selected use case.
        Use the help system to get more details about the use case.

    .PARAMETER args
        The supporting key / value pairs to carry out the use case action.
        Use the help system to get more details about the use case.

    .EXAMPLE
        # Get help about this cmdlet or use case cmdlet
        melt-the-code -use Help
        melt-the-code -use Math -action Help

    .LINK
        https://xplat-modules.codemeled.com/pwsh/melt_the_code/docs
    #>
}
Set-Alias -Name melt-the-code -Value Invoke-MeltTheCode
Export-ModuleMember -Function Invoke-MeltTheCode -Alias melt-the-code