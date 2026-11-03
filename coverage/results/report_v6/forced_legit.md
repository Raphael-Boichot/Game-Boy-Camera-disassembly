# Credibility of forced-state coverage

Instructions executed only in forced-state runs: **8073**. Reachable along static control flow from organic code or entered at a dispatch-table / root entry: **8021**. Suspect (entered by an edge that is not in the static CFG): **52** instructions in 6 runs.

| first | last | instrs | contains a DEAD-CODE root |
|---|---|---:|---|
| 00:06CA | 00:06F4 | 38 |  |
| 00:0751 | 00:0755 | 3 | yes |
| 00:0771 | 00:0772 | 2 |  |
| 09:6BDB | 09:6BE0 | 3 |  |
| 0A:5900 | 0A:590B | 5 |  |
| 0A:5AB7 | 0A:5AB7 | 1 |  |
