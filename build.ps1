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
    [string]$DIST_PATH = "$SCRIPT_PATH/dist"
    [string]$DISQUS_SRC_PATH = "$SCRIPT_PATH/disqus"
    [string]$DISQUS_DIST_PATH = "$DIST_PATH/disqus"
    [string]$JEEP_PI_SRC_PATH = "$SCRIPT_PATH/jeep-pi"
    [string]$JEEP_PI_DIST_PATH = "$JEEP_PI_SRC_PATH/dist"
    [string]$MODULES_SRC_PATH = "$SCRIPT_PATH/modules"
    [string]$MODULES_DIST_PATH = "$DIST_PATH/modules"
    [string]$MODULES_DESIGN_SRC_PATH = "$MODULES_SRC_PATH/design/images"
    [string]$MODULES_DESIGN_DIST_PATH = "$MODULES_DIST_PATH/design/images"
    [string]$MODULES_DENO_SRC_PATH = "$MODULES_SRC_PATH/deno"
    [string]$MODULES_DENO_DIST_PATH = "$MODULES_SRC_PATH/deno/melt_the_code/dist"
    [string]$MODULES_PWSH_SRC_PATH = "$MODULES_SRC_PATH/pwsh"
    [string]$MODULES_PWSH_DIST_PATH = "$MODULES_SRC_PATH/pwsh/melt_the_code/dist"

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
    # Copy our disqus widget
    # -------------------------------------------------------------------------
    Copy-Item -Path $DISQUS_SRC_PATH $DISQUS_DIST_PATH -Recurse -Force

    # -------------------------------------------------------------------------
    # Build our jeep-pi page
    # -------------------------------------------------------------------------
    Set-Location $JEEP_PI_SRC_PATH
    ./build.ps1
    Set-Location $SCRIPT_PATH
    Copy-Item -Path "$JEEP_PI_DIST_PATH/*" $DIST_PATH -Recurse -Force

    # -------------------------------------------------------------------------
    # Copy our module design artifacts
    # -------------------------------------------------------------------------
    Copy-Item -Path $MODULES_DESIGN_SRC_PATH $MODULES_DESIGN_DIST_PATH -Recurse -Force

    # -------------------------------------------------------------------------
    # Build our code modules
    # -------------------------------------------------------------------------
    Set-Location $MODULES_DENO_SRC_PATH
    ./build.ps1
    Set-Location $SCRIPT_PATH
    Copy-Item -Path "$MODULES_DENO_DIST_PATH/*" $MODULES_DIST_PATH -Recurse -Force

    Set-Location $MODULES_PWSH_SRC_PATH
    ./build.ps1
    Set-Location $SCRIPT_PATH
    Copy-Item -Path "$MODULES_PWSH_DIST_PATH/*" $MODULES_DIST_PATH -Recurse -Force

    # -------------------------------------------------------------------------
    # Generate our main site items
    # -------------------------------------------------------------------------
    $readmeData = ConvertFrom-Markdown -Path $SCRIPT_PATH/README.md
    $htmlData = $HTML_TEMPLATE.Replace("CONTENT", $readmeData.Html)
    $htmlData | Out-File -FilePath "$DIST_PATH/index.html" -Force
    Copy-Item -Path "$SCRIPT_PATH/website-nav" $DIST_PATH -Recurse -Force
    Copy-Item -Path "$SCRIPT_PATH/404.html" $DIST_PATH -Force

    # -------------------------------------------------------------------------
    # Deploy to firebase
    # -------------------------------------------------------------------------
    if ($args -ne $null) {
        if ($args[0].ToString().ToLower() -eq "--deploy") {
            firebase deploy --only hosting:codemelted-dev
        }
    }
}
build $args[0]