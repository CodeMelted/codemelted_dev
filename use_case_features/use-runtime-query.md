<h1><img style="height: 30px;" src="../website-nav/icons/icons8-design-48.png" /> Use Runtime Query</h1>

**Table of Contents**

- [User Story](#user-story)
- [Design Notes](#design-notes)
- [License](#license)

# User Story

**`WHO:`** As a software developer

**`WHAT:`** I want the ability to query runtime environment parameters

**`WHY:`** So that application behavior can be affected based on those parameters

**`ACCEPTANCE CRITERIA:`**

1. When at a minimum, the following runtime environment parameters can be queried:
   - eol
   - hostname
   - isBrowser
   - isDesktop
   - isMobile
   - numberOfProcessors
   - osName
   - osVersion
   - pathSeparator
2. When in addition, performance metrics can be gathered to monitor the environment.  This includes:
   - cpuUsed
   - memoryUsed
   - totalMemoryAvailable

# Design Notes

- This is a `dart` only implementation.
- `C++` and `pwsh` should be able to implement AC #2.  Will need to research to determine whether `dart` and `web` can do this.
- All languages will be able to implement AC #1.

# License

<img style="width: 250px;" src="../website-nav/logos/logo-593x100.png" />

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