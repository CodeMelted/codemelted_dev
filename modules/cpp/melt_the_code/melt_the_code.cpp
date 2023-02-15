/**
 * @file melt_the_code.cpp
 * @author Mark Shaffer (mark.shaffer@codemelted.com)
 * @brief Implements the melt_the_code C++ module interface.
 *
 * @copyright Copyright (c) 2022
 *
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#include "melt_the_code.h"

#include <sstream>
#include <functional>

#ifdef _WIN32
    #define NEWLINE "\r\n"
#elif defined macintosh // OS 9
    #define NEWLINE "\r"
#else
    #define NEWLINE "\n" // Mac OS X uses \n
#endif

// ----------------------------------------------------------------------------
// Module Support
// ----------------------------------------------------------------------------

namespace {

static const char* _aboutModule =
    "TITLE:     melt_the_code C/C++ Module" NEWLINE
    "VERSION:   v0.0.0 (Released on 01 May 2022)" NEWLINE
    "WEBSITE:   https://xplat-module.codemelted.com/cpp/melt_the_code/docs" NEWLINE
    "LICENSE:   MIT / (c) 2022 Mark Shaffer. All Rights Reserved." NEWLINE;

static CodeMelted _api;

} // END NAMESPACE

// ----------------------------------------------------------------------------
// Main API
// ----------------------------------------------------------------------------

CodeMelted* meltTheCode(void) {
    // Fill in each of the nullptr for the public API with lambdas that utilize
    // the support implementation of the module.
    if (_api.aboutModule == nullptr) {
        _api.aboutModule = []() { return _aboutModule; };
    }

    return &_api;
}
