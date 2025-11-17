# Metal GPU PoC

This repository contains a rudimentary spell checker CLI PoC based on Levenshtein distance. It does not just perform spell checking, it also benchmarks CPU vs GPU. 

If you enter word Sesquipvsalianism into the CLI you will get output that will look something like this:

```
CPU: For word Sesquipvsalianism, found sesquipedalianism, time taken 1.40499 seconds
GPU: For word Sesquipvsalianism, found sesquipedalianism, time taken 0.13917 seconds
GPU vs CPU: GPU is 10.10x faster
```
To make it run, open it in Xcode modify args[0] and args[1] by navigation Product>Scheme>Edit Scheme
<img width="950" height="512" alt="Screenshot 2025-11-17 at 21 11 22" src="https://github.com/user-attachments/assets/cef7c19a-3cd1-42ae-bf0c-7304f521aea0" />

args[0] provides location to the dictionary and args[1] to what word you would like to spell check. 

See full write up here: 
https://medium.com/@zankavtaskin/levenshtein-spell-checking-using-metal-apple-m-chip-gpu-15bd29ace9e2 
