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
[string]$CSS_STYLE = @"
<meta name="monetization" content="`$ilp.uphold.com/q94gJPq8PFF4">
<link rel="icon" type="image/x-icon" href="https://codemelted.dev/favicon.ico">
<script src="https://codemelted.dev/website-nav/index.js" defer></script>
<style>
    body {
        background-color: #2B2E33;
        color: white;
    }

    h1, h2, h3, h4, h5, h6, dd {
        color: white;
    }

    span.linenum {
        background-color: #8B8000;
    }

    span.linecov {
        background-color: darkblue;
    }

    span.linenocov {
        background-color: darkred;
    }
</style>
</head>
"@

function build {
    # -------------------------------------------------------------------------
    # Constants
    # -------------------------------------------------------------------------
    [string]$PROJ_NAME = "melt_the_code Flutter Module"
    [string]$SCRIPT_PATH = $PSScriptRoot
    [string]$SRC_PATH = $SCRIPT_PATH + "/melt_the_code"
    [string]$DOCS_PATH = $SRC_PATH + "/docs"
    [string]$COVERAGE_PATH = $SRC_PATH + "/coverage"

    # -------------------------------------------------------------------------
    # Helper Functions
    # -------------------------------------------------------------------------
    function _formatHtml([string] $path) {
        $htmlFiles = Get-ChildItem -Path $path -Filter *.html
        foreach ($file in $htmlFiles) {
            [string]$newFile = $file.Directory.FullName + [IO.Path]::DirectorySeparatorChar +
                "new" + $file.Name
            foreach ($line in Get-Content $file) {
                if ($line.Contains("<head>")) {
                    $line | Out-File -FilePath $newFile -Append
                    "<meta name='viewport' content='width=device-width, initial-scale=1'>" | Out-File -FilePath $newFile -Append
                } elseif ($line.Contains("</head>")) {
                    $CSS_STYLE | Out-File -FilePath $newFile -Append
                } else {
                    $line | Out-File -FilePath $newFile -Append
                }
            }
            Remove-Item -Path $file -Force
            Rename-Item -Path $newFile -NewName $file -Force
            Write-Host $file created.
        }
    }

    function clean {
        Write-Host "MESSAGE: Now cleaning build outputs"
        Remove-Item -Path $DOCS_PATH -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path $COVERAGE_PATH -Force -Recurse -ErrorAction SilentlyContinue
        New-Item -Path $DOCS_PATH -ItemType Directory
        New-Item -Path $COVERAGE_PATH -ItemType Directory
        Write-Host "MESSAGE: build outputs cleaned"
    }

    function docs {
        Write-Host "MESSAGE: Now generating dartdoc"
        Write-Host

        [string]$currentLocation = (Get-Location).ToString()
        Set-Location $SRC_PATH
        dartdoc --output $DOCS_PATH
        $docDirs = Get-ChildItem -Path $DOCS_PATH -Recurse -Directory -Force `
            -ErrorAction SilentlyContinue | Select-Object FullName

        _formatHtml($DOCS_PATH)
        foreach ($element in $docDirs) {
            _formatHtml($element.FullName)
        }
        Set-Location $currentLocation

        Write-Host
        Write-Host "MESSAGE: dartdoc generated"
    }

    function test {
        Write-Host "MESSAGE: Now executing flutter test"
        Write-Host

        [string]$currentLocation = (Get-Location).ToString()
        Set-Location $SRC_PATH
        flutter test --coverage
        if ($IsLinux -or $IsMacOS) {
            genhtml -o $COVERAGE_PATH $COVERAGE_PATH/lcov.info
        }
        _formatHtml($COVERAGE_PATH)
        _formatHtml("$COVERAGE_PATH/lib")
        _formatHtml("$COVERAGE_PATH/lib/use_cases/asyncio")
        _formatHtml("$COVERAGE_PATH/lib/use_cases/math")
        Set-Location $currentLocation

        Write-Host
        Write-Host "MESSAGE: flutter test completed."
    }

    function publish() {
        Write-Host "MESSAGE: UNDER DEVELOPMENT"
    }

    # -------------------------------------------------------------------------
    # Main Entry of script
    # -------------------------------------------------------------------------
    Write-Host "----------------------------"
    Write-Host $PROJ_NAME
    Write-Host "----------------------------"
    Write-Host
    clean
    docs
    test
}
build $args[0]