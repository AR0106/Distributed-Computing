// mem.s
#if defined (__APPLE__)
.global _getStackPointer
.global _addNumbers
#else
.global getStackPointer
.global addNumbers
#endif

.text
#if defined (__APPLE__)
_getStackPointer:
#else
getStackPointer:
#endif
  mov x0, sp
  ret

#if defined (__APPLE__)
_addNumbers:
#else
addNumbers:
#endif
  add w0, w0, w1
  ret
