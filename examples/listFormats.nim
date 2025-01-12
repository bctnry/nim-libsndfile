# static linking: nim c -d:SNDFILE_STATIC --clib:sndfile listFormats.nim
# dynamic linking: nim c listformats.nim

import libsndfile

proc main(): void =
  var info: SF_FORMAT_INFO
  var sfinfo: SF_INFO
  var format, major_count, subtype_count, m, s: cint
  
  sfinfo = SF_INFO(frames: 0, samplerate: 0, channels: 0, format: 0, sections: 0, seekable: 0)
  echo "Version : ", sf_version_string()

  discard sf_command(nil.PSNDFILE, SFC_GET_FORMAT_MAJOR_COUNT, major_count.addr, (sizeof cint).cint)
  discard sf_command(nil.PSNDFILE, SFC_GET_FORMAT_SUBTYPE_COUNT, subtype_count.addr, (sizeof cint).cint)

  sfinfo.channels = 1
  for m in 0..<major_count:
    info.format = m
    discard sf_command(nil.PSNDFILE, SFC_GET_FORMAT_MAJOR, info.addr, (sizeof SF_FORMAT_INFO).cint)
    echo info.name, "  (extension \"", info.extension, "\")"

    format = info.format
    for s in 0..<subtype_count:
      info.format = s
      discard sf_command(nil.PSNDFILE, SFC_GET_FORMAT_SUBTYPE, info.addr, (sizeof SF_FORMAT_INFO).cint)
      format = (format and SF_FORMAT_TYPEMASK) or info.format
      sfinfo.format = format
      if sf_format_check(sfinfo.addr) > 0:
        echo "    ", info.name
    echo ""
  echo ""

when isMainModule:
  main()
      
