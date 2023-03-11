<h1><img style="height: 30px;" src="../website-nav/icons/icons8-design-48.png" /> Use Link Opener</h1>

**Table of Contents**

- [User Story](#user-story)
- [Design Notes](#design-notes)
- [License](#license)

# User Story

**`WHO:`** As a software developer

**`WHAT:`** I want the ability to open URL links

**`WHY:`** So that the default native application associated with that link is opened separate from my application.

**`ACCEPTANCE CRITERIA:`**

1. When I am able to open a file with its associated native program (i.e. .docx opens in MS word if installed).
2. When I am able to open a website via the native web browser.
3. When I am able to open the default email program and fill in the to, cc, bcc, subject, and body of the message.
4. When I am able to open the default phone application to dial a specified phone number.
5. When I am able to open the default texting application when specifying a number to send an sms message.

# Design Notes

- Flutter module handles this and not dart.  There was also a need to separate the module exceptions to be specific to them.  Could not reuse the `UseCaseFailure` between both modules
- This use case would also apply to web, not sure how this will apply to other modules.
- In researching how to implement this use case in `pwsh` and `C++`, it appears you simply pass the link to a process which would in theory utilize the associated native program.  Something to test for sure.

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