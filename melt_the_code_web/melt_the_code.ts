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

/**
 * @module melt_the_code
 */

// ----------------------------------------------------------------------------
// Definitions
// ----------------------------------------------------------------------------

const _aboutModule = `
    TITLE:    melt_the_code_web Module
    VERSION:  v0.1.0 (Released on 18 Feb 2023)
    WEBSITE:  https://codemelted.dev/modules/deno/melt_the_code
    LICENSE:  MIT / © 2023 Mark Shaffer. All Rights Reserved.
    `;

/**
 * Exception thrown if a use case transaction fails to execute.  It will
 * identify the reason for the failure.
 */
class UseCaseFailure extends Error {
    constructor(message: string) {
        super(message);
        this.name = "UseCaseFailure";
    }

    /**
     * Performs a check to ensure the parameter is what is expected.
     *
     * @param type string identifying the expected type
     * @param v The parameter to be checked
     * @param count Optional if checking a function for an
     *  expected number of parameters
     * @throws {CodeMeltedError} When the parameter is not as expected.
     */
    public static checkParam(type: string, v: any, count?: number) {
        // Validate our expected parameters and perform our check
        if (typeof type !== "string") {
            throw new UseCaseFailure(
                "type parameter is expected as a string"
            );
        // Ignored as this is a JavaScript type.
        // deno-lint-ignore valid-typeof
        } else if (typeof v !== type) {
            throw new UseCaseFailure(
                `v parameter is not of type ${type}`
            );
        }

        // Okay now see if we are checking against a function
        if (count !== undefined) {
            if (typeof v !== "function") {
                throw new UseCaseFailure(
                    "v was not a function to check against count"
                );
            } else if (typeof count !== "number") {
                throw new UseCaseFailure(
                    "count was not a number to check against v"
                );
            }

            if (v.length !== count) {
                throw new UseCaseFailure(
                    "v function did not have expected " +
                    count + " parameters"
                )
            }
        }
    }
}

// ----------------------------------------------------------------------------
// Enumerations
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Public Facing API
// ----------------------------------------------------------------------------

/**
 * The implementing API to access each of the use case implemented functions.
 */
interface CodeMeltedAPI {
    /**
     * You just want to know what it is you are using.
     */
    aboutModule(): string;
}

/**
 * Main entry point to the CodeMeltedAPI interface.
 * @returns {CodeMeltedAPI} interface
 */
function meltTheCode(): CodeMeltedAPI {
    return Object.freeze({
        aboutModule: function() {
            return _aboutModule;
        }
    });
}

export {
    UseCaseFailure,
    meltTheCode
};

export type {
    CodeMeltedAPI
};