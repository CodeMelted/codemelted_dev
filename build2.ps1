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
            background-color: #1C2834;
        }
    </style>
</head><body><div class="main-content">
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

    # -------------------------------------------------------------------------
    # Main Execution Point
    # -------------------------------------------------------------------------
    message $PROJ_NAME
    [string]$action = if ($params.Count -gt 0) {$params[0]} Else {""}
    if ($action -eq "--cpp") {
        buildCpp
    } elseif ($action -eq "--dart") {
        buildDart
    } elseif ($action -eq "--pwsh") {
        buildPwsh
    } else {
        Write-Host "ERROR: [action] was not specified or not a valid parameter"
    }
}
build $args