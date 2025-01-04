; mem.set
section .text
global getStackPointer
global addNumbers

getStackPointer:
  mov rax, rsp
  ret

addNumbers:
  mov eax, edi
  add eax, esi
  ret
