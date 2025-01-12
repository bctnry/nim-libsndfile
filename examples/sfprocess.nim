import std/[math, cmdline, strformat]
import std/[syncio]
import libsndfile

const BUFFER_LEN = 1024
const MAX_CHANNELS = 6

proc process_data(data: ptr cdouble, count: cint, channels: cint)

var data: ptr cdouble
proc main*(): int =  
  var infile: PSNDFILE
  var outfile: PSNDFILE
  var sfinfo: SF_INFO
  var readcount: cint

  const infilename: cstring = "input.wav"
  const outfilename: cstring = "output.wav"
  
  sfinfo = SF_INFO(frames: 0, samplerate: 0, channels: 0, format: 0, sections: 0, seekable: 0)

  infile = sf_open(infilename, SFM_READ, sfinfo.addr)
  if infile == nil.pointer:
    writeLine(stdout, &"Error : could not open file : {infilename}")
    writeLine(stdout, sf_strerror(nil.PSNDFILE))
    return 1

  if sfinfo.channels > MAX_CHANNELS:
     writeLine(stdout, &"Not able to process more than {MAX_CHANNELS} channels")
     discard sf_close(infile)
     return 1

  outfile = sf_open(outfilename, SFM_WRITE, sfinfo.addr)
  if outfile == nil.pointer:
    writeLine(stdout, &"Not able to open output file {outfilename}")
    writeLine(stdout, sf_strerror(nil.PSNDFILE))
    return 1

  while true:
    readcount = sf_read_double(infile, data, BUFFER_LEN).cint
    if readcount <= 0: break
    process_data(data, readcount, sfinfo.channels)
    discard sf_write_double(outfile, data, readcount)

  discard sf_close(infile)
  discard sf_close(outfile)

  return 0

proc process_data(data: ptr cdouble, count: cint, channels: cint): void =
  var channel_gain: array[6, cdouble] = [ 0.5, 0.8, 0.1, 0.4, 0.4, 0.9 ];
  var k: cint
  for chan in 0..<channels:
    k = chan
    while k < count:
      cast[ptr UncheckedArray[cdouble]](data)[k] *= channel_gain[chan]
      k += channels

when isMainModule:
  data = cast[ptr cdouble](alloc0(BUFFER_LEN * sizeof cdouble))
  let res = main()
  dealloc(data)
  if res > 0: quit(res)
  
