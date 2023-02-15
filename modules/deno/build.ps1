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
    <link rel="icon" type="image/x-icon" href="../../../../website-nav/favicon_io/favicon.ico">
    <script src="../../../../website-nav/index.js" defer></script>
    <style>
        body {
            background-color: #2F3033;
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

        .settings {
            display: none;
        }
    </style>
</head>
"@

function build {
    # -------------------------------------------------------------------------
    # Constants:
    [string]$PROJ_NAME = "melt_the_code JavaScript Module"
    [string]$SCRIPT_PATH = $PSScriptRoot
    [string]$SRC_PATH = "$SCRIPT_PATH/melt_the_code"
    [string]$DIST_PATH = "$SRC_PATH/dist/deno/melt_the_code"
    [string]$DOCS_PATH = "$DIST_PATH/docs"
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
                if ($line.Contains("<head>") -and $line.Contains("</head>")) {
                    $line.Replace("</head>", $CSS_STYLE) | Out-File -FilePath $newFile -Append
                } elseif ($line.Contains("<head>")) {
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
    # Bundle our TypeScript to JavaScript
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now generating js bundle"
    Write-Host
    [string]$currentLocation = (Get-Location).ToString()
    Set-Location $SRC_PATH
    deno bundle melt_the_code.ts $DIST_PATH/melt_the_code.bundle.js
    Set-Location $currentLocation
    Write-Host
    Write-Host "MESSAGE: js bundle generated"

    # -------------------------------------------------------------------------
    # Generate our documentation
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now generating tsdoc"
    Write-Host
    [string]$currentLocation = (Get-Location).ToString()
    Set-Location $SRC_PATH
    typedoc --name melt_the_code --readme none ./melt_the_code.ts
    Move-Item -Path docs $DIST_PATH -Force
    _formatHtml($DOCS_PATH)
    _formatHtml("$DOCS_PATH/assets")
    _formatHtml("$DOCS_PATH/classes")
    _formatHtml("$DOCS_PATH/enums")
    _formatHtml("$DOCS_PATH/functions")
    $mainJs = Get-Content -Path "$DOCS_PATH/assets/main.js" -Raw
    $mainJs.Replace('"os"', '"dark"') | Out-File -FilePath "$DOCS_PATH/assets/main.js" -Force
    Set-Location $currentLocation
    Write-Host
    Write-Host "MESSAGE: tsdoc generated"

    # -------------------------------------------------------------------------
    # Run our tests
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now executing deno tests"
    Write-Host
    New-Item -Path $COVERAGE_PATH -ItemType Directory -ErrorAction SilentlyContinue
    [string]$currentLocation = (Get-Location).ToString()
    Set-Location $SRC_PATH
    deno test --coverage=$COVERAGE_PATH/cov_profile
    deno coverage $COVERAGE_PATH/cov_profile --lcov > $COVERAGE_PATH/lcov.info
    if ($IsLinux -or $IsMacOS) {
        genhtml -o $COVERAGE_PATH $COVERAGE_PATH/lcov.info
    }
    _formatHtml($COVERAGE_PATH)
    _formatHtml("$COVERAGE_PATH/melt_the_code")
    Set-Location $currentLocation
    Write-Host
    Write-Host "MESSAGE: deno tests completed."

    # -------------------------------------------------------------------------
    # Publish the deno module
    # -------------------------------------------------------------------------
    # TBD
}
build $args[0]