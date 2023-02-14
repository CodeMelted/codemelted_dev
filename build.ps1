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
    <title>Melt the Code -- DEV</title>
    <meta charset="UTF-8">
    <meta name="description" content="The cross platform code module project.">
    <meta name="keywords" content="melt_the_code, Melt the Code, Cross Platform Modules, xplat-modules">
    <meta name="author" content="Mark Shaffer">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="monetization" content="`$ilp.uphold.com/q94gJPq8PFF4">
    <link rel="icon" type="image/x-icon" href="website-nav/favicon_io/favicon.ico">
    <link rel="stylesheet" href="website-nav/css/hacker-theme.css">
    <script src="website-nav/index.js" defer></script>
</head><body><div class="content-main">
    CONTENT
</div></body></html>
"@

function build {
    # -------------------------------------------------------------------------
    # Constants
    # -------------------------------------------------------------------------
    [string]$PROJ_NAME = "codemelted.dev - Site Builder"
    [string]$SCRIPT_PATH = $PSScriptRoot
    [string]$DIST_PATH = "$SCRIPT_PATH/_dist"

    # [string]$CPP_PATH = $SCRIPT_PATH + "/cpp"
    # [string]$FLUTTER_PATH = $SCRIPT_PATH + "/flutter"
    # [string]$JS_PATH = $SCRIPT_PATH + "/js"
    # [string]$PWSH_PATH = $SCRIPT_PATH + "/pwsh"
    # [string]$DIST_PATH = $SCRIPT_PATH + "/_dist/xplat-modules"
    # [string]$DIST_CPP_PATH = $DIST_PATH + "/cpp/melt_the_code"
    # [string]$DIST_FLUTTER_PATH = $DIST_PATH + "/flutter/melt_the_code"
    # [string]$DIST_JS_PATH = $DIST_PATH + "/js/melt_the_code"
    # [string]$DIST_PWSH_PATH = $DIST_PATH + "/pwsh/melt_the_code"

    # # Build the CPP stuff
    # Set-Location $CPP_PATH
    # ./build.ps1 --clean
    # ./build.ps1 --docs

    # # Build the Flutter stuff
    # Set-Location $FLUTTER_PATH
    # ./build.ps1 --clean
    # ./build.ps1 --docs
    # ./build.ps1 --test

    # # Build the js stuff
    # Set-Location $JS_PATH
    # ./build.ps1 --clean
    # ./build.ps1 --docs
    # ./build.ps1 --test

    # # Build the pwsh stuff
    # Set-Location $PWSH_PATH
    # ./build.ps1 --clean
    # ./build.ps1 --docs
    # ./build.ps1 --test

    # # Set our location back to where we need to be and generate the _dist
    # # path for codemelted.com publishing / ZIP file for GitHub release.
    # Set-Location $SCRIPT_PATH
    # Remove-Item -Path $DIST_PATH -Force -Recurse -ErrorAction SilentlyContinue
    # New-Item -Path $DIST_PATH -ItemType Directory

    # # Move the CPP Artifacts
    # New-Item -Path $DIST_CPP_PATH -ItemType Directory
    # Move-Item -Path "$CPP_PATH/melt_the_code/docs" -Destination $DIST_CPP_PATH

    # # Move the Flutter Artifacts
    # New-Item -Path $DIST_FLUTTER_PATH -ItemType Directory
    # Move-Item -Path "$FLUTTER_PATH/melt_the_code/docs" -Destination $DIST_FLUTTER_PATH
    # Move-Item -Path "$FLUTTER_PATH/melt_the_code/coverage" -Destination $DIST_FLUTTER_PATH

    # # Move the JavaScript Artifacts
    # New-Item -Path $DIST_JS_PATH -ItemType Directory
    # Copy-Item -Path "$JS_PATH/melt_the_code/melt_the_code.js" -Destination $DIST_JS_PATH
    # Move-Item -Path "$JS_PATH/melt_the_code/docs" -Destination $DIST_JS_PATH
    # Move-Item -Path "$JS_PATH/melt_the_code/coverage" -Destination $DIST_JS_PATH

    # # Move the pwsh Artifacts
    # New-Item -Path $DIST_PWSH_PATH -ItemType Directory
    # Move-Item -Path "$PWSH_PATH/melt_the_code/docs" -Destination $DIST_PWSH_PATH

    # function generateDesignHtml() {
    #     # If file does not exist then break
    #     [string]$readmeHtml = $SCRIPT_PATH + "/README.html"
    #     if (-not(Test-Path -Path $readmeHtml -PathType Leaf)) {
    #         throw $readmeHtml + " file does not exist"
    #     }

    #     # It does exist, go read the HTML content
    #     [string]$htmlContent = ""
    #     foreach ($line in Get-Content $readmeHtml) {
    #         if ($line.Contains("<title>")) {
    #             $htmlContent += $HTML_HEADER + "`n"
    #         } elseif ($line.Contains("<body")) {
    #             $htmlContent +=  + $line + "`n" + "<div class=`"content-main`">`n"
    #         } elseif ($line.Contains("</body>")) {
    #             $htmlContent += $line + "`n" + "</div>`n"
    #         } else {
    #             $htmlContent += $line + "`n"
    #         }
    #     }

    #     # Now go write out the content
    #     [string]$designFile = "$SCRIPT_PATH/index.html"
    #     $htmlContent | Out-File -FilePath $designFile
    # }

    # -------------------------------------------------------------------------
    # Print our header statement
    # -------------------------------------------------------------------------
    Write-Host $PROJ_NAME
    Write-Host

    # -------------------------------------------------------------------------
    # Clean and Make our distribution directory
    # -------------------------------------------------------------------------
    Remove-Item -Path $DIST_PATH -Force -Recurse -ErrorAction Ignore
    New-Item -Path $DIST_PATH -ItemType Directory

    # -------------------------------------------------------------------------
    # Copy our website-nav to the _dist directory
    # -------------------------------------------------------------------------
    Copy-Item -Path "$SCRIPT_PATH/website-nav" $DIST_PATH -Recurse -Force

    # -------------------------------------------------------------------------
    # Generate our main README.md file
    # -------------------------------------------------------------------------
    $readmeData = ConvertFrom-Markdown -Path $SCRIPT_PATH/README.md
    $htmlData = $HTML_TEMPLATE.Replace("CONTENT", $readmeData.Html)
    $htmlData | Out-File -FilePath "$DIST_PATH/index.html" -Force
}
build