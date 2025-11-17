# Metal GPU PoC

This repository contains a rudimentary spell checker CLI PoC based on Levenshtein distance. It does not just perform spell checking, it also benchmarks CPU vs GPU. 

If you enter word Sesquipvsalianism into the CLI you will get output that will look something like this:

```
CPU: For word Sesquipvsalianism, found sesquipedalianism, time taken 1.40499 seconds
GPU: For word Sesquipvsalianism, found sesquipedalianism, time taken 0.13917 seconds
GPU vs CPU: GPU is 10.10x faster
```

See full write up here: 
https://medium.com/@zankavtaskin/levenshtein-spell-checking-using-metal-apple-m-chip-gpu-15bd29ace9e2 
