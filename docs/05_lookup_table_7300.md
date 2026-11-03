[README](../README.md) · [Section index](index.md)

## 5. The lookup table at ROM `$02B300–$02B3FF` (international) / bank $0A `$7300` (JP, byte-identical)

**Confirmed exactly**: `table[i] == popcount(i)` (Hamming weight / number of set bits), verified
by direct comparison for all 256 input values — not a fit, an exact match.

How it's used: the auto-exposure metering routine (`Cam_PopcountSampleLoop`, bank $0A `$4FBD`)
walks the *thresholded* 1-bit sensor output in the `$A000` capture window 8 pixels (1 byte) at a
time and looks each byte up in this table to get "how many of these 8 pixels are above/below the
comparator threshold" in one memory read instead of a bit-counting loop. The running total feeds
the coarse-then-fine auto-exposure adjustment. By emulating the sample-address sequence directly (script
below), the routine's row coverage is **y = 24 to 103** of the 128-row buffer (entry `Call_00a_4000`,
`DE = $A320` initially: 168 samples, x 16-112, y 24-103) — it stays well clear of the bottom of the
frame (see §9 on masked lines).

So: it's not a brightness/contrast curve, it's a **fast bit-population counter** — "brightness" is
the *result* of summing these counts across the sampled window, not anything encoded in the
table itself.

**Table filled with `00`, tested in BGB (2026-10-13, C for the numbers, I for what it would look like).** With `0A:7300-73FF` set to zero, `Cam_PopcountSampleLoop` returns Σ = 0 on every one of the 239 dispatches of a live-view run, so `L = 0`, the correction shift is 2 and the exposure loses a quarter per frame from `$1000` (65.5 ms) down to the `$0010` floor (0.256 ms, band 0, reg 1 `$23`), where it stays for the last 219 of 241 captures; the unpatched ROM ends at `$0CDD` (51 ms, reg 1 `$E3`) with L between 0 and 35. So the camera "cannot adjust the exposure" in the sense that it believes every picture is saturated and shortens the exposure to the minimum. BGB's sensor is a fixed fake picture, so the result is the exposure the code asks for, not an image (`assets/sensor/zero_popcount_test.txt`).

---
