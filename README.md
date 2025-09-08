# Swift Issue Reporting

A minimal Swift package that exposes a single `reportIssue` function. Calling this
function emits a purple runtime warning in Xcode so you can surface problems
without stopping program execution.

```swift
import IssueReporting

if items.isEmpty {
  reportIssue("items should not be empty")
}
```

The warning appears in Xcode's runtime issues navigator and in the console.
On platforms where the special logging APIs are not available the message is
printed to standard error instead.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
