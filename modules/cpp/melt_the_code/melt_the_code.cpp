
/*
===============================================================================
MIT License

© 2023 Mark Shaffer. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
===============================================================================
*/
#include "melt_the_code.h"

namespace melt_the_code {
// ----------------------------------------------------------------------------
// Global Definitions
// ----------------------------------------------------------------------------

static const char* ABOUT_MODULE = R""""(
    TITLE:    melt_the_code C++ Module
    VERSION:  v0.1.0 (Released on 18 Feb 2023)
    WEBSITE:  https://codemeled.dev/modules/cpp/melt_the_code
    LICENSE:  MIT / © 2023 Mark Shaffer. All Rights Reserved.
    )"""";


// ----------------------------------------------------------------------------
// Public API Implementation
// ----------------------------------------------------------------------------

CodeMeltedAPI::CodeMeltedAPI() { }

CodeMeltedAPI::~CodeMeltedAPI() { }

const char* CodeMeltedAPI::aboutModule() const {
    return ABOUT_MODULE;
}

CodeMeltedAPI& CodeMeltedAPI::instance() {
    static CodeMeltedAPI _instance;
    return _instance;
}

CodeMeltedAPI& meltTheCode() {
    return CodeMeltedAPI::instance();
}

} // END NAMESPACE

