
//LCOV_EXCL_START
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

#include <gtest/gtest.h>
#include <string>

#include "melt_the_code.h"

TEST(CodeMeltedAPI, aboutModule) {
    using namespace melt_the_code;
    std::string v = meltTheCode().aboutModule();

    ASSERT_TRUE(v.find("TITLE:") != std::string::npos);
    ASSERT_TRUE(v.find("VERSION:") != std::string::npos);
    ASSERT_TRUE(v.find(
        "WEBSITE:  https://codemeled.dev/modules/cpp/melt_the_code")
        != std::string::npos
    );
    ASSERT_TRUE(v.find("LICENSE:") != std::string::npos);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
//LCOV_EXCL_END