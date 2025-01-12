import std/[math, cmdline, strformat]
import std/[syncio]
import libsndfile

const BLOCK_SIZE = 4096

proc print_usage(prog_name: cstring): void =
  stdout.writeLine(&"Usage: {prog_name} <input file> <output file>")
  stdout.writeLine("""
Where the output file will contain a line for each frame
and a column for each channel.
""")

proc convert_to_text(infile: PSNDFILE, outfile: File, channels: cint): cint =
  var buf: pointer
  var frames: SFCountT
  var readcount: SFCountT

  buf = alloc0(BLOCK_SIZE * sizeof cfloat)
  if buf == nil:
    stdout.writeLine("Error : Out of memory")
    return 1.cint
  defer: buf.dealloc

  frames = BLOCK_SIZE div channels

  while true:
    readcount = sf_readf_float(infile, cast[ptr cfloat](buf), frames)
    if readcount <= 0: break
    for k in 0..<readcount:
      for m in 0..<channels:
        let d = cast[ptr UncheckedArray[cfloat]](buf)[k * channels + m]
        outfile.writeLine(&"{d}")

  return 0

proc main(): int =
  var progname: cstring
  var infilename: cstring
  var outfilename: string
  var infile: PSNDFILE
  var outfile: File
  var sfinfo: SF_INFO
  var ret: int = 1

  progname = paramStr(0).cstring
  if paramCount() != 2:
    print_usage(progname)
    return 0

  infilename = paramStr(1).cstring
  outfilename = paramStr(2)
  if infilename == outfilename:
    stdout.writeLine("Error : Input and output filenames are the same.")
    print_usage(progname)
    return 0

  sfinfo = SF_INFO(frames: 0, samplerate: 0, channels: 0, format: 0, sections: 0, seekable: 0)
  infile = sf_open(infilename, SFM_READ, sfinfo.addr)
  if infile == nil:
    stdout.writeLine(&"Not ableto open input file {infilename}")
    stdout.writeLine(sf_strerror(nil.PSNDFILE))
    return 0
  defer: discard sf_close(infile)

  if not outfile.open(outfilename, fmWrite):
    stdout.writeLine(&"Not able to open output file {outfilename}")
    discard sf_close(infile)
    return 0
  defer: outfile.close()

  outfile.writeLine(&"# Converted from file {infilename}")
  outfile.writeLine(&"# Channels {sfinfo.channels}, Sample rate {sfinfo.samplerate}")

  ret = convert_to_text(infile, outfile, sfinfo.channels)
  return ret
  
when isMainModule:
  let res = main()
  if res > 0: quit(res)
  
