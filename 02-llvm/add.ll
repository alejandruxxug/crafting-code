; Hand-written LLVM IR — exactly the overlay from the video (5:45).
; This is a real language with a real assembler; nothing here is mocked up.
define i32 @add(i32 %a, i32 %b) {
  %sum = add nsw i32 %a, %b
  ret i32 %sum
}
