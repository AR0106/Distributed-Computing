.section .text
.global getStackPointer
.global addNumbers

getStackPointer:
  movl %esp, %eax
  ret

addNumbers:
  movl %edi, %eax
  addl %esi, %eax
  ret
