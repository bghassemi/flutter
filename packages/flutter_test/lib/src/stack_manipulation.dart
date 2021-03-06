// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// See also test_async_utils.dart which has some stack manipulation code.

/// Report call site for `expect()` call. Returns the number of frames that
/// should be elided if a stack were to be modified to hide the expect call, or
/// zero if no such call was found.
///
/// If the head of the stack trace consists of a failure as a result of calling
/// the test_widgets [expect] function, this will fill the given StringBuffer
/// with the precise file and line number that called that function.
int reportExpectCall(StackTrace stack, StringBuffer information) {
  final RegExp line0 = new RegExp(r'^#0 +fail \(.+\)$');
  final RegExp line1 = new RegExp(r'^#1 +expect \(.+\)$');
  final RegExp line2 = new RegExp(r'^#2 +expect \(.+\)$');
  final RegExp line3 = new RegExp(r'^#3 +[^(]+ \((.+?):([0-9]+)(?::[0-9]+)?\)$');
  final List<String> stackLines = stack.toString().split('\n');
  if (line0.firstMatch(stackLines[0]) != null &&
      line1.firstMatch(stackLines[1]) != null &&
      line2.firstMatch(stackLines[2]) != null) {
    Match expectMatch = line3.firstMatch(stackLines[3]);
    assert(expectMatch != null);
    assert(expectMatch.groupCount == 2);
    information.writeln('This was caught by the test expectation on the following line:');
    information.writeln('  ${expectMatch.group(1)} line ${expectMatch.group(2)}');
    return 3;
  }
  return 0;
}