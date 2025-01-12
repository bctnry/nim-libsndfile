from std/widestrs import WideCString

when defined(windows):
  const LibName = "sndfile.dll"
else:
  const LibName = "libsndfile.so(|.1)"

const HeaderName = "<sndfile.h>"

type
  PSNDFILE* = distinct pointer

proc `==`*(x: PSNDFILE, y: pointer): bool = (x.pointer) == y
proc `==`*(x: pointer, y: PSNDFILE): bool = (y.pointer) == x

type
  SFCountT* = int64

  SF_INFO* {.importc: "SF_INFO".} = object
    frames*: SFCountT
    samplerate*: cint
    channels*: cint
    format*: cint
    sections*: cint
    seekable*: cint

type
  SFCommand* {.size: sizeof(cint).} = enum
    SFC_GET_LIB_VERSION = 0x1000,
    SFC_GET_LOG_INFO        = 0x1001,
    SFC_GET_CURRENT_SF_INFO      = 0x1002
    SFC_GET_NORM_DOUBLE        = 0x1010
    SFC_GET_NORM_FLOAT        = 0x1011
    SFC_SET_NORM_DOUBLE        = 0x1012
    SFC_SET_NORM_FLOAT        = 0x1013
    SFC_SET_SCALE_FLOAT_INT_READ  = 0x1014
    SFC_SET_SCALE_INT_FLOAT_WRITE  = 0x1015
    SFC_GET_SIMPLE_FORMAT_COUNT    = 0x1020
    SFC_GET_SIMPLE_FORMAT      = 0x1021
    SFC_GET_FORMAT_INFO        = 0x1028
    SFC_GET_FORMAT_MAJOR_COUNT    = 0x1030
    SFC_GET_FORMAT_MAJOR      = 0x1031
    SFC_GET_FORMAT_SUBTYPE_COUNT  = 0x1032
    SFC_GET_FORMAT_SUBTYPE      = 0x1033
    SFC_CALC_SIGNAL_MAX        = 0x1040
    SFC_CALC_NORM_SIGNAL_MAX    = 0x1041
    SFC_CALC_MAX_ALL_CHANNELS    = 0x1042
    SFC_CALC_NORM_MAX_ALL_CHANNELS  = 0x1043
    SFC_GET_SIGNAL_MAX        = 0x1044
    SFC_GET_MAX_ALL_CHANNELS    = 0x1045
    SFC_SET_ADD_PEAK_CHUNK      = 0x1050
    SFC_UPDATE_HEADER_NOW      = 0x1060
    SFC_SET_UPDATE_HEADER_AUTO    = 0x1061
    SFC_FILE_TRUNCATE        = 0x1080
    SFC_SET_RAW_START_OFFSET    = 0x1090
    # Commands reserved for dithering, which is not implemented.
    SFC_SET_DITHER_ON_WRITE      = 0x10A0
    SFC_SET_DITHER_ON_READ      = 0x10A1
    SFC_GET_DITHER_INFO_COUNT    = 0x10A2
    SFC_GET_DITHER_INFO        = 0x10A3
    SFC_GET_EMBED_FILE_INFO      = 0x10B0
    SFC_SET_CLIPPING        = 0x10C0
    SFC_GET_CLIPPING        = 0x10C1
    SFC_GET_CUE_COUNT        = 0x10CD
    SFC_GET_CUE            = 0x10CE
    SFC_SET_CUE            = 0x10CF
    SFC_GET_INSTRUMENT        = 0x10D0
    SFC_SET_INSTRUMENT        = 0x10D1
    SFC_GET_LOOP_INFO        = 0x10E0
    SFC_GET_BROADCAST_INFO      = 0x10F0
    SFC_SET_BROADCAST_INFO      = 0x10F1
    SFC_GET_CHANNEL_MAP_INFO    = 0x1100
    SFC_SET_CHANNEL_MAP_INFO    = 0x1101
    SFC_RAW_DATA_NEEDS_ENDSWAP    = 0x1110
    # Support for Wavex Ambisonics Format */
    SFC_WAVEX_SET_AMBISONIC      = 0x1200
    SFC_WAVEX_GET_AMBISONIC      = 0x1201
    # RF64 files can be set so that on-close, writable files that have less
    # than 4GB of data in them are converted to RIFF/WAV, as per EBU
    # recommendations.
    SFC_RF64_AUTO_DOWNGRADE      = 0x1210
    SFC_SET_VBR_ENCODING_QUALITY  = 0x1300
    SFC_SET_COMPRESSION_LEVEL    = 0x1301
    # Ogg format commands */
    SFC_SET_OGG_PAGE_LATENCY_MS    = 0x1302
    SFC_SET_OGG_PAGE_LATENCY    = 0x1303
    SFC_GET_OGG_STREAM_SERIALNO    = 0x1306
    SFC_GET_BITRATE_MODE      = 0x1304
    SFC_SET_BITRATE_MODE      = 0x1305
    # Cart Chunk support */
    SFC_SET_CART_INFO        = 0x1400
    SFC_GET_CART_INFO        = 0x1401
    # Opus files original samplerate metadata */
    SFC_SET_ORIGINAL_SAMPLERATE    = 0x1500
    SFC_GET_ORIGINAL_SAMPLERATE    = 0x1501
    # Following commands for testing only. 
    SFC_TEST_IEEE_FLOAT_REPLACE    = 0x6001
    # These SFC_SET_ADD_* values are deprecated and will disappear at some
    # time in the future. They are guaranteed to be here up to and
    # including version 1.0.8 to avoid breakage of existing software.
    # They currently do nothing and will continue to do nothing.
    SFC_SET_ADD_HEADER_PAD_CHUNK  = 0x1051
    SFC_SET_ADD_DITHER_ON_WRITE    = 0x1070
    SFC_SET_ADD_DITHER_ON_READ    = 0x1071

type SFFormat* = distinct cint

# Major formats.
const SF_FORMAT_WAV*: SFFormat = 0x010000.SFFormat    # Microsoft WAV format (little endian default). 
const SF_FORMAT_AIFF*: SFFormat = 0x020000.SFFormat    # Apple/SGI AIFF format (big endian). 
const SF_FORMAT_AU*: SFFormat = 0x030000.SFFormat    # Sun/NeXT AU format (big endian). 
const SF_FORMAT_RAW*: SFFormat = 0x040000.SFFormat    # RAW PCM data. 
const SF_FORMAT_PAF*: SFFormat = 0x050000.SFFormat    # Ensoniq PARIS file format. 
const SF_FORMAT_SVX*: SFFormat = 0x060000.SFFormat    # Amiga IFF / SVX8 / SV16 format. 
const SF_FORMAT_NIST*: SFFormat = 0x070000.SFFormat    # Sphere NIST format. 
const SF_FORMAT_VOC*: SFFormat = 0x080000.SFFormat    # VOC files. 
const SF_FORMAT_IRCAM*: SFFormat = 0x0A0000.SFFormat    # Berkeley/IRCAM/CARL 
const SF_FORMAT_W64*: SFFormat = 0x0B0000.SFFormat    # Sonic Foundry's 64 bit RIFF/WAV 
const SF_FORMAT_MAT4*: SFFormat = 0x0C0000.SFFormat    # Matlab (tm) V4.2 / GNU Octave 2.0 
const SF_FORMAT_MAT5*: SFFormat = 0x0D0000.SFFormat    # Matlab (tm) V5.0 / GNU Octave 2.1 
const SF_FORMAT_PVF*: SFFormat = 0x0E0000.SFFormat    # Portable Voice Format 
const SF_FORMAT_XI*: SFFormat = 0x0F0000.SFFormat    # Fasttracker 2 Extended Instrument 
const SF_FORMAT_HTK*: SFFormat = 0x100000.SFFormat    # HMM Tool Kit format 
const SF_FORMAT_SDS*: SFFormat = 0x110000.SFFormat    # Midi Sample Dump Standard 
const SF_FORMAT_AVR*: SFFormat = 0x120000.SFFormat    # Audio Visual Research 
const SF_FORMAT_WAVEX*: SFFormat = 0x130000.SFFormat    # MS WAVE with WAVEFORMATEX 
const SF_FORMAT_SD2*: SFFormat = 0x160000.SFFormat    # Sound Designer 2 
const SF_FORMAT_FLAC*: SFFormat = 0x170000.SFFormat    # FLAC lossless file format 
const SF_FORMAT_CAF*: SFFormat = 0x180000.SFFormat    # Core Audio File format 
const SF_FORMAT_WVE*: SFFormat = 0x190000.SFFormat    # Psion WVE format 
const SF_FORMAT_OGG*: SFFormat = 0x200000.SFFormat    # Xiph OGG container 
const SF_FORMAT_MPC2K*: SFFormat = 0x210000.SFFormat    # Akai MPC 2000 sampler 
const SF_FORMAT_RF64*: SFFormat = 0x220000.SFFormat    # RF64 WAV file 
const SF_FORMAT_MPEG*: SFFormat = 0x230000.SFFormat    # MPEG-1/2 audio stream 
    
# Subtypes from here on. 
const SF_FORMAT_PCM_S8*    = 0x0001.SFFormat    # Signed 8 bit data 
const SF_FORMAT_PCM_16*    = 0x0002.SFFormat    # Signed 16 bit data 
const SF_FORMAT_PCM_24*    = 0x0003.SFFormat    # Signed 24 bit data 
const SF_FORMAT_PCM_32*    = 0x0004.SFFormat    # Signed 32 bit data 
const SF_FORMAT_PCM_U8*    = 0x0005.SFFormat    # Unsigned 8 bit data (WAV and RAW only) 
const SF_FORMAT_FLOAT*      = 0x0006.SFFormat    # 32 bit float data 
const SF_FORMAT_DOUBLE*    = 0x0007.SFFormat    # 64 bit float data 
const SF_FORMAT_ULAW*      = 0x0010.SFFormat    # U-Law encoded. 
const SF_FORMAT_ALAW*      = 0x0011.SFFormat    # A-Law encoded. 
const SF_FORMAT_IMA_ADPCM*    = 0x0012.SFFormat    # IMA ADPCM. 
const SF_FORMAT_MS_ADPCM*    = 0x0013.SFFormat    # Microsoft ADPCM. 
const SF_FORMAT_GSM610*    = 0x0020.SFFormat    # GSM 6.10 encoding. 
const SF_FORMAT_VOX_ADPCM*    = 0x0021.SFFormat    # OKI / Dialogix ADPCM 
const SF_FORMAT_NMS_ADPCM_16*  = 0x0022.SFFormat    # 16kbs NMS G721-variant encoding. 
const SF_FORMAT_NMS_ADPCM_24*  = 0x0023.SFFormat    # 24kbs NMS G721-variant encoding. 
const SF_FORMAT_NMS_ADPCM_32*  = 0x0024.SFFormat    # 32kbs NMS G721-variant encoding. 
const SF_FORMAT_G721_32*    = 0x0030.SFFormat    # 32kbs G721 ADPCM encoding. 
const SF_FORMAT_G723_24*    = 0x0031.SFFormat    # 24kbs G723 ADPCM encoding. 
const SF_FORMAT_G723_40*    = 0x0032.SFFormat    # 40kbs G723 ADPCM encoding. 
const SF_FORMAT_DWVW_12*    = 0x0040.SFFormat     # 12 bit Delta Width Variable Word encoding. 
const SF_FORMAT_DWVW_16*    = 0x0041.SFFormat     # 16 bit Delta Width Variable Word encoding. 
const SF_FORMAT_DWVW_24*    = 0x0042.SFFormat     # 24 bit Delta Width Variable Word encoding. 
const SF_FORMAT_DWVW_N*    = 0x0043.SFFormat     # N bit Delta Width Variable Word encoding. 
const SF_FORMAT_DPCM_8*    = 0x0050.SFFormat    # 8 bit differential PCM (XI only) 
const SF_FORMAT_DPCM_16*    = 0x0051.SFFormat    # 16 bit differential PCM (XI only) 
const SF_FORMAT_VORBIS*    = 0x0060.SFFormat    # Xiph Vorbis encoding. 
const SF_FORMAT_OPUS*      = 0x0064.SFFormat    # Xiph/Skype Opus encoding. 
const SF_FORMAT_ALAC_16*    = 0x0070.SFFormat    # Apple Lossless Audio Codec (16 bit). 
const SF_FORMAT_ALAC_20*    = 0x0071.SFFormat    # Apple Lossless Audio Codec (20 bit). 
const SF_FORMAT_ALAC_24*    = 0x0072.SFFormat    # Apple Lossless Audio Codec (24 bit). 
const SF_FORMAT_ALAC_32*    = 0x0073.SFFormat    # Apple Lossless Audio Codec (32 bit). 
const SF_FORMAT_MPEG_LAYER_I*  = 0x0080.SFFormat    # MPEG-1 Audio Layer I 
const SF_FORMAT_MPEG_LAYER_II*  = 0x0081.SFFormat    # MPEG-1 Audio Layer II 
const SF_FORMAT_MPEG_LAYER_III* = 0x0082.SFFormat    # MPEG-2 Audio Layer III 
    
# Endian-ness options.
const SF_ENDIAN_FILE*: cint      = 0x00000000  # Default file endian-ness. 
const SF_ENDIAN_LITTLE*: cint    = 0x10000000  # Force little endian-ness. 
const SF_ENDIAN_BIG*: cint      = 0x20000000  # Force big endian-ness. 
const SF_ENDIAN_CPU*: cint      = 0x30000000  # Force CPU endian-ness. 

const SF_FORMAT_SUBMASK*: cint    = 0x0000FFFF
const SF_FORMAT_TYPEMASK*: cint    = 0x0FFF0000
const SF_FORMAT_ENDMASK*: cint    = 0x30000000

proc `or`*(x: SFFormat, y: SFFormat): SFFormat = ((x.cint) or (y.cint)).SFFormat
proc `$`*(x: SFFormat): string = $(x.cint)

type SFStringKey* = distinct cint
const SF_STR_TITLE*: SFStringKey = 0x01.SFStringKey
const SF_STR_COPYRIGHT*: SFStringKey = 0x02.SFStringKey
const SF_STR_SOFTWARE*: SFStringKey = 0x03.SFStringKey
const SF_STR_ARTIST*: SFStringKey = 0x04.SFStringKey
const SF_STR_COMMENT*: SFStringKey = 0x05.SFStringKey
const SF_STR_DATE*: SFStringKey = 0x06.SFStringKey
const SF_STR_ALBUM*: SFStringKey = 0x07.SFStringKey
const SF_STR_LICENSE*: SFStringKey = 0x08.SFStringKey
const SF_STR_TRACKNUMBER*: SFStringKey = 0x09.SFStringKey
const SF_STR_GENRE*: SFStringKey = 0x10.SFStringKey

const SF_STR_FIRST* = SF_STR_TITLE
const SF_STR_LAST* = SF_STR_GENRE

type SFBool* = cint
const SF_FALSE*: SFBool = 0
const SF_TRUE*: SFBool = 1

type
  SFFileOpenMode* {.size: sizeof(cint).} = enum
  # Modes for opening files.
    SFM_READ = 0x10
    SFM_WRITE = 0x20
    SFM_RDWR = 0x30
    SF_AMBISONIC_NONE = 0x40
    SF_AMBISONIC_B_FORMAT = 0x41

type
  SF_CHUNK_INFO* {.importc: "SF_CHUNK_INFO".} = object
    id*: array[64, cchar]
    id_size*: cuint
    datalen*: cuint
    data*: pointer
  
# Public error values. These are guaranteed to remain unchanged for the duration
# of the library major version number.
# There are also a large number of private error numbers which are internal to
# the library which can change at any time.

type SFError* = distinct cint
const SF_ERR_NO_ERROR*: SFError = 0.SFError
const SF_ERR_UNRECOGNISED_FORMAT*: SFError = 1.SFError
const SF_ERR_SYSTEM*: SFError = 2.SFError
const SF_ERR_MALFORMED_FILE*: SFError = 3.SFError
const SF_ERR_UNSUPPORTED_ENCODING*: SFError = 4.SFError

type
  SFChannelMap* {.size: sizeof(cint).} = enum
    SF_CHANNEL_MAP_INVALID = 0
    SF_CHANNEL_MAP_MONO = 1
    SF_CHANNEL_MAP_LEFT          # Apple calls this 'Left' 
    SF_CHANNEL_MAP_RIGHT          # Apple calls this 'Right' 
    SF_CHANNEL_MAP_CENTER          # Apple calls this 'Center' 
    SF_CHANNEL_MAP_FRONT_LEFT
    SF_CHANNEL_MAP_FRONT_RIGHT
    SF_CHANNEL_MAP_FRONT_CENTER
    SF_CHANNEL_MAP_REAR_CENTER        # Apple calls this 'Center Surround', Msft calls this 'Back Center' 
    SF_CHANNEL_MAP_REAR_LEFT        # Apple calls this 'Left Surround', Msft calls this 'Back Left' 
    SF_CHANNEL_MAP_REAR_RIGHT        # Apple calls this 'Right Surround', Msft calls this 'Back Right' 
    SF_CHANNEL_MAP_LFE            # Apple calls this 'LFEScreen', Msft calls this 'Low Frequency'  
    SF_CHANNEL_MAP_FRONT_LEFT_OF_CENTER  # Apple calls this 'Left Center' 
    SF_CHANNEL_MAP_FRONT_RIGHT_OF_CENTER  # Apple calls this 'Right Center 
    SF_CHANNEL_MAP_SIDE_LEFT        # Apple calls this 'Left Surround Direct' 
    SF_CHANNEL_MAP_SIDE_RIGHT        # Apple calls this 'Right Surround Direct' 
    SF_CHANNEL_MAP_TOP_CENTER        # Apple calls this 'Top Center Surround' 
    SF_CHANNEL_MAP_TOP_FRONT_LEFT      # Apple calls this 'Vertical Height Left' 
    SF_CHANNEL_MAP_TOP_FRONT_RIGHT      # Apple calls this 'Vertical Height Right' 
    SF_CHANNEL_MAP_TOP_FRONT_CENTER    # Apple calls this 'Vertical Height Center' 
    SF_CHANNEL_MAP_TOP_REAR_LEFT      # Apple and MS call this 'Top Back Left' 
    SF_CHANNEL_MAP_TOP_REAR_RIGHT      # Apple and MS call this 'Top Back Right' 
    SF_CHANNEL_MAP_TOP_REAR_CENTER      # Apple and MS call this 'Top Back Center' 
    SF_CHANNEL_MAP_AMBISONIC_B_W
    SF_CHANNEL_MAP_AMBISONIC_B_X
    SF_CHANNEL_MAP_AMBISONIC_B_Y
    SF_CHANNEL_MAP_AMBISONIC_B_Z
    SF_CHANNEL_MAP_MAX

type
  SFBitrateMode* {.size: sizeof(cint).} = enum
    SF_BITRATE_MODE_CONSTANT = 0
    SF_BITRATE_MODE_AVERAGE
    SF_BITRATE_MODE_VARIABLE

    
type
  # In the original C header this is set to the same value as SEEK_SET,
  # SEEK_CUR and SEEK_END, which is also the same as fspSet, fspCur and
  # fspEnd in std/syncio. This order is thus not to be changed.
  SFSeekPos* {.size: sizeof(cint).}= enum
    SF_SEEK_SET
    SF_SEEK_CUR
    SF_SEEK_END

type
  P_SF_CHUNK_ITERATOR* = distinct pointer


# The SF_FORMAT_INFO struct is used to retrieve information about the sound
# file formats libsndfile supports using the sf_command () interface.
#
# Using this interface will allow applications to support new file formats
# and encoding types when libsndfile is upgraded, without requiring
# re-compilation of the application.
#
# Please consult the libsndfile documentation (particularly the information
# on the sf_command () interface) for examples of its use.
    
type
  SF_FORMAT_INFO* {.importc.} = object
    format*: SFFormat
    name*: cstring
    extension*: cstring

type
  SFDitherType* {.size: sizeof(cint).} = enum
    SFD_DEFAULT_LEVEL = 0
    SFD_CUSTOM_LEVEL = 0x40000000
    SFD_NO_DITHER = 500
    SFD_WHITE = 501
    SFD_TRIANGULAR_PDF = 502

  SF_DITHER_INFO* {.importc.} = object
    dType*: SFDitherType
    level*: cdouble
    name*: cstring

# Struct used to retrieve information about a file embedded within a
# larger file. See SFC_GET_EMBED_FILE_INFO.

type
  SF_EMBED_FILE_INFO* {.importc.} = object
    offset*: SFCountT
    length*: SFCountT

# Struct used to retrieve cue marker information from a file

type
  SF_CUE_POINT* {.importc.} = object
    indx*: int32
    position*: uint32
    fcc_chunk*: int32
    chunk_start*: int32
    block_start*: int32
    sample_offset*: uint32
    name*: array[256, cchar]

var SF_CUES: array[100, tuple[cue_count: uint32, cue_points: SFCuePoint]]

type SFLoopType* = cint
const SF_LOOP_NONE: SFLoopType = 800
const SF_LOOP_FORWARD: SFLoopType = 801
const SF_LOOP_BACKWARD: SFLoopType = 802
const SF_LOOP_ALTERNATING: SFLoopType = 803

type
  SF_INSTRUMENT_LOOP* = object
    mode*: cint
    start*: uint32
    `end`*: uint32
    count*: uint32
  SF_INSTRUMENT* {.importc.} = object
    gain*: cint
    basenote*: cchar
    detune*: cchar
    velocity_lo*: cchar
    velocity_hi*: cchar
    key_lo*: cchar
    key_hi*: cchar
    loop_count*: cint
    loops*: array[16, SF_INSTRUMENT_LOOP]

# Struct used to retrieve loop information from a file.
type
  SF_LOOP_INFO* {.importc.} = object
    time_sig_num*: cshort
    #  any positive integer    > 0
    time_sig_den*: cshort
    #  any positive power of 2 > 0
    loop_mode*: cint
    #  see SF_LOOP enum
    num_beats*: cint
    #  this is NOT the amount of quarter notes !!!
    #  a full bar of 4/4 is 4 beats
    #  a full bar of 7/8 is 7 beats
    bpm*: cfloat
    #  suggestion, as it can be calculated using other fields:
    #  file's length, file's sampleRate and our time_sig_den
    #  -> bpms are always the amount of _quarter notes_ per minute
    root_key*: cint
    #  MIDI note, or -1 for None
    future*: array[6, cint]


# Struct used to retrieve broadcast (EBU) information from a file.
# Strongly (!) based on EBU "bext" chunk format used in Broadcast WAVE.

type
  SF_BROADCAST_INFO* {.importc.} = object
    description*: array[256, cchar]
    originator*: array[32, cchar]
    originator_reference*: array[32, cchar]
    origination_date*: array[10, cchar]
    origination_time*: array[8, cchar]
    time_reference_low*: uint32
    time_reference_high*: uint32
    version*: cshort
    umid*: array[64, cchar]
    loudness_value*: int16
    loudness_range*: int16
    max_true_peak_level*: int16
    max_momentary_loudness*: int16
    max_shortterm_loudness*: int16
    reserved: array[180, cchar]
    coding_history_size*: uint32
    coding_history*: array[256, cchar]

type
  SF_CART_TIMER* {.importc.} = object
    usage*: array[4, cchar]
    value*: int32

  SF_CART_INFO* {.importc.} = object
    version*: array[4, cchar]
    title*: array[64, cchar]
    artist*: array[64, cchar]
    cut_id*: array[64, cchar]
    client_id*: array[64, cchar]
    category*: array[64, cchar]
    classification*: array[64, cchar]
    out_cue*: array[64, cchar]
    start_date*: array[10, cchar]
    start_time*: array[8, cchar]
    end_date*: array[10, cchar]
    end_time*: array[8, cchar]
    producer_app_id*: array[64, cchar]
    producer_app_version*: array[64, cchar]
    user_def*: array[64, cchar]
    level_reference*: int32
    post_timers*: array[8, SF_CART_TIMER]
    reserved: array[276, cchar]
    url*: array[1024, cchar]
    tag_text_size*: uint32
    tag_text*: array[256, cchar]

type
  # NOTE: untested.
  # TODO: test if this works.
  SF_VIRTUAL_IO* = object
    get_filelen*: proc (user_data: pointer): SFCountT
    seek*: proc (offset: SFCountT, whence: cint, user_data: pointer): SFCountT
    read*: proc (p: pointer, count: SFCountT, user_data: pointer): SFCountT
    write*: proc (p: pointer, count: SFCountT, user_data: pointer): SFCountT
    tell*: proc (user_data: pointer): SFCountT
    
{.push header: HeaderName.}

proc sf_version_string*(): cstring {.importc: "sf_version_string".}
proc sf_open*(path: cstring, mode: SFFileOpenMode, sfinfo: ptr SF_INFO): PSNDFILE {.importc: "sf_open".}
# From the original header file:
#   If close_desc is TRUE, the file descriptor will be closed when sf_close() is called.
#   If it is FALSE, the descriptor will not be closed.
proc sf_open_fd*(fd: cint, mode: SFFileOpenMode, close_desc: cint): PSNDFILE {.importc.}
proc sf_open_virtual*(sfvirtual: ptr SF_VIRTUAL_IO, mode: SFFileOpenMode, sfinfo: ptr SF_INFO, userdata: pointer): PSNDFILE {.importc.}
proc sf_error*(sndfile: PSNDFILE): cint {.importc: "sf_error".}
proc sf_strerror*(sndfile: PSNDFILE): cstring {.importc: "sf_strerror".}
proc sf_error_number*(errnum: cint): cstring {.importc: "sf_error_number".}
# NOTE: these two are deprecated, but since they still exist in the header file I should retain them here.
proc sf_perror*(sndfile: PSNDFILE): cint {.importc: "sf_perror".}
proc sf_error_str*(sndfile: PSNDFILE, str: cstring, length: csize): cint {.importc: "sf_error_str".}

proc sf_command*(sndfile: PSNDFILE, command: SFCommand, data: pointer, datasize: cint): cint {.importc: "sf_command".}
proc sf_format_check*(info: ptr SF_INFO): cint {.importc: "sf_format_check".}

proc sf_seek*(sndfile: PSNDFILE, frames: SFCountT, whence: cint): SFCountT {.importc: "sf_seek".}

proc sf_set_string*(sndfile: PSNDFILE, str_type: SFStringKey, str: cstring): cint {.importc: "sf_set_string".}
proc sf_get_string*(sndfile: PSNDFILE, str_type: SFStringKey): cstring {.importc: "sf_get_string".}

proc sf_current_byterate*(sndfile: PSNDFILE): cint {.importc: "sf_current_byterate".}

proc sf_read_raw*(sndfile: PSNDFILE, `ptr`: pointer, bytes: SFCountT): SFCountT {.importc.}
proc sf_write_raw*(sndfile: PSNDFILE, `ptr`: pointer, bytes: SFCountT): SFCountT {.importc.}

proc sf_readf_short*(sndfile: PSNDFILE, `ptr`: ptr cshort, frames: SFCountT): SFCountT {.importc.}
proc sf_writef_short*(sndfile: PSNDFILE, `ptr`: ptr cshort, frames: SFCountT): SFCountT {.importc.}
proc sf_readf_int*(sndfile: PSNDFILE, `ptr`: ptr cint, frames: SFCountT): SFCountT {.importc.}
proc sf_writef_int*(sndfile: PSNDFILE, `ptr`: ptr cint, frames: SFCountT): SFCountT {.importc.}
proc sf_readf_float*(sndfile: PSNDFILE, `ptr`: ptr cfloat, frames: SFCountT): SFCountT {.importc.}
proc sf_writef_float*(sndfile: PSNDFILE, `ptr`: ptr cfloat, frames: SFCountT): SFCountT {.importc.}
proc sf_readf_double*(sndfile: PSNDFILE, `ptr`: ptr cdouble, frames: SFCountT): SFCountT {.importc.}
proc sf_writef_double*(sndfile: PSNDFILE, `ptr`: ptr cdouble, frames: SFCountT): SFCountT {.importc.}

proc sf_read_short*(sndfile: PSNDFILE, `ptr`: ptr cshort, frames: SFCountT): SFCountT {.importc.}
proc sf_write_short*(sndfile: PSNDFILE, `ptr`: ptr cshort, frames: SFCountT): SFCountT {.importc.}
proc sf_read_int*(sndfile: PSNDFILE, `ptr`: ptr cint, frames: SFCountT): SFCountT {.importc.}
proc sf_write_int*(sndfile: PSNDFILE, `ptr`: ptr cint, frames: SFCountT): SFCountT {.importc.}
proc sf_read_float*(sndfile: PSNDFILE, `ptr`: ptr cfloat, frames: SFCountT): SFCountT {.importc.}
proc sf_write_float*(sndfile: PSNDFILE, `ptr`: ptr cfloat, frames: SFCountT): SFCountT {.importc.}
proc sf_read_double*(sndfile: PSNDFILE, `ptr`: ptr cdouble, frames: SFCountT): SFCountT {.importc.}
proc sf_write_double*(sndfile: PSNDFILE, `ptr`: ptr cdouble, frames: SFCountT): SFCountT {.importc.}

proc sf_close*(sndfile: PSNDFILE): cint {.importc.}
proc sf_write_sync*(sndfile: PSNDFILE): void {.importc.}

when defined(windows):
  proc sf_wchar_open*(wpath: WideCString, mode: SFFileOpenMode, sfinfo: ptr SF_INFO): PSNDFILE {.importc: "sf_wchar_open".}

proc sf_set_chunk*(sndfile: PSNDFILE, chunk_info: ptr SF_CHUNK_INFO): cint {.importc.}
proc sf_get_chunk_iterator*(sndfile: PSNDFILE, chunk_info: ptr SF_CHUNK_INFO): P_SF_CHUNK_ITERATOR {.importc.}
proc sf_next_chunk_iterator*(i: P_SF_CHUNK_ITERATOR): P_SF_CHUNK_ITERATOR {.importc.}
proc sf_get_chunk_size*(i: P_SF_CHUNK_ITERATOR, chunk_info: ptr SF_CHUNK_INFO): cint {.importc.}
proc sf_get_chunk_data*(i: P_SF_CHUNK_ITERATOR, chunk_info: ptr SF_CHUNK_INFO): cint {.importc.}
{.pop.}
