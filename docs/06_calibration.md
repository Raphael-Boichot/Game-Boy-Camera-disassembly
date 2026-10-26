[README](../README.md) · [Section index](index.md)

## 6. Calibration procedure (the `$04FF2`/`$11FF2` question)

> **For an overview** of the whole mechanism (what the vector holds, how the boot and the live view use it, why it exists) read §19 first; this section is the SRAM side in detail.

> **Note (SRAM rewrite, see §3.3 and §11.3)**: `$04FF2` and `$11FF2` are not a separate reserved "calibration area" — they are the
> unused tail bytes of photo slots 3 and 16. The complete record is `1B 13` + the 12-byte vector + the 2 checksum bytes at
> `$04FF0-$04FFF`, echoed (without `1B 13`) at `$11FF2-$11FFF`. `1B 13` (27 and 19) are factory-test tolerances that only the hidden
> factory test reads (§3.3). Everything below about the checksum algorithm, validation logic and repair paths is unaffected.

Fully traced, bank $0A, JP addresses (labels are in the shipped `.sym`):

**`Cam_Calib_ValidityCheck` → `Call_00a_460f`** computes a checksum over the 12-byte vector at
SRAM flat `$04FF2-$04FFD`:
```
b = sum(bytes) ; c = xor(bytes)      (12 bytes)
b += $0D ; c += $23                   (fixed seed constants)
valid = (b == byte[12]) and (c == byte[13])     ; i.e. bytes $04FFE/$04FFF
```
Result flag → `$ff8a`. Then **`Cam_Calib_EchoCompare`** does the *identical* computation on the
echo copy at `$11FF2-$11FFD` (checksum at `$11FFE/$11FFF`), result → `$ff8d`.

Decision logic (re-read from the code, `0a:$45C9-$46B6`; `$FF8A` = primary valid, `$FF8B/$FF8C` and `$FF8D/$FF8E` = the stored checksum bytes of primary and echo):

| Primary | Echo | What the code does | Result in `A` |
|---|---|---|---|
| valid | valid, same checksum bytes | loads the primary into WRAM `$D5B5`; **no write** | `0` |
| valid | invalid | `Cam_Calib_RepairPaths`: loads the primary, writes it **and its checksum bytes** to the echo (`$BFF2`, RAM bank 8) | `0` |
| invalid | valid | `jr_00a_46b7`: loads the echo, writes it to the primary (`$AFF2`, RAM bank 2) | `0` |
| valid | valid, checksum bytes **differ** (so the data differ) | **no repair**: falls to the default-vector path | `$FF` |
| invalid | invalid | **no repair**: falls to the default-vector path | `$FF` |

(The only caller of `Cam_Calib_RepairPaths` is the "primary valid, echo invalid" branch at `$467D`; "both invalid" and "both valid but different" do not trigger it. This differs from the primary-wins rule of the settings/tag blocks, §3.5: the calibration pair is never "resolved" when the two copies disagree.)

When `A != 0` (`Cam_Calib_ValidityCheck`'s first branch), the code writes a **fixed default vector** `7E 7F 7F 7F 7E 7D 7E 7E 7D 7E 7D 6A` directly into `$D5B5-$D5C0` (the WRAM working copy) before calling the loader. It is a hard-coded fallback, computed from nothing, and **it is never written back to SRAM**: the `00`-filled calibration record of the battery-loss save `2021-05-19_2` (two boots after the battery change, §3.8) is still `00` today, which is exactly what this path predicts. These 12 bytes are what a "pretend nothing was ever calibrated" SRAM produces.

### The write-back side — now fully traced

`Call_00a_46cf` / `Call_00a_46e1` are a generic pair, not calibration-specific:

```
Call_00a_46cf (LOAD 12+2 bytes FROM [hl] INTO WRAM):
    de = $d5b5 ; repeat 12×: [de++] = [hl++]        ; the 12 data bytes
    $ff8b = [hl++] ; $ff8c = [hl++]                  ; the 2 checksum bytes

Call_00a_46e1 (STORE WRAM back TO [hl], SRAM-write-enabled):
    [$0000] = $0A                                    ; enable SRAM writes (the MBC "RAM enable" register)
    de = $d5b5 ; repeat 12×: [hl++] = [de++]
    [hl++] = $ff8b ; [hl] = $ff8c                     ; re-use the SAME checksum bytes, not recomputed
    [$0000] = $00                                     ; disable SRAM writes again
```

`Cam_Calib_RepairPaths` = "primary good → overwrite echo": select bank 2, `Call_00a_46cf` from
`$AFF2` (loads primary into WRAM); select bank 8, `Call_00a_46e1` to `$BFF2` (writes WRAM to echo).
The mirror-image routine (`jr_00a_46b7`, "echo good → overwrite primary") does the same thing with
the two banks swapped. Either way the **surviving copy's checksum bytes get copied verbatim**,
which is correct — the checksum only depends on the 12 data bytes, and those didn't change.

### The self-test/re-measure gate

`Cam_Calib_Loader` (`0A:46FD-4723`), called after validation/repair succeeds, tests the 12 bytes of the **primary** copy (bank 2, `$AFF2-$AFFD`) against `$AA`: if any byte differs it jumps at once to `Cam_Calib_BootMeasureSeq` (`0A:4724`); only if the primary is blank is the echo (bank 8, `$BFF2`) tested, and only if **both** copies are twelve `$AA` does the loader return `A = $FF`. The caller (`Cam_BootSelfTest_Entry`, `0A:6A52`) then goes to `0A:6B73`: **STORE PLEASE WAIT** and the first-time factory calibration (`Cam_FullCalibration`, `0A:4947`: 12 offset searches and 12 threshold scans, then the commit of the 12-byte vector to both SRAM copies, §18.5), after which the camera stays on that screen (`jr` loop at `0A:6BDB`) until the power is cycled. In every other case (a valid record, a record repaired from its echo, an invalid record replaced by the default vector in WRAM only) the boot **re-measures**: gain probe and five offset searches against the stored reference bytes (§18.4). Checked in BGB: both copies `$AA` → STORE PLEASE WAIT and 537 captures, an SRAM of `$FF` bytes → 111 captures, i.e. the normal boot (C).


So twelve `$AA` in both copies is the "this camera has never been calibrated" sentinel (`$AA` is also the general "blank slot" marker elsewhere in SRAM). Every other cold boot re-trims the sensor **offsets** against the stored reference bytes: the reference levels themselves change only when the vector is rewritten by a calibration. So the camera adapts its offsets at every start but is not re-calibrated at every start (the 5 offset searches and the gain probe are what the bus recording of a normal boot shows, §18.4).

### The calibration vector — complete byte-by-byte mapping

Traced by reading all three branches of `Cam_ExposureBandSelect` (previously I'd only read the
`gain=0` branch). The coarse gain search tries REG1 = 0, 1, 2 in sequence (stopping at the first
that produces a usable test capture); whichever wins picks **three** bytes out of the vector as
the reference bytes of the first three boot offset searches (`$d5cb`,`$d5cc`,`$d5cd`, §18.4):

| Winning gain | `$d5cb` ← | `$d5cc` ← | `$d5cd` ← |
|---|---|---|---|
| 0 | `$d5b5` (byte 0) | `$d5b9` (byte 4) | `$d5bd` (byte 8) |
| 1 | `$d5b6` (byte 1) | `$d5ba` (byte 5) | `$d5bd` (byte 8) |
| 2 | `$d5b7` (byte 2) | `$d5bb` (byte 6) | `$d5be` (byte 9) |
| (fallback/"3") | `$d5b8` (byte 3) | `$d5bc` (byte 7) | `$d5be` (byte 9) |

So the 12-byte vector is really a **3×4 grid** (one row of 4 per "target slot", read down columns
by gain index), with gains 0↔1 sharing their third-slot target and gains 2↔3 sharing theirs:

```
       gain=0   gain=1   gain=2   gain=3(fallback)
slot A: $04FF2   $04FF3   $04FF4   $04FF5      <- $d5cb, "primary" target
slot B: $04FF6   $04FF7   $04FF8   $04FF9      <- $d5cc, "secondary" target
slot C: $04FFA (shared 0&1)   $04FFB (shared 2&3)    <- $d5cd, "tertiary" target
```

These three chosen bytes (`$d5cb/cc/cd`) are **not** targets of the auto-exposure loop (the live loop never reads the vector, §10 and §18.6). They are the **flat matrix bytes of boot offset searches 1-3**: `Cam_Calib_BootMeasureSeq` fills the sensor matrix `$A006-$A035` with `$D5CB`, `$D5CC`, `$D5CD`, then `$D5BF` and `$D5C0`, and for each runs the offset search `0A:4B6A`, which finds the sensor offset O (register 0) at which the pixel test flips at that level; the five (V, O) pairs go to `$D5C1-$D5CA` and become the registers of the five live bands (§18.4). So **none of the 12 bytes is a register value**: each is (I) the **black-level reference of one sensor mode**, measured at the factory with the threshold scan `Cam_ThresholdConverge` at the offset found for that mode. The slot map (§18.5): slots 0-3 = horizontal-edge mode, E = 0, gain index 0-3; slots 4-10 = horizontal-edge mode, E = 2, gain index 0, 1, 2, 3, 4, 5, 8; slot 11 = positive image, gain index 10. For a winning gain g the table above picks slot g, slot 4+g and slot 8 (g = 0, 1) or 9 (g = 2, 3), which are the slots measured in the very mode (reg 1, reg 7) that boot searches 1-3 run in.

`$04FFC`/`$04FFD` ("GAINA" on the factory screen, `$d5bf`/`$d5c0` = slots 10 and 11, gain index 8 and 10) are consumed twice: by the hidden factory test (`0a:$455A-$45C8`), which re-measures them and compares them with `$AFFC`/`$AFFD`, accepting a difference up to `$AFF0` (= `$1B`) and `$AFF1` (= `$13`) respectively (§3.3; `$FF91` = 0 → "OK"), and as the matrix bytes of boot searches 4 and 5.

The factory step has **twelve** points, not eight (§18.5): `Cam_FullCalibration` (`0a:4947`, formerly `Call_00a_4947`) runs `Cam_FactoryMeasure1` (12 offset searches at reg 1 = `$20 $21 $22 $23`, `$E0 $E1 $E2 $E3`, `$E4`, `$E5`, `$E8`, `$0A`, exposure `$0030 / $0900 / $2000 / $3200 / $8000`, flat matrix `$80`; V goes to `$d59d-$d5a8`, O to `$d5a9-$d5b4`), then `Cam_FactoryMeasure2` (12 threshold scans at C = `$0010`; **their 12 results are the 12 bytes of the vector**: that is how the sweep becomes the vector), then `Cam_CommitVectorToSRAM` (`0a:$4F58`), which copies the 12 bytes at WRAM `$D5B5` to `$AFF2` (RAM bank 2, slot 3) and `$BFF2` (RAM bank 8, slot 16), each followed by `Σ+$0D` and `XOR+$23` (§3.3). A bus-analyser recording of this routine on a real unit (172 register loads) is decoded in §18.5.

### Where exactly is the checksum — unambiguous diagram

```
SRAM flat address:  04FF2 04FF3 04FF4 04FF5 04FF6 04FF7 04FF8 04FF9 04FFA 04FFB 04FFC 04FFD | 04FFE 04FFF
                    └──────────────────────── 12 data bytes ─────────────────────────────┘   └ checksum ┘
                                                                                                 (sum+13, xor+35)

SRAM flat address:  11FF2 ................................................................ 11FFD | 11FFE 11FFF
                    └──────────────────────── echo of the same 12 bytes ─────────────────┘   └ checksum ┘
```
Checksum algorithm (identical for both copies):
```
sum = 0 ; xor = 0
for each of the 12 data bytes b:
    sum = (sum + b) & 0xFF
    xor = (xor ^ b) & 0xFF
expected_byte1 = (sum + 0x0D) & 0xFF      # compared against 04FFE / 11FFE
expected_byte2 = (xor + 0x23) & 0xFF      # compared against 04FFF / 11FFF
```
This is a different, simpler algorithm than the image-tag checksum documented in the
Inject-pictures README — two independent checksum schemes coexist in this SRAM, one for photo
slots and this one specifically for the calibration vector.

---
