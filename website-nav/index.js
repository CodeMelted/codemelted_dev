/**
 * @file Provides a javascript module to skin github pages after they are
 *  rendered to provide a consistent navigation look.
 * @copyright 2023 Mark Shaffer. All Rights Reserved.
 * @license MIT
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

const PROTOCOL_HOST = `${location.protocol}//${location.host}`;
const HTML_TEMPLATE = `
<style>
    /*
    ==========================
    Setup our scrollbar styles
    ==========================
    */
    /* width */
    ::-webkit-scrollbar {
        width: 5px;
        height: 3px;
    }
    /* Track */
    ::-webkit-scrollbar-track {
        background: darkslategray;
    }
    /* Handle */
    ::-webkit-scrollbar-thumb {
        background: #888;
    }
    /* Handle on hover */
    ::-webkit-scrollbar-thumb:hover {
        background: #555;
    }

    body {
        margin-top: 60px;
        margin-bottom: 65px;
    }

    header {
        display: none;
    }

    /* Header */
    .cm-fixed-header {
        display: grid;
        grid-template-columns: 1fr auto auto;
        border: 1px solid black;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 55px;
        background-color: black;
        color: white;
        font-family: sans-serif;
        font-size: 12px;
        z-index: 2147483648;
    }
    .cm-fixed-header button {
        background-color: black;
        color: white;
        outline: none;
        border: none;
        cursor: pointer;
        font-size: 12px;
    }
    .cm-logo {
        display: block;
        height: 35px;
        margin-top: 12px;
        margin-left: 23px;
    }
    .cm-logo:hover {
        cursor: pointer;
    }

    /* Footer */
    .cm-fixed-footer {
        padding-top: 5px;
        padding-bottom: 5px;
        z-index: 2147483648;
        display: grid;
        grid-template-columns: auto auto;
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        background-color: rgb(96, 125, 139);
        color: white;
        text-align: center;
        font-size: 12px;
    }

    .cm-fixed-footer button {
        background-color: rgb(96, 125, 139);
        color: white;
        outline: none;
        border: none;
        cursor: pointer;
        font-size: 12px;
    }

    .active, .cm-fixed-footer button:hover {
        font-weight: bold;
        color: black;
        background-color: rgb(189, 189, 189);
    }

    /* Handle nice printing on the page */
    @media print {
        .cm-fixed-header {
            display: none;
        }
        .cm-fixed-footer {
            display: none;
        }
        footer {
            display: none;
        }
    }
</style>

<div id="divFixedHeader" class="cm-fixed-header">
    <img id="imgLogo" alt="logo" class="cm-logo" src="${PROTOCOL_HOST}/website-nav/logos/logo-593x100.png" />
    <button id="btnWeb"><img style="height: 35px;" src="${PROTOCOL_HOST}/website-nav/icons/icons8-website-48.png" /></button>
</div>

<div id="divFixedFooter" class="cm-fixed-footer">
    <!-- <button id="btnCpp"><img style="height: 25px;" src="${PROTOCOL_HOST}/website-nav/icons/icons8-c++-48.png" /><br/>C++</button> -->
    <button id="btnPwsh"><img style="height: 25px;" src="${PROTOCOL_HOST}/website-nav/icons/ps_black_64.png" /><br/>pwsh</button>
    <button id="btnDeno"><img style="height: 25px;" src="${PROTOCOL_HOST}/website-nav/icons/icons8-deno-100x100.png" /><br />deno</button>
    <!-- <button id="btnFlutter"><img style="height: 25px;" src="${PROTOCOL_HOST}/website-nav/icons/icons8-flutter-48.png" /><br />Flutter</button> -->
</div>
`;

const PAGE_OPTIONS_TEMPLATE = `
<style>
    .cm-page-options {
        text-align: center;
        max-width: 50em;
        margin: auto;
        padding: 0.6250em;
    }
    .cm-page-options button {
        height: 30px;
        background-color: transparent;
        outline: none;
        border: none;
        cursor: pointer;
        font-size: 30px;
    }
    .cm-page-options img {
        height: 30px;
    }
    .cm-page-options a {
        cursor: pointer;
    }
    @media print {
        .cm-page-options {
            display: none;
        }
    }
</style>
<div class="cm-page-options">
    <button id="btnSupport"><img src="${PROTOCOL_HOST}/website-nav/icons/bmc-button.png" /></button>
    <button id="btnPrint"><img src="${PROTOCOL_HOST}/website-nav/icons/icons8-print-96.png" /></button>
</div>
`;

// Page navigation
const HOME_PAGE = "/modules";
const PORTAL_PAGE = "https://codemelted.com";
const URL_PAGE = {
    // "Cpp"     : `${HOME_PAGE}/cpp/melt_the_code`,
    "Pwsh"    : `${HOME_PAGE}/pwsh/melt_the_code`,
    "Deno"    : `${HOME_PAGE}/deno/melt_the_code`,
    // "Flutter" : `${HOME_PAGE}/flutter/melt_the_code`,
};

/**
 * Determines if this is a mobile browser or not.
 * @returns true if mobile browser, false otherwise.
 */
function isMobile() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.
        test(navigator.userAgent);
}

/**
 * Opens a popup and sends a signal via query string to signal whether it
 * was opened via the main portal or not.
 * @param {string} url The url to open.
 * @param {string} windowName The title of the popup
 * @param {number} w The width of the popup
 * @param {number} h The height of the popup
 * @param {string} action An action to carry out for the popup window.
 */
function popupWindow(url, windowName, w, h, action = undefined) {
    const top = (screen.height -  h) / 2;
    const left = (screen.width -  w) / 2;
    window.open(
        action !== undefined ? `${url}?action=${action}` : url,
        windowName,
        `toolbar=no, location=no, directories=no, status=no, ` +
        `menubar=no, scrollbars=no, resizable=yes, copyhistory=no, ` +
        `width=${w}, height=${h}, top=${top}, left=${left}`
    );
}

/**
 * Main entry point of this script
 */
function main() {
    // Overlay our template
    document.body.innerHTML = PAGE_OPTIONS_TEMPLATE +
        document.body.innerHTML + HTML_TEMPLATE;
    const href = window.location.href;

    // Go get our options to determine how we are to render
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const isEmbedded = urlParams.has("isEmbedded")
        ? urlParams.get("isEmbedded") === "true" ? true : false
        : window.location !== window.parent.location
            ? true
            : false;

    const popupAction = urlParams.has("action")
        ? urlParams.get("action")
        : undefined;

    // Now determine how we setup our behavior
    if (popupAction) {
        // If print action, go setup our print process
        // Anything else simply just popups the window
        if (popupAction === "print") {
            document.getElementById("divFixedHeader").style.display = "none";
            document.getElementById("divFixedFooter").style.display = "none";
            document.getElementsByClassName("cm-page-options")[0]
                .style.display = "none";
            document.body.style.marginTop = "5px";
            setTimeout(() => {
                window.print();
                if (!isMobile()) {
                window.close();
                }
          }, 500);
        }
    } else {
        // Hide some controls based on if we are embedded
        if (isEmbedded) {
            document.getElementById("divFixedHeader").style.display = "none";
            document.body.style.marginTop = "5px";
        }

        // Create the button actions to navigate to the appropriate page.
        // and set the if it is active or not depending on the page
        // navigated to.
        for (const [key, value] of Object.entries(URL_PAGE)) {
            const btn = document.getElementById(`btn${key}`);

            // Assign the button action
            btn.addEventListener("click", () => {
                window.location.href = isEmbedded
                    ? `${value}?isEmbedded=true`
                    : value;
            });

            // Determine and set the active tab if found
            if (href.toLowerCase().includes(key.toLowerCase())) {
                btn.style.backgroundColor = "rgb(189, 189, 189)";
                btn.style.color = "black";
                btn.style.fontWeight = "bold";
                btn.classList.add("active");
                isSubPageActive = true;
                docsHRef = value;
                coverageHRef = value.replace("/docs", "/coverage");
            }
        }

        // Now assign our button actions, states from above will affect
        // how some of those action are performed.
        document.getElementById("imgLogo").addEventListener("click", () => {
            window.location.href = "/";
        });

        document.getElementById("btnWeb").addEventListener("click", () => {
            window.location.href = `${PORTAL_PAGE}?iframe=${href}`;
        });

        document.getElementById("btnSupport").addEventListener("click", () => {
            popupWindow("https://www.buymeacoffee.com/codemelted",
                "Buy Me a Coffee", 900, 600);
        });

        document.getElementById("btnPrint").addEventListener("click", () => {
            popupWindow(href.split("?")[0], document.title, 800, 500, "print");
        });

        // On our main page or the jeep page hide the docs and coverage button.
        // It will not have that as it is documenting the page
        if (href.includes("jeep-pi")) {
            document.getElementById("divFixedHeader").style.display = "none";
            document.getElementById("divFixedFooter").style.display = "none";
        }
    }
}
main();
