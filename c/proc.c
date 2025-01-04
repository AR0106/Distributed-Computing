#include "proc.h"

pid_t c_getPid() { return getpid(); }

pid_t c_getPpid() { return getppid(); }
