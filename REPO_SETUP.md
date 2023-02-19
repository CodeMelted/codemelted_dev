# Melt the Code - DEV (Repo Setup)

The following documents how to setup this repo after cloning it.  It then goes into details about the overall repo structure and how to maintain it.

**Table of Contents**

- [Melt the Code - DEV (Repo Setup)](#melt-the-code---dev-repo-setup)
  - [Getting Started](#getting-started)
    - [Installations](#installations)
      - [Tools](#tools)
    - [VS Code](#vs-code)
    - [Test Setup](#test-setup)
  - [Design Notes](#design-notes)
    - [Source Structure](#source-structure)
    - [UI Mockup](#ui-mockup)
    - [build.ps1 Execution](#buildps1-execution)

## Getting Started

The following sets up all the tools necessary to be able to run and make code changes to this repo.

- *NOTE: This repo thus far has been built and maintained on Mac OS.  In the future, Window and Linux will be added and tested.*

### Installations

#### Tools

- *NOTE: If installing on Mac OS, you may want to consider [Homebrew](https://brew.sh) to install some of the items below as they may not work as advertised on their websites.*

- [ ] [Git](https://git-scm.com/)
  - [ ] [GitHub Desktop](https://desktop.github.com/) (not required just nice to have)
- [ ] [C++](https://code.visualstudio.com/docs/languages/cpp)
  - [ ] [doxygen](https://www.doxygen.nl)
- [ ] [deno](https://deno.land/)
  - [ ] [nodejs](https://nodejs.org/en/)
  - [ ] [typescript](https://www.npmjs.com/package/typescript) (install globally)
  - [ ] [typedoc](https://typedoc.org/guides/installation/) (install globally)
- [ ] [flutter](https://flutter.dev/)
  - [ ] [dartdoc](https://pub.dev/packages/dartdoc)
- [ ] [pwsh](https://github.com/PowerShell/PowerShell#get-powershell)
  - [ ] [Pester](https://www.powershellgallery.com/packages/Pester/5.1.1)
- [ ] [Python3](https://www.python.org/)

### VS Code

- [ ] [VS Code](https://code.visualstudio.com/)
- [ ] [C/C++ Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack)
- [ ] [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [ ] [Deno](https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno)
- [ ] [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [ ] [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [ ] [PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)

### Test Setup

The following procedure represent the steps to confirm your setup of the previous section tooling worked and would also be used for any validation of changes made to this repo.

- [ ] Open a terminal to the repo
- [ ] Execute the command `./build.ps1` in the terminal window.  View the output and confirm no errors in the execution.
- [ ] Execute the command `cd dist` to bring you to the built output
- [ ] Execute the command `python3 -m http.server` to start a web server
- [ ] Open a web browser window and enter the address `http://[::]:8000/`.  You should see the DEV page rendered and all the links should work

## Design Notes

### Source Structure

Path | Description
--- | ---
.firebase | This is the cache that tracks the deployments of this repo to the [Melt the Code - DEV](https://codemelted.dev) web domain
disqus | Represents an embed `disqus` widget to support the main [Melt the Code](https://www.codemelted.com) web domain
jeep-pi | A raspberry pi 4 project for an infotainment system for a jeep wrangler to support taking pictures while driving. Also provides other entertainment items
modules | The core of what this repo is about.  Contains all the source code and tooling for the Melt the Code Cross Platform modules.  This includes the documenting, testing, and deployment of each module type
website-nav | Provides the infrastructure to navigate the [Melt the Code - DEV](https://codemelte.dev) website

### UI Mockup

This repo follows the same design principles as the [codemelted_blog Repo](https://github.com/CodeMelted/codemelted_blog).  The `website-nav` is what implements the overall look and feel of the site.

### build.ps1 Execution

Each major section of this repo contains a `build.ps1` script which is responsible for performing the actions necessary for that particular area.  So for instance, the `modules` section contains each programming language module and will build, document, test, and package a `dist` folder for website deployment.

The main `build.ps1` will run all the different repo `build.ps1` scripts to assemble the [Melt the Code - DEV](https://codemelted.dev) website.  To execute it locally you follow the [Test Setup](#test-setup) section.  Some scripts also contains a `--deploy` option that will publish that particular content to a 3rd party hosting platform (i.e. firebase for the website, pub.dev for flutter, etc.).

