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
#ifndef MELT_THE_CODE_H
#define MELT_THE_CODE_H

/**
 * @brief Namespace wrapper for the melt_the_code module.
 */
namespace melt_the_code {

/**
 * @brief The main API wrapper providing access to the implemented use cases.
 */
class CodeMeltedAPI {
public:
    /**
     * @brief You just want to know what it is you are using.
     * @return const char*
     */
    const char* aboutModule() const;

private:
    // Setup for the module to be accessed via the function.
    CodeMeltedAPI(CodeMeltedAPI const&) = delete;
    CodeMeltedAPI(CodeMeltedAPI&&) = delete;
    CodeMeltedAPI& operator=(CodeMeltedAPI const&) = delete;
    CodeMeltedAPI& operator=(CodeMeltedAPI &&) = delete;
    CodeMeltedAPI();
    ~CodeMeltedAPI();
    static CodeMeltedAPI& instance();
    friend CodeMeltedAPI& meltTheCode();
};

/**
 * @brief Provides the access point into the melt_the_code module.
 * @return CodeMeltedAPI&
 */
CodeMeltedAPI& meltTheCode();

} // END NAMESPACE

#endif // MELT_THE_CODE_H
