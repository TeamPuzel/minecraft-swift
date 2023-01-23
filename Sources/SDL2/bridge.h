
#ifdef __APPLE__ && __MACH__
  #ifdef __x86_64__
    #include "/usr/local/include/SDL2/SDL.h"
  #else
    #include "/opt/homebrew/include/SDL2/SDL.h"
  #endif
#endif
