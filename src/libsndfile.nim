when defined(SNDFILE_STATIC):
  import libsndfile/staticlink
  export staticlink
else:
  import libsndfile/dynamiclink
  export dynamiclink
  
