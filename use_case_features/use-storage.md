<h1><img style="height: 30px;" src="../website-nav/icons/icons8-design-48.png" /> Use Link Opener</h1>

**Table of Contents**

- [User Story](#user-story)
- [Design Notes](#design-notes)
- [License](#license)

# User Story

**`WHO:`** As a software developer

**`WHAT:`** I want the ability to manage dictionary data

**`WHY:`** So that my app has quick access to key / value pairs of information between restart of the application.  In addition, upon startup, the system environment of variables should also be loaded as part of the dictionary.

**`ACCEPTANCE CRITERIA:`**

1. When a copy of the system environment is loaded for query or runtime update.  NOTE: this will only be in effect during the runtime.
2. When a string key / value pair can be set to the storage indicating its success and failure.
3. When a string value can be can be retrieved with a key from local storage.  null is returned if not found.
4. When the storage can remove a key entry indicating success or failure
5. When the storage can clear the entire storage indicating success or failure.

# Design Notes

- This is a `flutter` module feature as it relies on WidgetBindings.  The `flutter` module will not load a system environment upon startup of the web target.

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
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.- [User Story](#user-story)
- [User Story](#user-story)
- [Design Notes](#design-notes)
- [License](#license)
