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


function build {
    # -------------------------------------------------------------------------
    # Constants
    # -------------------------------------------------------------------------
    [string]$PROJ_NAME = "melt_the_code C/C++ Module"
    [string]$SCRIPT_PATH = $PSScriptRoot
    [string]$SRC_PATH = $SCRIPT_PATH + "/melt_the_code"
    [string]$DIST_PATH = "$SRC_PATH/dist/cpp/melt_the_code"
    # [string]$COVERAGE_PATH = $SRC_PATH + "/coverage"

    # # -------------------------------------------------------------------------
    # # Helper Functions
    # # -------------------------------------------------------------------------
    # function _formatHtml([string] $path) {
    #     $htmlFiles = Get-ChildItem -Path $path -Filter *.html
    #     foreach ($file in $htmlFiles) {
    #         [string]$newFile = $file.Directory.FullName + [IO.Path]::DirectorySeparatorChar +
    #             "new" + $file.Name
    #         foreach ($line in Get-Content $file) {
    #             if ($line.Contains("<head>")) {
    #                 $line | Out-File -FilePath $newFile -Append
    #                 "<meta name='viewport' content='width=device-width, initial-scale=1'>" | Out-File -FilePath $newFile -Append
    #             } elseif ($line.Contains("</head>")) {
    #                 $CSS_STYLE | Out-File -FilePath $newFile -Append
    #             } else {
    #                 $line | Out-File -FilePath $newFile -Append
    #             }
    #         }
    #         Remove-Item -Path $file -Force
    #         Rename-Item -Path $newFile -NewName $file -Force
    #         Write-Host $file created.
    #     }
    # }

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
    # Generate our documentation
    # -------------------------------------------------------------------------
    Write-Host "MESSAGE: Now generating doxygen"
    Write-Host
    Set-Location $SRC_PATH
    doxygen doxygen.cfg
    Move-Item -Path docs "$DIST_PATH" -Force
    Set-Location $SCRIPT_PATH
    Write-Host
    Write-Host "MESSAGE: doxygen generated"

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