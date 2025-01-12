# libsndfile

A C-style wrapper of libsndfile for Nim.

The original names are retained for the easy transition between C code and Nim code except for the following names because of my skill issue:

+ `SNDFILE*` in C is `PSNDFILE` in this library;
+ `sf_count_t` in C is `SFCountT` in this library.
+ `SF_CHUNK_ITERATOR*` in C is `P_SF_CHUNK_ITERATOR` in this library.

In the original header, C enums are used as fields value, fields mask and normal enums at the same time at different part of the code. For this reasons some values are defined as enums and some values are simply defined as a `distinct cint`. Please refer to the source file for details.

Only the functions and types used in the source files in the `examples` folder have been personally tested. Proceed at your own risk.

## Linking

+ Dynamic linking: The default. e.g. `nim c listformats.nim`
+ Static linking: Use the `SDNFILE_STATIC` flag. e.g. `nim c -d:SNDFILE_STATIC --clib:sndfile listFormats.nim`

## License

MIT



