#include "memory.h"

int memProtect(void *addr, size_t len) {
  return mprotect(addr, len, PROT_READ);
}
