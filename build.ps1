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

[string]$coverageHtmlTemplate = @"
<img style="width: 250px;" src="https://codemelted.dev/website-nav/logos/logo-593x100.png" />
"@

[string]$pwshHtmlTemplate = @"
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
    <style>
        .main-content {
            padding-top: 5px;
            padding-right: 5px;
            padding-left: 5px;
            background-color: #1C2834;
        }
    </style>
</head><body><div class="main-content">
    CONTENT
</div></body></html>
"@

[string]$devHtmlTemplate = @"
<!DOCTYPE html>
<html><head>
    <title>Melt the Code - DEV</title>
    <meta charset="UTF-8">
    <meta name="description" content="The cross platform code module project.">
    <meta name="keywords" content="melt_the_code, Melt the Code, Cross Platform Modules, xplat-modules">
    <meta name="author" content="Mark Shaffer">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="monetization" content="`$ilp.uphold.com/q94gJPq8PFF4">
    <link rel="stylesheet" href="website-nav/css/hacker-theme.css">
    <script src="website-nav/index.js" defer></script>
</head><body><div class="content-main">
    CONTENT
</div></body></html>
"@

[string]$ucFeaturesHtmlTemplate = @"
<!DOCTYPE html>
<html><head>
    <title>Melt the Code - DEV</title>
    <meta charset="UTF-8">
    <meta name="description" content="The cross platform code module project.">
    <meta name="keywords" content="melt_the_code, Melt the Code, Cross Platform Modules, xplat-modules">
    <meta name="author" content="Mark Shaffer">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="monetization" content="`$ilp.uphold.com/q94gJPq8PFF4">
    <link rel="stylesheet" href="../website-nav/css/hacker-theme.css">
    <script src="../website-nav/index.js" defer></script>
</head><body><div class="content-main">
    CONTENT
</div></body></html>
"@

function build([string[]]$params) {
    # -------------------------------------------------------------------------
    # Constants
    # -------------------------------------------------------------------------
    [string]$PROJ_NAME = "Melt the Code - DEV Build Script"
    [string]$SCRIPT_PATH = $PSScriptRoot

    # -------------------------------------------------------------------------
    # Support Functions
    # -------------------------------------------------------------------------
    function message([string]$msg) {
        Write-Host
        Write-Host "MESSAGE: $msg"
        Write-Host
    }

    function coverageFormatHtml([string]$path) {
        Write-Host $path
        $htmlFiles = Get-ChildItem -Path $path -Filter *.html
        foreach ($file in $htmlFiles) {
            [string]$newFile = $file.Directory.FullName + [IO.Path]::DirectorySeparatorChar +
                "new" + $file.Name
            foreach ($line in Get-Content $file) {
                if ($line.Contains("<body>")) {
                    "<body> $coverageHtmlTemplate" | Out-File -FilePath $newFile -Append
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
    # Build Scripts
    # -------------------------------------------------------------------------
    function buildCpp() {
        message "Now building melt_the_code_cpp module"

        message "Setting up the dist directory"
        Set-Location "$SCRIPT_PATH/melt_the_code_cpp"
        Remove-Item -Path "dist" -Force -Recurse -ErrorAction Ignore
        New-Item -path "dist/melt_the_code_cpp" -ItemType Directory

        message "Generating doxygen"
        doxygen doxygen.cfg
        Move-Item -Path docs "dist/melt_the_code_cpp" -Force

        message "Running google test framework"
        g++ -std=c++17 -fprofile-arcs -ftest-coverage melt_the_code.cpp `
        melt_the_code_test.cpp -lgtest `
        -lgtest_main -pthread -o test.exe
        ./test.exe
        gcov -r . melt_the_code.cpp
        lcov -d . -c -o melt_the_code_coverage.info
        lcov --remove melt_the_code_coverage.info -o melt_the_code_coverage_filtered.info `
            '/usr/local/include/*' '*v1*'

        if ($IsLinux -or $IsMacOS) {
            genhtml -o "dist/melt_the_code_cpp/coverage" --dark-mode melt_the_code_coverage_filtered.info
        }
        Remove-Item -Path test.exe -Force
        Remove-Item -Path melt_the_code_coverage.info -Force
        Remove-Item -Path melt_the_code_coverage_filtered.info -Force
        Remove-Item -Path melt_the_code_test.gcda -Force
        Remove-Item -Path melt_the_code_test.gcno -Force
        Remove-Item -Path melt_the_code.cpp.gcov -Force
        Remove-Item -Path melt_the_code.gcda -Force
        Remove-Item -Path melt_the_code.gcno -Force
        coverageFormatHtml("dist/melt_the_code_cpp/coverage")
        coverageFormatHtml("dist/melt_the_code_cpp/coverage/melt_the_code_cpp")

        Copy-Item -Path "index.html" "dist/melt_the_code_cpp" -Force
        message "melt_the_code_cpp module built"
        Set-Location $SCRIPT_PATH
    }

    function buildDart() {
        message "Now building melt_the_code_dart module"

        message "Setting up the dist directory"
        Set-Location "$SCRIPT_PATH/melt_the_code_dart"
        Remove-Item -Path "dist" -Force -Recurse -ErrorAction Ignore
        New-Item -path "dist/melt_the_code_dart" -ItemType Directory

        message "Now generating dart doc"
        Set-Location "$SCRIPT_PATH/melt_the_code_dart"
        dart doc --output "dist/melt_the_code_dart/docs"

        message "Running dart test framework"
        flutter test --coverage
        if ($IsLinux -or $IsMacOS) {
            genhtml -o "dist/melt_the_code_dart/coverage" --dark-mode coverage/lcov.info
        }
        Remove-Item -Path coverage -Force -Recurse
        coverageFormatHtml("dist/melt_the_code_dart/coverage")
        # coverageFormatHtml("dist/melt_the_code_dart/coverage/lib")
        # coverageFormatHtml("dist/melt_the_code_dart/coverage/lib/src")

        Copy-Item -Path "index.html" "dist/melt_the_code_dart" -Force
        message "melt_the_code_dart module built"
        Set-Location $SCRIPT_PATH
    }

    function buildFlutter() {
        message "Now building melt_the_code_flutter module"

        message "Setting up the dist directory"
        Set-Location "$SCRIPT_PATH/melt_the_code_flutter"
        Remove-Item -Path "dist" -Force -Recurse -ErrorAction Ignore
        New-Item -path "dist/melt_the_code_flutter" -ItemType Directory

        message "Now generating dart doc"
        Set-Location "$SCRIPT_PATH/melt_the_code_flutter"
        dart doc --output "dist/melt_the_code_flutter/docs"

        message "Running flutter test framework"
        flutter test --coverage
        if ($IsLinux -or $IsMacOS) {
            genhtml -o "dist/melt_the_code_flutter/coverage" --dark-mode coverage/lcov.info
        }
        Remove-Item -Path coverage -Force -Recurse
        coverageFormatHtml("dist/melt_the_code_flutter/coverage")
        # coverageFormatHtml("dist/melt_the_code_dart/coverage/lib")
        # coverageFormatHtml("dist/melt_the_code_dart/coverage/lib/src")

        Copy-Item -Path "index.html" "dist/melt_the_code_flutter" -Force
        message "melt_the_code_flutter module built"
        Set-Location $SCRIPT_PATH
    }

    function buildPwsh() {
        message "Now building melt_the_code_pwsh module"

        message "Setting up the dist directory"
        Set-Location "$SCRIPT_PATH/melt_the_code_pwsh"
        Remove-Item -Path "dist" -Force -Recurse -ErrorAction Ignore
        New-Item -Path "dist" -ItemType Directory
        New-Item -Path "dist/melt_the_code_pwsh/docs" -ItemType Directory
        New-Item -Path "dist/melt_the_code_pwsh/coverage" -ItemType Directory

        message "Now generating the documentation"
        $readmeData = ConvertFrom-Markdown -Path docs.md
        $htmlData = $pwshHtmlTemplate.Replace("CONTENT", $readmeData.Html)
        $htmlData | Out-File -FilePath "dist/melt_the_code_pwsh/docs/index.html" -Force

        $readmeData = ConvertFrom-Markdown -Path coverage.md
        $htmlData = $pwshHtmlTemplate.Replace("CONTENT", $readmeData.Html)
        $htmlData | Out-File -FilePath "dist/melt_the_code_pwsh/coverage/index.html" -Force

        message "Now executing the pster tests"
        Invoke-Pester -CodeCoverage "melt_the_code.psm1"
        Remove-Item -Path "coverage.xml" -Force

        Copy-Item -Path "index.html" "dist/melt_the_code_pwsh" -Force
        message "melt_the_code_cpp module built"
        Set-Location $SCRIPT_PATH
    }

    function buildWeb() {
        message "Now building melt_the_code_web module"

        message "Setting up the dist directory"
        Set-Location "$SCRIPT_PATH/melt_the_code_web"
        Remove-Item -Path "dist" -Force -Recurse -ErrorAction Ignore
        New-Item -Path "dist" -ItemType Directory

        message "Now generating the typedoc"
        typedoc -out dist/melt_the_code_web/docs --name melt_the_code `
            --readme ./README.md ./melt_the_code.ts

        message "Now moving the converage demo program"
        Copy-Item -Path "coverage" -Destination "dist/melt_the_code_web" -Force -Recurse

        message "Now compiling the javascript module"
        tsc melt_the_code.ts --target es6 --outDir dist/melt_the_code_web

        Copy-Item -Path "index.html" "dist/melt_the_code_web" -Force
        message "melt_the_code_web module built"
        Set-Location $SCRIPT_PATH
    }

    function buildDevSite() {
        message "Now building the melt-the-code web site"

        message "Clear the dist directory"
        Remove-Item -Path "dist" -Force -Recurse -ErrorAction Ignore
        New-Item -Path "dist" -ItemType Directory

        message "Now building each of our module projects"
        buildCpp
        Copy-Item -Path "melt_the_code_cpp/dist/*" "dist" -Recurse -Force

        buildDart
        Copy-Item -Path "melt_the_code_dart/dist/*" "dist" -Recurse -Force

        buildFlutter
        Copy-Item -Path "melt_the_code_flutter/dist/*" "dist" -Recurse -Force

        buildPwsh
        Copy-Item -Path "melt_the_code_pwsh/dist/*" "dist" -Recurse -Force

        buildWeb
        Copy-Item -Path "melt_the_code_web/dist/*" "dist" -Recurse -Force

        message "Now building the use_case_features"
        Copy-Item "$SCRIPT_PATH/use_case_features" "dist" -Recurse -Force
        $markdownFiles = Get-ChildItem -Path "dist/use_case_features" -Filter *.md
        foreach ($file in $markdownFiles) {
            $readmeData = ConvertFrom-Markdown -Path $file
            $htmlData = $ucFeaturesHtmlTemplate.Replace("CONTENT", $readmeData.Html)
            $htmlData | Out-File -FilePath $file.FullName.Replace(".md", ".html")
        }

        message "Now building the main dev site items"
        $readmeData = ConvertFrom-Markdown -Path $SCRIPT_PATH/README.md
        $htmlData = $devHtmlTemplate.Replace("CONTENT", $readmeData.Html)
        $htmlData = $htmlData.Replace(".md", ".html")
        $htmlData | Out-File -FilePath "dist/index.html" -Force
        Copy-Item -Path "$SCRIPT_PATH/website-nav" "dist" -Recurse -Force
        Copy-Item -Path "$SCRIPT_PATH/404.html" "dist" -Force
        Copy-Item -Path "$SCRIPT_PATH/favicon.ico" "dist" -Force

        message "main dev site built"
    }

    function deploy() {
        message "Now deploying the Melt the Code - DEV site to firebase"
        buildDevSite
        firebase deploy --only hosting:codemelted-dev
        message "Deployment completed"
    }

    function publish() {
        message "Now deploying modules to supporting publishing sites"

        buildPwsh
        # TODO: deploy pwsh

        buildDart
        # TODO: deploy dart

        buildFlutter
        # TODO: deploy flutter

        message "Publishing completed"
    }

    # -------------------------------------------------------------------------
    # Main Execution Point
    # -------------------------------------------------------------------------
    message $PROJ_NAME
    [string]$action = if ($params.Count -gt 0) {$params[0]} Else {""}
    if ($action -eq "--cpp") {
        buildCpp
    } elseif ($action -eq "--dart") {
        buildDart
    } elseif ($action -eq "--flutter") {
        buildFlutter
    } elseif ($action -eq "--pwsh") {
        buildPwsh
    } elseif ($action -eq "--web") {
        buildWeb
    } elseif ($action -eq "--dev-site") {
        buildDevSite
    } elseif ($action -eq "--deploy") {
        deploy
    } elseif ($action -eq "--publish") {
        publish
    } else {
        Write-Host "ERROR: [action] was not specified or not a valid parameter"
    }
}
build $args