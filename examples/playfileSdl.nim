# NOTE: this is taken from here:
#     https://github.com/julienaubert/nim-sndfile
# with some edits.

## Read an audio file (e.g. WAV or Ogg Vorbis) with libsndfile and play it with sdl2

import std/[math, os, strformat]

import libsndfile
import sdl2, sdl2/audio

if paramCount() != 1:
  echo "Usage: playfile <filename>"
  quit(QuitFailure)

var filename = paramStr(1)

# Print libsndfile version
echo &"libsdnfile version: {sf_version_string()}"

# Print SDL version
var version: SDL_Version
sdl2.getVersion(version)
echo &"SDL version: {version.major}.{version.minor}.{version.patch}"

# Open the file
var info: SF_INFO
var file = sf_open(filename.cstring, SFM_READ, info.addr)

if file == nil.pointer:
  echo $sf_strerror(file)
  quit(QuitFailure)

echo &"Channels: {info.channels}"
echo &"Frames: {info.frames}"
echo &"Samplerate: {info.samplerate}"
echo &"Format: {info.format}"

# Callback procedure for audio playback
const bufferSizeInSamples = 2048
# NOTE(bctnry): for whatever reasons this needs to be 2048 or else it will crash on
# my machine. theoretically it shouldn't matter - that, or my mental model of how
# things work is wrong. if you want to test this, use a 2-channel audio file.

proc audioCallback(userdata: pointer; stream: ptr uint8; len: cint) {.cdecl.} =
  var buffer: array[bufferSizeInSamples, cfloat]
  let count = sf_read_float(file, addr buffer[0], bufferSizeInSamples)

  if count == 0:
    echo "End of file reached"
    quit(0)

  for i in 0..<count:
    cast[ptr int16](cast[int](stream) + i * 2)[] = int16(round(buffer[i] / 1.25 * 32760))
    # Without the factor of 0.8, the sound gets distorted for my ogg example file

# Init audio playback
if sdl2.init(INIT_AUDIO) != SdlSuccess:
  echo "Couldn't initialize SDL"
  quit(QuitFailure)

var aspec: AudioSpec
aspec.freq = info.samplerate
aspec.format = AUDIO_S16
aspec.channels = info.channels.uint8
aspec.samples = bufferSizeInSamples
aspec.padding = 0
aspec.callback = audioCallback
aspec.userdata = nil

if openAudio(addr aspec, nil) != 0:
  echo &"Couldn't open audio device: {getError()}"
  quit(QuitFailure)

# Start playback and wait in a loop
pauseAudio(0)
echo "Playing..."

while true:
  delay(100)
  
