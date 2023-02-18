#!/usr/local/bin/pwsh
# =============================================================================
# MIT License
#
# © 2022 Mark Shaffer. All Rights Reserved.
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
<img style="width: 250px;" src="https://codemelted.dev/website-nav/logos/logo-593x100.png" />
"@

function build {
    # -------------------------------------------------------------------------
    # Constants
    # -------------------------------------------------------------------------
    [string]$PROJ_NAME = "melt_the_code Flutter Module"
    [string]$SCRIPT_PATH = $PSScriptRoot
    [string]$SRC_PATH = $SCRIPT_PATH + "/melt_the_code"
    [string]$DIST_PATH = "$SRC_PATH/dist/flutter/melt_the_code"
    [string]$COVERAGE_PATH = "$DIST_PATH/coverage"

    # -------------------------------------------------------------------------
    # Helper Functions
    function _formatHtml([string] $path) {
        Write-Host $path
        $htmlFiles = Get-ChildItem -Path $path -Filter *.html
        foreach ($file in $htmlFiles) {
            [string]$newFile = $file.Directory.FullName + [IO.Path]::DirectorySeparatorChar +
                "new" + $file.Name
            foreach ($line in Get-Content $file) {
                if ($line.Contains("<body>")) {
                    "<body> $HTML_TEMPLATE" | Out-File -FilePath $newFile -Append
                    $line.Replace("</head>", $CSS_STYLE) | Out-File -FilePath $newFile -Append
                } else {
                    $line | Out-File -FilePath $newFile -Append
                }
            }
            Remove-Item -Path $file -Force
            Rename-Item -Path $newFile -NewName $file -Force
            Write-Host $file created.
        }
    }

    # -------------------------------------------------------------------------
    # Write the main header
    # -------------------------------------------------------------------------
    Write-Host $PROJ_NAME
    Write-Host

    # -------------------------------------------------------------------------
    # Setup our dist directory
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now cleaning build outputs"
    Remove-Item -Path $DIST_PATH -Force -Recurse -ErrorAction Ignore
    New-Item -Path $DIST_PATH -ItemType Directory
    Write-Host "MESSAGE: build outputs cleaned"

    # -------------------------------------------------------------------------
    # Go build flutter
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now building with flutter"
    Write-Host
    Set-Location $SRC_PATH
    flutter clean
    flutter pub get
    Set-Location $SCRIPT_PATH
    Write-Host
    Write-Host "MESSAGE: flutter build completed."

    # -------------------------------------------------------------------------
    # Generate our documentation
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now generating dartdoc"
    Write-Host
    Set-Location $SRC_PATH
    dart doc --output "$DIST_PATH/docs"
    Set-Location $SCRIPT_PATH
    Write-Host
    Write-Host "MESSAGE: dartdoc generated"

    # -------------------------------------------------------------------------
    # Run our tests
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now executing flutter test"
    Write-Host
    Set-Location $SRC_PATH
    flutter test --coverage
    if ($IsLinux -or $IsMacOS) {
        genhtml -o $COVERAGE_PATH --dark-mode coverage/lcov.info
    }
    Remove-Item -Path coverage -Force -Recurse
    _formatHtml($COVERAGE_PATH)
    _formatHtml("$COVERAGE_PATH/lib")
    Set-Location $SCRIPT_PATH

    Write-Host
    Write-Host "MESSAGE: flutter test completed."

    # -------------------------------------------------------------------------
    # Copy our index.html
    # -------------------------------------------------------------------------
    Copy-Item -Path $SCRIPT_PATH/index.html $DIST_PATH -Force

    # -------------------------------------------------------------------------
    # Publish the flutter module
    # -------------------------------------------------------------------------
    # TBD
}
build $args[0]