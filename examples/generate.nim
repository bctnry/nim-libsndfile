import std/[math, cmdline, strformat]
import std/[syncio]
import libsndfile

const BUFFER_LEN* = 4096

proc encode_file*(infilename: cstring; outfilename: cstring; filetype: SFFormat)
proc main*(): void =
  if paramCount() != 1:
    echo "\nEncode a single input file into a number of different output "
    echo "encodings. These output encodings can then be moved to another "
    echo "OS for testing."
    echo "    Usage : generate <filename>"
    quit(1)

  ##  A couple of standard WAV files. Make sure Win32 plays these.
  echo SF_FORMAT_WAV.cint, " ", SF_FORMAT_PCM_U8.cint, " ", ((SF_FORMAT_WAV.cint) or (SF_FORMAT_PCM_U8.cint)), " ", $(SF_FORMAT_WAV or SF_FORMAT_PCM_U8), " ", $((SF_FORMAT_WAV or SF_FORMAT_PCM_U8).cint)
  encode_file(paramStr(1), "pcmu8.wav", SF_FORMAT_WAV or SF_FORMAT_PCM_U8)
  encode_file(paramStr(1), "pcm16.wav", SF_FORMAT_WAV or SF_FORMAT_PCM_16)
  encode_file(paramStr(1), "imaadpcm.wav", SF_FORMAT_WAV or SF_FORMAT_MS_ADPCM)
  encode_file(paramStr(1), "msadpcm.wav", SF_FORMAT_WAV or SF_FORMAT_IMA_ADPCM)
  encode_file(paramStr(1), "gsm610.wav", SF_FORMAT_WAV or SF_FORMAT_GSM610)
  ##  Soundforge W64.
  encode_file(paramStr(1), "pcmu8.w64", SF_FORMAT_W64 or SF_FORMAT_PCM_U8)
  encode_file(paramStr(1), "pcm16.w64", SF_FORMAT_W64 or SF_FORMAT_PCM_16)
  encode_file(paramStr(1), "imaadpcm.w64", SF_FORMAT_W64 or SF_FORMAT_MS_ADPCM)
  encode_file(paramStr(1), "msadpcm.w64", SF_FORMAT_W64 or SF_FORMAT_IMA_ADPCM)
  encode_file(paramStr(1), "gsm610.w64", SF_FORMAT_W64 or SF_FORMAT_GSM610)
  return

# In the original example in C, this is a static var (which retains its
# value throughout multiple calls of the same function). AFAIK Nim does
# not have an equivalent construct, so this is defined here.
# Another thing about Nim is that it's not good practice to treat any
# array (e.g. this Uncheckedarray[cfloat]) in Nim directly as e.g.
# ptr cfloat, so a different manoeuvre needs to be done. see below.
var buffer: ptr cfloat
proc encode_file*(infilename: cstring; outfilename: cstring; filetype: SFFormat) =
  var infile: PSNDFILE
  var outfile: PSNDFILE
  var sfinfo: SF_INFO
  var k: cint
  var readcount: cint

  write(stdout, &"    {infilename} -> {outfilename} ")
  flushFile(stdout)

  k = (16 - outfilename.len).cint
  for _ in 0..<k: write(stdout, '.')
  write(stdout, ' ')

  sfinfo = SF_INFO(frames: 0, samplerate: 0, channels: 0, format: 0, sections: 0, seekable: 0)

  infile = sf_open(infilename, SFM_READ, sfinfo.addr)
  if infile == nil.pointer:
    writeLine(stdout, &"Error : could not open file : {infilename}")
    writeLine(stdout, sf_strerror(nil.PSNDFILE))
    quit(1)

  sfinfo.format = filetype.cint

  if sf_format_check(sfinfo.addr) == 0:
    discard sf_close(infile)
    writeLine(stdout, "Invalid encoding")
    return

  outfile = sf_open(outfilename, SFM_WRITE, sfinfo.addr)
  if outfile == nil.pointer:
    writeLine(stdout, &"Error : could not open file : {outfilename}")
    writeLine(stdout, sf_strerror(nil.PSNDFILE))
    quit(1)

  while true:
    readcount = sf_read_float(infile, buffer, BUFFER_LEN).cint
    if readcount <= 0: break
    discard sf_write_float(outfile, buffer, readcount)

  discard sf_close(infile)
  discard sf_close(outfile)

  writeLine(stdout, "ok")

when isMainModule:
  buffer = cast[ptr cfloat](alloc0(BUFFER_LEN * sizeof cfloat))
  main()
  dealloc(buffer)
  
