// deno-lint-ignore-file no-explicit-any
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
const _aboutModule = `
TITLE:    melt_the_code Deno Module
VERSION:  v0.3.0-alpha (Released on 10 Nov 2022)
WEBSITE:  https://codemeled.com/modules/deno
LICENSE:  MIT / © 2022 Mark Shaffer. All Rights Reserved.
`;

// ----------------------------------------------------------------------------
// Module Support Definitions
// ----------------------------------------------------------------------------

/**
 * Identifies the API violations that can occur with the module that will
 * result in a CodeMeltedError.
 */
 const enum ErrorType {
    invalidType = 0,
    unsupportedRuntime = 1,
    transactionFailed = 2
}

/**
 * Represents the error that can be thrown from this module on an API
 * violation.
 */
class CodeMeltedError extends Error {
    // Member Fields:
    #type: ErrorType;

    /**
     * Constructor for the API violation within this module.
     * @param type The Error_t identifying the API violation.
     * @param message The message associated with the API violation.
     */
    constructor(type: ErrorType, message: string) {
        super(message);
        this.#type = type;
        this.name = "CodeMeltedError";

        // @ts-ignore This is to allow for proper capture of stack trace
        if (Error.captureStackTrace) {
            // @ts-ignore This is to allow for proper capture of stack trace
            Error.captureStackTrace(this, CodeMeltedError);
        }
    }

    /**
     * Identifies the type of error that violated this module's API.
     */
    public get type(): ErrorType {return this.#type; }

    /**
     * @return Gets a formatted string to include the stack trace of the violation.
     */
    public override get toString(): string {
        return `${this.name}: ${this.message}\n${this.stack}`;
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
            throw new CodeMeltedError(
                ErrorType.invalidType,
                "type parameter is expected as a string"
            );
        // Ignored as this is a JavaScript type.
        // deno-lint-ignore valid-typeof
        } else if (typeof v !== type) {
            throw new CodeMeltedError(
                ErrorType.invalidType,
                `v parameter is not of type ${type}`
            );
        }

        // Okay now see if we are checking against a function
        if (count !== undefined) {
            if (typeof v !== "function") {
                throw new CodeMeltedError(
                    ErrorType.invalidType,
                    "v was not a function to check against count"
                );
            } else if (typeof count !== "number") {
                throw new CodeMeltedError(
                    ErrorType.invalidType,
                    "count was not a number to check against v"
                );
            }

            if (v.length !== count) {
                throw new CodeMeltedError(
                    ErrorType.invalidType,
                    "v function did not have expected " +
                    count + " parameters"
                )
            }
        }
    }
}

/**
 * Supports getting the Deno namespace but wraps it in such a way to be cross
 * runtime supported.
 */
// @ts-ignore Deno is not part of tsc
function _getDeno(): typeof Deno | undefined {
    try {
        // @ts-ignore Deno is not part of tsc
        return Deno !== undefined || Deno !== null ? Deno : null;
    } catch (_e) {
        // Do nothing
    }
}

/**
 * The RuntimeAccessor provides access to the runtime environment for the
 * implementing use cases to perform their actions and determine use case
 * availability.
 */
abstract class RuntimeEnvironment {
    // Member Fields:
    #deno = _getDeno();

    /**
     * Attempts to get the deno runtime
     * @throws {CodeMeltedError} if it is accessed within an environment where
     * it is not available.
     */
    // @ts-ignore typedoc does not know Deno
    public tryGetDeno(): typeof Deno {
        if (this.#deno === null) {
            throw new CodeMeltedError(ErrorType.unsupportedRuntime,
                "Deno is not available in the Web Browser");
        }
        return this.#deno!;
    }
}

// ----------------------------------------------------------------------------
// Use AsyncIO Use Case
// ----------------------------------------------------------------------------

/**
 * Defines the definition of kicking off an asynchronous one shot task
 */
type TaskFunction = (data: any) => any;

/**
 * Supports the TaskRunner to process received events from a dedicated
 * AsyncIO task.
 */
type TaskRunnerHandler = {
    onmessge: (e: MessageEvent) => void;
    onerror: (e: ErrorEvent) => void;
    onmessageerror: (e: MessageEvent) => void;
}

/**
 * Wraps a Worker object spawned from the AsyncIO dedicated() call to support
 * an ongoing background processing task.
 */
class TaskRunner {
    // Member Fields
    #worker: Worker;

    /**
     * Constructs the dedicated wrapped Worker object.
     * @param taskUrl The URL to the dedicated worker processor
     * @param handler The TaskRunnerHandler to receive messages from the Worker.
     */
    constructor(taskUrl: string, handler: TaskRunnerHandler) {
        try {
            this.#worker = new Worker(taskUrl);
            this.#worker.onmessage = handler.onmessge;
            this.#worker.onerror = handler.onerror;
            this.#worker.onmessageerror= handler.onmessageerror;
        } catch (err) {
            throw new CodeMeltedError(ErrorType.transactionFailed, `${err}`);
        }
    }

    /**
     * Sends data for processing in the dedicated worker.
     * @param message The data to process.
     */
    public postMessage(message: any) {
        this.#worker.postMessage(message);
    }

    /**
     * Terminates the dedicated worker.
     */
    public terminate() {
        this.#worker.terminate();
    }
}

/**
 * Implements the Use AsyncIO use case providing the ability to divide work
 * within asynchronous tasks.  This can be either as a one shot in the main or
 * background task or as a dedicated task with a separate worker file.
 */
class UseAsyncIO extends RuntimeEnvironment {
    /**
     * Constructs the dedicated wrapped Worker object.
     * @param taskUrl The URL to the dedicated worker processor
     * @param handler The TaskRunnerHandler to receive messages from the Worker.
     */
    public dedicated(taskUrl: string, handler: TaskRunnerHandler): TaskRunner {
        return new TaskRunner(taskUrl, handler);
    }

    /**
     * Kicks off a one shot asynchronous task.
     * @param task The task to perform
     * @param data Data to be passed to the task for processing
     * @param isBackground false for main thread or true for a background worker
     * @param delay A delay to apply before kicking off the task.
     */
    public oneShot(
        task: TaskFunction,
        data: any,
        isBackground: boolean,
        delay: 0
    ): Promise<any> {
        return new Promise<any>((resolve, reject) => {
            setTimeout(() => {
                if (!isBackground) {
                    try {
                        resolve(task(data));
                    } catch (err) {
                        reject(err);
                    }
                } else {
                    const taskCode =
                        `self.onmessage = function(e) {
                            let data = e.data;
                            let result = (${task})();
                            postMessage(result);
                        };`
                    const taskUrl = URL.createObjectURL(new Blob([taskCode],
                        { type:'text/javascript' }));
                    const worker = new Worker(taskUrl);
                    if (worker !== null) {
                        worker.onmessage = (e) => {
                            resolve(e.data);
                            worker.terminate();
                        };
                        worker.onerror = (e) => {
                            worker.terminate();
                            reject(new CodeMeltedError(ErrorType.transactionFailed,
                                `${e}`));
                        };
                    } else {
                        reject(new CodeMeltedError(ErrorType.transactionFailed,
                            "Unable to obtain a Worker"));
                    }
                }
            }, delay);
        });
    }

    /**
     * Provides the ability to delay in an asynchronous function.
     * @param timeout How long to delay in milliseconds
     */
     public sleep(timeout: number): Promise<void> {
        return new Promise<void>((resole) => {
            setTimeout(() => resole(), timeout);
        });
    }
}

// ----------------------------------------------------------------------------
// Use Disk Use Case
// ----------------------------------------------------------------------------

/**
 * The file information retrieved from the ManageDiskAction.ls request.
 */
 type FileInfo = {
    filename: string,
    size: number
    isFile: boolean,
    isDirectory: boolean,
    isSymLink: boolean,
}

/**
 * Wrapper object for working with a file on disk.
 */
class FileBroker {
    // Member Fields
    // @ts-ignore typedoc does not know Deno
    #fs: Deno.FsFile;

    /**
     * Opens the file to work with
     * @param deno Reference to the Deno runtime.
     * @param path Path to the file to open
     * @throws {CodeMeltedError} if the file could not be opened.
     */
    // @ts-ignore typedoc does not know Deno
    constructor(deno: typeof Deno, path: string) {
        try {
            this.#fs = deno.openSync(path, { read: true, write: false });
        } catch (err) {
            throw new CodeMeltedError(ErrorType.transactionFailed, `${err}`);
        }
    }

    /**
     * Reads data into the buffer
     * @param buf Uint8Array representing the buffer to store the read data.
     * @returns Number of bytes stored into the array or -1 if EOF
     * @throws {CodeMeltedError} in the event of a read error.
     */
    public read(buf: Uint8Array): number {
        try {
            const readBytes = this.#fs.readSync(buf);
            return readBytes ? readBytes : -1;
        } catch (err) {
            throw new CodeMeltedError(ErrorType.transactionFailed, `${err}`);
        }
    }

    /**
     * Sets the read pointer within the file.
     * @param offset How far to move the file pointer to read / write the
     * next buffer.
     * @returns The new file position
     * @throws {CodeMeltedError} in the event of a read error.
     */
    public seek(offset: number): number {
        try {
            // @ts-ignore typedoc does not know Deno
            return this.#fs.seekSync(offset, Deno.SeekMode.Current);
        } catch (err) {
            throw new CodeMeltedError(ErrorType.transactionFailed, `${err}`);
        }
    }

    /**
     * Writes the buffer to file.
     * @param buf The buffer to write.
     * @returns The number of bytes written to file.
     * @throws {CodeMeltedError} in the event of a write error.
     */
    public write(buf: Uint8Array): number {
        try {
            return this.#fs.writeSync(buf);
        } catch (err) {
            throw new CodeMeltedError(ErrorType.transactionFailed, `${err}`);
        }
    }

    /**
     * Closes the file handler.
     * @throws {CodeMeltedError} in the event of a write error.
     */
    public close() {
        try {
            this.#fs.close();
        } catch (err) {
            throw new CodeMeltedError(ErrorType.transactionFailed, `${err}`);
        }
    }
}

/**
 * Implements the Use Disk use case providing the ability to manipulate files
 * and directories on disk or retrieve file information about a given directory
 * on disk.
 */
class UseDisk extends RuntimeEnvironment {
    /**
     * Helper method to try a transaction and report its failure
     * @param fn The wrapped function to try
     * @throws {CodeMeltedError} if the transaction fails.
     */
    #tryDenoTransaction(fn: () => void) {
        try {
            fn();
        } catch (err) {
            throw new CodeMeltedError(ErrorType.transactionFailed, `${err}`);
        }
    }

    /**
     * Copies a file / directory from the source to the destination.
     * @param src The source file / directory
     * @param dest The destination file / directory
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public cp(src: string, dest: string) {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", src);
        CodeMeltedError.checkParam("string", dest);
        this.#tryDenoTransaction(() => {
            deno.copyFileSync(src, dest);
        });
    }

    /**
     * Gets the list of files / directories from the given path
     * @param path The directory / file to get information about
     * @returns {FileInfo[]} of the file information.
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public ls(path: string): FileInfo[] {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", path);
        const result: FileInfo[] = [];
        this.#tryDenoTransaction(() => {
            const dirList = deno.readDirSync(path);
            for (const dirEntry in dirList) {
                const fileInfo = deno.lstatSync(dirEntry);
                result.push({
                    filename: dirEntry,
                    isDirectory: fileInfo.isDirectory,
                    isFile: fileInfo.isFile,
                    isSymLink: fileInfo.isSymlink,
                    size: fileInfo.size
                });
            }
        });
        return result;
    }

    /**
     * Makes a directory at the specified path
     * @param path The directory to create
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public mkdir(path: string) {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", path);
        this.#tryDenoTransaction(() => {
            deno.mkdirSync(path);
        });
    }

    /**
     * Moves a directory / file to a new location.
     * @param src The source file / directory
     * @param dest The destination file / directory
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public mv(src: string, dest: string) {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", src);
        CodeMeltedError.checkParam("string", dest);
        this.#tryDenoTransaction(() => {
            deno.renameSync(src, dest as string);
        });
    }

    /**
     * Opens a file on disk to work with its contents in binary form.
     * @param path The location of the file
     * @returns {FileBroker} object to work with the file.
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public openFile(path: string): FileBroker {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", path);
        return new FileBroker(deno, path);
    }

    /**
     * Reads all the contents of a file as a binary array.
     * @param path Path to the file to read.
     * @returns {Uint8Array} object.
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public readFile(path: string): Uint8Array {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", path);
        let data = new Uint8Array(0);
        this.#tryDenoTransaction(() => {
            data = deno.readFileSync(path);
        });
        return data;
    }

    /**
     * Reads all the contents of a file as text.
     * @param path Path to the file to read.
     * @returns {string} of all the file contents.
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public readTextFile(path: string): string {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", path);
        let data = '';
        this.#tryDenoTransaction(() => {
            data = deno.readTextFileSync(path);
        });
        return data;
    }

    /**
     * Removes a file / directory from disk.
     * @param path The location of file / directory to remove.
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public rm(path: string) {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", path);
        this.#tryDenoTransaction(() => {
            deno.removeSync(path);
        });
    }

    /**
     * Writes the specified content to a file.
     * @param path Path to the file to write the contents.
     * @param data The binary data of the file.
     * @param append true to append false to create / overwrite.
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public writeFile(path: string, data: Uint8Array, append: false) {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", path);
        CodeMeltedError.checkParam("object", data);
        this.#tryDenoTransaction(() => {
            deno.writeFileSync(path, data, {append: append});
        });
    }

    /**
     * Writes the specified text to file.
     * @param path Path to the file to write the contents.
     * @param data The binary data of the file.
     * @param append true to append false to create / overwrite.
     * @throws {CodeMeltedError} if the transaction fails.
     */
    public writeTextFile(path: string, data: string, append: false) {
        const deno = this.tryGetDeno();
        CodeMeltedError.checkParam("string", path);
        CodeMeltedError.checkParam("string", data);
        this.#tryDenoTransaction(() => {
            deno.writeTextFileSync(path, data, {append: append});
        });
    }
}

// ----------------------------------------------------------------------------
// Use Math Use Case
// ----------------------------------------------------------------------------

/**
 * Implements the Use Math use case providing access to a collection of
 * mathematical formulas.
 */
 class UseMath extends RuntimeEnvironment {
    /**
     * Converts celsius to fahrenheit.
     * @param v Celsius value.
     * @returns converted temperature.
     */
    public celsiusToFahrenheit(v: number): number {
        CodeMeltedError.checkParam("number", v);
        return v * (9/5) + 32;
    }

    /**
     * Converts celsius to kelvin.
     * @param v Celsius value.
     * @returns converted temperature.
     */
    public celsiusToKelvin(v: number): number {
        CodeMeltedError.checkParam("number", v);
        return v + 273.15;
    }

    /**
     * Converts fahrenheit to celsius.
     * @param v fahrenheit value.
     * @returns converted temperature.
     */
    public fahrenheitToCelsius(v: number): number {
        CodeMeltedError.checkParam("number", v);
        return (v - 32) * (5/9);
    }

    /**
     * Converts fahrenheit to kelvin.
     * @param v fahrenheit value.
     * @returns converted temperature.
     */
    public fahrenheitToKelvin(v: number): number {
        CodeMeltedError.checkParam("number", v);
        return ((v - 32) * (5/9)) + 273.15;
    }

    /**
     * Converts kelvin to celsius.
     * @param v kelvin value.
     * @returns converted temperature.
     */
    public kelvinToCelsius(v: number): number {
        CodeMeltedError.checkParam("number", v);
        return v - 273.15;
    }

    /**
     * Converts kelvin to fahrenheit.
     * @param v kelvin value.
     * @returns converted temperature.
     */
    public kelvinToFahrenheit(v: number): number {
        CodeMeltedError.checkParam("number", v);
        return ((v - 273.15) * (9/5)) + 32;
    }
}

// ----------------------------------------------------------------------------
// Public API Implementation
// ----------------------------------------------------------------------------

/**
 * The module implementing API to access each of the implemented use cases.
 */
class CodeMeltedAPI {
    // Member Fields:
    #useAsyncIO = new UseAsyncIO();
    #useDisk = new UseDisk();
    #useMath = new UseMath();

    /**
     * You just want to know what it is you are using.
     */
    public aboutModule(): string { return _aboutModule; }

    /**
     * Sometimes need to divide up your work to allow for other work.  This
     * use case provides you the ability to one shot a task either in the main
     * thread or in the background, kickoff a dedicated task, or simply sleep
     * an asynchronous task.
     */
    public useAsyncIO(): UseAsyncIO { return this.#useAsyncIO; }

    /**
     * Want to perform house keeping of files and directories on your disk.
     * This use case provides you the common methods to manage a disk and query
     * information about files and directories on that disk.
     */
    public useDisk(): UseDisk { return this.#useDisk; }

    /**
     * Math is hard.  Remembering formulas is even harder.  This use case
     * provides you with a collection of all sorts of common formulas from
     * unit conversions, geometric, algebraic, geodetic, physics, and much
     * more.
     */
    public useMath(): UseMath { return this.#useMath; }
}
const _api = new CodeMeltedAPI();

/**
 * The main entry point into the module API.
 */
function meltTheCode(): CodeMeltedAPI {
   return _api;
}

export {
    ErrorType,
    CodeMeltedError,
    RuntimeEnvironment,
    TaskRunner,
    UseAsyncIO,
    FileBroker,
    UseDisk,
    UseMath,
    CodeMeltedAPI,
    meltTheCode
};
export type {
    TaskFunction,
    TaskRunnerHandler,
    FileInfo
};
