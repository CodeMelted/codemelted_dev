#!/usr/local/bin/pwsh
# =============================================================================
# MIT License
#
# © 2023 Mark Shaffer
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
[string]$HTML_TEMPLATE = @"
<!DOCTYPE html>
<html><head>
    <title>Melt the Code -- pwsh Module</title>
    <meta charset="UTF-8">
    <meta name="description" content="The cross platform code module project.">
    <meta name="keywords" content="melt_the_code, Melt the Code, Cross Platform Modules, xplat-modules">
    <meta name="author" content="Mark Shaffer">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="monetization" content="`$ilp.uphold.com/q94gJPq8PFF4">
    <link rel="stylesheet" href="https://codemelted.dev/website-nav/css/hacker-theme.css">
</head><body>
    CONTENT
</body></html>
"@

function build {
    # -------------------------------------------------------------------------
    # Constants:
    # -------------------------------------------------------------------------
    [string]$PROJ_NAME = "melt_the_code - pwsh Module Publisher"
    [string]$SCRIPT_PATH = $PSScriptRoot
    [string]$SRC_PATH = "$SCRIPT_PATH/melt_the_code"
    [string]$DIST_PATH = "$SRC_PATH/dist/pwsh/melt_the_code"

    # -------------------------------------------------------------------------
    # Write out our header
    # -------------------------------------------------------------------------
    Write-Host $PROJ_NAME
    Write-Host

    # -------------------------------------------------------------------------
    # Clean and Make our distribution directory
    # -------------------------------------------------------------------------
    Remove-Item -Path $DIST_PATH -Force -Recurse -ErrorAction Ignore
    New-Item -Path $DIST_PATH -ItemType Directory
    New-Item -Path $DIST_PATH/docs -ItemType Directory
    New-Item -Path $DIST_PATH/coverage -ItemType Directory

    # -------------------------------------------------------------------------
    # Generate our main site items
    # -------------------------------------------------------------------------
    $readmeData = ConvertFrom-Markdown -Path $SRC_PATH/docs/README.md
    $htmlData = $HTML_TEMPLATE.Replace("CONTENT", $readmeData.Html)
    $htmlData | Out-File -FilePath "$DIST_PATH/docs/index.html" -Force

    $readmeData = ConvertFrom-Markdown -Path $SRC_PATH/coverage/README.md
    $htmlData = $HTML_TEMPLATE.Replace("CONTENT", $readmeData.Html)
    $htmlData | Out-File -FilePath "$DIST_PATH/coverage/index.html" -Force

    # -------------------------------------------------------------------------
    # Go Execute our pwsh Tests
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now executing pester tests"
    Get-Date
    Write-Host
    [string]$currentLocation = (Get-Location).ToString()
    Set-Location -Path $SRC_PATH
    Invoke-Pester -CodeCoverage "$SRC_PATH/melt_the_code.psm1"
    if ($result.FailedCount -gt 0) {
        Set-Location -Path $currentLocation
        throw "Testing failed, failed tests occurred with pwsh module"
    }
    Remove-Item -Path $SRC_PATH/coverage.xml -Force
    Invoke-ScriptAnalyzer . -Recurse
    Set-Location -Path $currentLocation
    Write-Host
    Write-Host "MESSAGE: Pester tests completed"

    # -------------------------------------------------------------------------
    # Copy our index.html
    # -------------------------------------------------------------------------
    Copy-Item -Path $SCRIPT_PATH/index.html $DIST_PATH -Force

    # -------------------------------------------------------------------------
    # Now go see if we are publishing or not
    # -------------------------------------------------------------------------
    # TBD
}
build $args[0]