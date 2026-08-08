# Task 1 report: versioned graph record schema and validator

## Result

Implemented the `design-arc.graph/v1` project-local graph-record boundary.
The dependency-free CLI validates JSON records without mutating or repairing
them, and exits zero only for a usable record whose project and review identity
match the caller's expectations.

Implementation commit: `71c3633` (`feat: validate Design Arc graph records`)

## RED evidence

Command:

```sh
python3 scripts/test-graph-records.py
```

Output before the schema and validator existed:

```text
FAIL: graph-record validator is absent; expected RED state
```

The test exercised the intended public CLI path and failed specifically because
the production validator was absent.

## GREEN evidence

Focused graph-record command:

```sh
python3 scripts/test-graph-records.py
```

Output:

```text
PASS: accepted valid fixture valid.json
PASS: rejected corrupt.json (invalid JSON)
PASS: rejected incomplete-required-fields.json (missing required field: observed_at)
PASS: rejected unsupported-schema.json (unsupported schema)
PASS: rejected unsupported-node-type.json (unsupported node type)
PASS: rejected unsupported-edge-type.json (unsupported edge type)
PASS: rejected unsupported-provenance.json (unsupported provenance kind)
PASS: rejected duplicate-ids.json (duplicate node id)
PASS: rejected missing-endpoint.json (missing endpoint)
PASS: rejected unproven-relationship.json (unproven relationship)
PASS: rejected contradictory-active-relationships.json (contradictory active relationships)
PASS: rejected wrong project identity
PASS: rejected wrong review identity
```

Repository harness commands:

```sh
sh scripts/test-test-validate.sh
sh scripts/test-validate.sh
sh scripts/validate.sh
git diff --check
```

All exited zero. The full repository validator reported the graph suite's 13
PASS checks, then completed the existing identity, documentation, workflow,
safety, syntax, isolated-install, migration, and upgrade checks. The
`test-test-validate.sh` regression harness also deliberately replaces the graph
test in a temporary checkout and proves `validate.sh` fails closed with:

```text
FAIL: graph-record test failed
```

## Files changed

- `plugins/design-arc/skills/design-arc/references/graph-record.schema.json`:
  versioned JSON Schema for the record, node, edge, provenance, support, and
  active-relationship fields.
- `scripts/validate-graph-record.py`: dependency-free public CLI validator.
- `scripts/test-graph-records.py`: public-CLI integration suite.
- `scripts/fixtures/graph-records/`: one valid all-types record and focused
  invalid records.
- `scripts/validate.sh`: requires and runs the graph validation assets, checks
  their Python syntax, and fails closed if the graph suite fails.
- `scripts/test-validate.sh` and `scripts/test-test-validate.sh`: include the
  graph suite in normal validation and pressure-test its fail-closed behavior.

## Self-review

- The valid literal fixture covers all 13 supported node types, all 9 supported
  edge types, and all 4 supported provenance kinds.
- The validator rejects malformed input rather than normalizing it; it checks
  required and unexpected fields, identity, unique IDs, endpoint existence,
  timestamps, supported vocabulary, evidence support, and same-direction active
  conflict pairs.
- No third-party package was introduced. `source_ref` intentionally accepts any
  non-empty string, so URI, user-confirmation, Stitch, and Design Arc internal
  references remain valid provenance sources.
- The validation harness's negative test mutates only an isolated temporary
  checkout and preserves the current repository.

## Concerns

None. The schema and CLI deliberately share the same versioned vocabulary;
semantic constraints that JSON Schema alone cannot express (such as endpoint
existence and contradictory active relationships) are enforced by the CLI.
