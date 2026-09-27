# sf-delta-test

A small SFDX project used to exercise Codity's Salesforce metadata and Flow
security phases against a real pull request.

The point of the baseline on `main` is that it is **deliberately unremarkable**:
modest permissions, `Private` org-wide defaults, a flow that scopes its query.
A scan of `main` should therefore be quiet. What the pull requests here change
is one thing at a time, so it is obvious from the comment whether the delta
logic reported exactly that and nothing else.
