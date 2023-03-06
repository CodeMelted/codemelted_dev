<h1><img style="height: 30px;" src="website-nav/icons/icons8-design-48.png" /> Cross Platform Modules </h1>

**Table of Contents**

- [1.0 Introduction](#10-introduction)
  - [1.1 Purpose](#11-purpose)
  - [1.2 Scope](#12-scope)
- [2.0 Module Architecture](#20-module-architecture)
  - [2.1 Technology Stack](#21-technology-stack)
  - [2.2 Functional Decomposition](#22-functional-decomposition)
  - [2.3 Use Case Implementation Process](#23-use-case-implementation-process)
- [3.0 Repo Setup](#30-repo-setup)
  - [3.1 Installations](#31-installations)
    - [3.1.1 Tools](#311-tools)
    - [3.1.2 Visual Studio Code](#312-visual-studio-code)
  - [3.2 Testing](#32-testing)
    - [3.2.1 Dev Site Validation](#321-dev-site-validation)
    - [3.2.2 Final Publishing](#322-final-publishing)
- [4.0 License](#40-license)

# 1.0 Introduction

## 1.1 Purpose

"Write once, run anywhere (WORA)" was the famous slogan made by Sun Microsystems in 1995.  At the time, this technology allowed for easy full stack engineering allowing you to target dedicated workstations and on premise servers. So long as a Java Runtime Environment existed, you could run your code.

Java was unable to keep to their slogan as web browsers became more advanced, mobile devices became ubiquitous, and companies no longer required dedicated servers.  Software engineers are now required to learn multiple languages, technologies, and frameworks in order to fully support full stack engineering.

This project aims to simplify by developing a set of cross platform modules implementing a similar / identical Application Program Interface (API) regardless of the chosen technology covered by this project.  This allows a developer to maximize their productivity because regardless of the technology, they are learning a similar module API for their solution.

## 1.2 Scope

The scope of this project is to deliver a set of cross platform modules that allow a developer to tackle the different technology stacks.  The chosen language SDKs described in the table below.

SDK | Description
--- | ---
`C++` | Will focus on squeezing every ounce of performance for lower level items.  This will not implement any User Interface use cases.  It will only implement the console based CLI use cases.
`pwsh` | Will provides the use case features for automating dev ops tasks or supporting cloud systems via a CLI or a Textual User Interface (TUI).
`dart` | The ideal solution for scripting cloud based services but can also be used same as `pwsh` to automate tasks via scripts.
`flutter` | Builds upon the `dart` module but provides a cross platform ability to build desktop, mobile, and web based applications
`web` | An implementation of the identified use cases for a pure web browser experience.

# 2.0 Module Architecture

This section breaks down the targeted technology stacks, the identified use case features to be designed and implemented, and the process that will be follows.

## 2.1 Technology Stack

The following diagram identified the cross platform module ideal for the targeted technology stack and the definition of those stacks.

<img src="use_case_features/design/tech-stack.drawio.png" />

## 2.2 Functional Decomposition

The following use case model identifies the common use cases an application would need to target.  These will be derived into use case features that flesh out the design of the use case implementation into each appropriate module.  Those are linked in the list below the diagram.

<img src="use_case_features/design/use-case-model.drawio.png" />

**Use Case Features**

- [About Module](use_case_features/about-module.md)

## 2.3 Use Case Implementation Process

The following is the design methodology for implementing each of the identified use case features and supports [3.2 Testing](#32-testing)

<img src="use_case_features/design/dev-module-process.drawio.png" />

# 3.0 Repo Setup

Path | Description
--- | ---
`.firebase` | The cached dev website from the previous firebase deployment.
`dist` | The Melt the Code - DEV website for testing and deployment.
`melt_the_code_xxx` | Represents the source control for each of the `melt_the_code` modules.
`use_case_features` | The collection of markdown documents fleshing out each of the identified use cases from the [2.2 Functional Decomposition](#22-functional-decomposition)
`website-nav` | The developed JavaScript module that drives the https://codemelted.dev site
`./*` | Remaining files that support the site.

## 3.1 Installations

The following are the tools necessary to make changes to this repo.

### 3.1.1 Tools

*NOTE: If installing on Mac OS, you may want to consider [Homebrew](https://brew.sh) to install some of the items below as they may not work as advertised on their websites.*

- [ ] [Git](https://git-scm.com/)
- [ ] [GitHub Desktop](https://desktop.github.com/) (not required just nice to have)
- [ ] [C++](https://code.visualstudio.com/docs/languages/cpp)
- [ ] [doxygen](https://www.doxygen.nl)
- [ ] [nodejs](https://nodejs.org/en/)
- [ ] [typescript](https://www.npmjs.com/package/typescript) (install globally)
- [ ] [typedoc](https://typedoc.org/guides/installation/) (install globally)
- [ ] [flutter](https://flutter.dev/)
- [ ] [dartdoc](https://pub.dev/packages/dartdoc)
- [ ] [pwsh](https://github.com/PowerShell/PowerShell#get-powershell)
- [ ] [Pester](https://www.powershellgallery.com/packages/Pester/5.1.1)
- [ ] [Python3](https://www.python.org/)

### 3.1.2 Visual Studio Code

- [ ] [VS Code](https://code.visualstudio.com/)
- [ ] [C/C++ Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack)
- [ ] [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [ ] [Deno](https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno)
- [ ] [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [ ] [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [ ] [PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)

## 3.2 Testing

The following procedure represent the steps to confirm your setup of the previous section tooling worked and would also be used for any validation of changes made to this repo via the

### 3.2.1 Dev Site Validation

- [ ] Open a terminal to the repo
- [ ] Execute the command `./build.ps1 --dev-site` in the terminal window.  View the output and confirm no errors in the execution.
- [ ] Execute the command `cd dist` to bring you to the built output
- [ ] Execute the command `python3 -m http.server` to start a web server
- [ ] Open a web browser window and enter the address `http://[::]:8000/`.  You should see the DEV page rendered and all the links should work

### 3.2.2 Final Publishing

- [ ] Open a terminal window.
- [ ] Change directories to the `codemelted_dev` repo
- [ ] Run the command `./build.ps1 --deploy` to deploy the Melt the Code - DEV website.
- [ ] Run the command `./build.ps1 --publish` to publish the modules to supporting distribution sites.

# 4.0 License

<img style="width: 250px;" src="website-nav/logos/logo-593x100.png" />

MIT License

© 2023 Mark Shaffer. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
