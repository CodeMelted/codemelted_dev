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

# -----------------------------------------------------------------------------
# Definitions
# -----------------------------------------------------------------------------

[string]$_aboutModule = @"
TITLE:    melt_the_code_pwsh Module
VERSION:  v0.1.0 (Released on 18 Feb 2023)
WEBSITE:  https://codemelted.dev/melt_the_code_pwsh
LICENSE:  MIT / (c) 2023 Mark Shaffer. All Rights Reserved.
"@


# -----------------------------------------------------------------------------
# Public API
# -----------------------------------------------------------------------------

function Invoke-MeltTheCode {
    param(
        [parameter(mandatory=$true, position=0)][validateSet(
            "--about-module"
        )][string]$useCase,
        [parameter(mandatory=$false, position=2)][string[]]$args
    )

    # Determine which use case we are kicking off.
    if ($useCase.ToLower() -eq "--about-module") {
        Write-Host
        $_aboutModule
        Get-Help Invoke-MeltTheCode
    }

    <#
    .SYNOPSIS
        Provides a command line interface (CLI) for the Mac, Linux, Windows
        operating systems to facilitate dev ops automation or just simple
        programs that just need a CLI.

    .DESCRIPTION
        melt-the-code [useCase] [args[]]

        WHERE
            [useCase] A set of supported use cases one can choose from
            [args] The arguments array for the given use case

        USAGE:
            melt-the-code --about-module
                [string] - the module version and help info

    .LINK
        https://codemelted.dev/melt_the_code_pwsh
    #>
}
Set-Alias -Name melt-the-code -Value Invoke-MeltTheCode
Export-ModuleMember -Function Invoke-MeltTheCode -Alias melt-the-code

# Refactor the stuff
# # ----------------------------------------------------------------------------
# # useMath() - Use Case Implementation
# # ----------------------------------------------------------------------------
# function Use-Math {
#     param(
#         [parameter(mandatory=$true, position=0)][ValidateSet(
#             "help",
#             "celsiusToFahrenheit",
#             "celsiusToKelvin",
#             "fahrenheitToCelsius",
#             "fahrenheitToKelvin",
#             "kelvinToCelsius",
#             "kelvinToFahrenheit"
#         )][string]$action,
#         [parameter(mandatory=$false, position=1)][hashtable]$args
#     )

#     [double]$result = [double]::NaN
#     if ($action -eq "celsiusToFahrenheit") {
#         if ($args.ContainsKey("c")) {
#             $result = $args["c"] * (9/5) + 32
#         }
#     } elseif ($action -eq "celsiusToKelvin") {
#         if ($args.ContainsKey("c")) {
#             $result = $args["c"] + 273.15
#         }
#     } elseif ($action -eq "fahrenheitToCelsius") {
#         if ($args.ContainsKey("f")) {
#             $result = ($args["f"] - 32.0) * (5/9)
#         }
#     } elseif ($action -eq "fahrenheitToKelvin") {
#         if ($args.ContainsKey("f")) {
#             $result = (($args["f"] - 32) * (5/9)) + 273.15
#         }
#     } elseif ($action -eq "kelvinToCelsius") {
#         if ($args.ContainsKey("k")) {
#             $result = $args["k"] - 273.15
#         }
#     } elseif ($action -eq "kelvinToFahrenheit") {
#         if ($args.ContainsKey("k")) {
#             $result = (($args["k"] - 273.15) * (9/5)) + 32
#         }
#     } else {
#         Get-Help Use-Math -Full
#         return
#     }

#     return $result
#     <#
#     .SYNOPSIS
#         A collection of mathematical formulas one may need in an application.

#     .DESCRIPTION
#         melt-the-code -use Math -action [action] @{ [variable] = [value] ... }

#         WHERE
#             [action] - Represents the supported formula collection
#             ${} - The hashtable of variables and values for the formula

#     .PARAMETER action
#         celsiusToFahrenheit,
#         celsiusToKelvin,
#         fahrenheitToCelsius,
#         fahrenheitToKelvin,
#         kelvinToCelsius,
#         kelvinToFahrenheit

#     .PARAMETER args
#         The hashtable of the variables and values for the formula

#     .OUTPUTS
#         - Calculated double from executing the formula
#         - NaN if the args did not contains the appropriate math variables for the formula.

#     .EXAMPLE
#         # Example of converting celsius to fahrenheit
#         $result = melt-the-code -use Math -action celsiusToFahrenheit ${ c = 0.0 }

#     .LINK
#         https://xplat-modules.codemeled.com/pwsh/melt_the_code/docs
#     #>
# }