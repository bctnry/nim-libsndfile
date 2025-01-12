# static linking: nim c -d:SNDFILE_STATIC --clib:sndfile listFormats.nim
# dynamic linking: nim c listformats.nim
import libsndfile
import std/math

const M_PI = 3.14159265358979323846264338
const SAMPLE_RATE = 44100
const SAMPLE_COUNT = (SAMPLE_RATE * 4)
const AMPLITUDE = (1.0 * 0x7F000000)
const LEFT_FREQ = (344.0 / SAMPLE_RATE)
const RIGHT_FREQ = (466.0 / SAMPLE_RATE)

proc main(): void =
  var file: PSNDFILE
  var sfinfo: SF_INFO
  var k: int
  var buffer: pointer

  buffer = alloc0(2 * SAMPLE_COUNT * sizeof(cint))

  sfinfo = SF_INFO(frames: 0, samplerate: 0, channels: 0, format: 0, sections: 0, seekable: 0)
  sfinfo.samplerate = SAMPLE_RATE
  sfinfo.frames = SAMPLE_COUNT
  sfinfo.channels = 2
  sfinfo.format = SF_FORMAT_WAV.int or SF_FORMAT_PCM_24.int

  file = sf_open("sine.wav", SFM_WRITE, sfinfo.addr)
  if file.pointer == nil:
    echo "Error: Not able to open output file.\n"
    quit(1)

  var bvar = cast[ptr UncheckedArray[cint]](buffer)
  if sfinfo.channels == 1:
    for k in 0..<SAMPLE_COUNT:
      bvar[k] = (AMPLITUDE * sin(LEFT_FREQ * 2 * k.float * M_PI)).cint
  elif sfinfo.channels == 2:
    for k in 0..<SAMPLE_COUNT:
      bvar[2*k] = (AMPLITUDE * sin(LEFT_FREQ * 2 * k.float * M_PI)).cint
      bvar[2*k+1] = (AMPLITUDE * sin(RIGHT_FREQ * 2 * k.float * M_PI)).cint
  else:
    echo "Error: make_sine can only generate mono or stereo files."
    discard sf_close(file)
    quit(1)

  if sf_write_int(file, cast[ptr cint](buffer), sfinfo.channels*SAMPLE_COUNT) != sfinfo.channels*SAMPLE_COUNT:
    echo sf_strerror(file)
  discard sf_close(file)
  dealloc(buffer)

when isMainModule:
  main()
    
