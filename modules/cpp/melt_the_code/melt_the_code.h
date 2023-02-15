/**
 * @file melt_the_code.h
 * @author Mark Shaffer (mark.shaffer@codemelted.com)
 * @brief Specifies the melt_the_code C++ module interface.
 * @version 0.0.0 (Last updated on dd mmm yyyy)
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
#ifndef MELT_THE_CODE_H
#define MELT_THE_CODE_H

#ifdef __cplusplus
extern "C" {
#endif

// -----------------------------------------------------------------------------
// Main API
// -----------------------------------------------------------------------------

/**
 * @brief Retrieves the information about the module.
 * @returns const char*
 */
typedef const char* (*aboutModuleFunction)(void);

/**
 * @brief Represents the API of the module with functional pointers
 * representing the API accessed via the meltTheCode() function.
 */
typedef struct {
    /**
     * @brief Retrieves the information about the module.
     * @returns const char*
     */
    aboutModuleFunction aboutModule;
} CodeMelted;

/**
 * @brief Main entry point into the module accessing the main CodeMelted
 * pointer.
 *
 * @returns CodeMelted*
 */
CodeMelted* meltTheCode(void);

#ifdef __cplusplus
}
#endif

#endif // MELT_THE_CODE_H