include emu8086.inc
.model small
.stack 100h
;Declare all the Variables to use in the Program 
.data
    var1 dw 0
    var2 dw 0
    char dw 0 
    result dw 0
    start_time dw ?
    end_ticks dw ?
    elapsed_ticks dw ? 
    turnaround dw ?
    msgforturn db 0dh, 0ah, "Turn around time (total time): $"
    starttime dw 0
    endingtime dw 0
    time_msg db 10, 13, "Execution time in seconds: $"
    seconds db 6 dup('$')
    mem_test_msg db 10, 13, "Memory Benchmark Test Results:$"
    read_time_msg db 10, 13, "Memory Read Time in second: $"
    write_time_msg db 10, 13, "Memory Write Time in second: $"
    copy_time_msg db 10, 13, "Memory Copy Time in second: $" 
    num1 dw 0 
    d1 dw ?  
    MatrixA dw 9 dup(0)
    MatrixB dw 9 dup(0)
    MatrixC dw 9 dup(0) 
    count db 0 
    MatrixD dw 4 dup(0)
    MatrixE dw 4 dup(0)
    MatrixF dw 4 dup(0)
    msgofEnterA db "Enter the 3x3 matrix elements: $"
    msgofResult db 0dh, 0ah, "Determinant is: $"
    resultofmatrix1 dw 0
    resultofmatrix2 dw 0
    resultofmatrix3 dw 0
    determinant dw 0
    determinants dw 0 
    space db ' $' 
    hour db 0
    min dw 0
    EnterA db "Enter the 2x2 matrix elements: $"
    Matrix2x2 dw 4 dup(0) 
    seconddisplay db 's $'
    msgEnterA db 0dh, 0ah, "Enter Matrix A elements:$"
    msgEnterB db 0dh, 0ah, "Enter Matrix B elements:$"
    msgResult db 0Dh, 0Ah, "Resultant Matrix C (A + B): ", 0ah, "$"
    msgElement db 0dh, 0ah, "Enter element [$]:$" 
    input db "Enter a Number: $"
    output db 0AH, 0DH, "In Hexa it is: $"
    msgnum1 db 'Enter the 1st number: $'     
    msg6 db 0dh, 0ah, 'In binary: $'
    msg5 db 0dh, 0ah, 'In Octal: $'
    msg db 0dh, 0ah, "The ans is : $"
    msg1 db 0dh, 0ah, "Enter the number 1: $" 
    msg2 db 0dh, 0ah, "Enter the number 2: $" 
    msg3 db 0dh, 0ah, "<<<Choose an operation: >>>", 0dh, 0ah, "01: Multiply", 0dh, 0ah, "02: Divide", 0dh, 0ah, "03: Subtract", 0dh, 0ah, "04: Add", 0dh, 0ah,"05: Decimal To Binary", 0dh, 0ah, "06: Decimal To Hexadecimal", 0dh, 0ah, "07: Decimal To Octal",0dh, 0ah, "08: 2x2 Matrix Determinant",0dh, 0ah, "09: 2x2 Matrix Addition", 0dh, 0ah, "10: 3x3 Matrix Addition" ,0dh, 0ah, "11: 3x3 Matrix Determinant ",0dh, 0ah, "12: Exit", 0dh, 0ah,"$"
    error db 0dh, 0ah, "Error: can't divide by 0 $" 
    error2 db 0dh, 0ah, "Invalid choice! Please select a number between 1 and 12.", 0dh, 0ah, "$" 
    bye db 0dh, 0ah, " ==========         bye bye           ========== $"  
    start db 0dh, 0ah, 0dh, 0ah, "   ----------------------------  <Calculator>  -------------------------$" 
    newline db 0dh, 0ah, "$"
     buffer db 500 dup(?)
     lines db 0dh, 0ah, "     =================================================================== $"
     intro db 0dh, 0ah, "                        C P U     B E N C H M A R K                      $" 

.code 

main proc 
    
    ;Moving data in ds
    mov ax, @data
    mov ds, ax
    ;To Calculate Total time of the program  
    mov ah, 00h
    int 1Ah
    mov starttime, dx
    ;intro msg
    mov dx, offset lines
    mov ah, 09h
    int 21h 
    mov dx, offset intro
    mov ah, 09h
    int 21h 
    mov dx, offset lines
    mov ah, 09h
    int 21h
    ; Start program
    mov dx, offset start
    mov ah, 09h
    int 21h
repeat:
    
    ; Display menu
    mov dx, offset msg3
    mov ah, 09h
    int 21h
checking:
    ; Take input
    call scan_num
    mov char, cx 
    ; Exit request
    cmp char, 12
    JE last 
   ; Check if char is between 1 to 12
    cmp char, 1
    jl invalid
    cmp char, 12
    jg invalid

    ; If conversion (binary, hex, or octal)
    cmp char, 5
    je binary
    cmp char, 6
    je hexa
    cmp char, 7
    je octal
    cmp char, 8
    je determ
    cmp char, 9
    je matrixadd  
    cmp char, 10
    je matrix
    cmp char, 11
    je deter 
dividin:    
    ; Start timing
    mov ah, 00h
    int 1Ah
    mov start_time, dx  
    ; Enter number 1 for other operations
    mov dx, offset msg1
    mov ah, 09h
    int 21h
    ; Take input 
    call scan_num
    mov var1, cx
    ; Enter number 2
    mov dx, offset msg2
    mov ah, 09h
    int 21h 
    ; Take input 
    call scan_num
    mov var2, cx

    ; If-else conditions 
    cmp char, 4
    je add_
    cmp char, 3
    je sub_
    cmp char, 2
    je div_
    cmp char, 1
    je mul_  




;addition func
add_:
    mov ax, var1
    add ax, var2
    mov result, ax
    jmp print
 
 
 
;Subtraction func
sub_: 
    mov ax, var1
    sub ax, var2
    mov result, ax 
    jmp print
    
    
    
    
;division func
div_:
    mov ax, var1
    mov bx, var2 
    ; Check if 0
    cmp var2, 0
    jne next
    ; Print error msg
    mov dx, offset error
    mov ah, 09h
    int 21h 
    jmp dividin
next: 
    xor dx, dx
    idiv bx
    mov result, ax
    jmp print 




;multipling function
mul_: 
    mov ax, var1
    mov bx, var2
    imul bx
    mov result, ax
    jmp print
 
 
    
;function to convert decimal to binary 

binary: 
    ; Start timing
    mov ah, 00h
    int 1Ah
    mov start_time, dx 
    ; For binary, ask for just one number
    mov dx, offset msgnum1
    mov ah, 09h
    int 21h 
    ;take input
    call scan_num
    mov num1, cx 
    ;print msg 
    mov dx, offset msg6
    mov ah, 09h
    int 21h
    ;set divisor 
    mov ax, num1
    mov bx, 2
    mov cx, 0
    ;Convert decimal 
convert_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convert_loop
    ;print the binary 
    mov dl, '0'
    mov ah, 02h
    int 21h
display_binary:
    pop dx
    mov ax, dx
    call print_num
    loop display_binary
    jmp print 
    
    
    

;function to convert decimal to hexadecimal 
hexa:
   ; Start timing
    mov ah, 00h
    int 1Ah
    mov start_time, dx 
    ;print msg  
    mov dx, offset input
    mov ah, 09h
    int 21h 
    ;take input 
    call scan_num
    mov d1, cx 
    ;print output msg
    mov dx, offset output
    mov ah, 09h
    int 21h 
    ;set counter
    mov ax, d1
    mov cx, 0
    mov dx, 0
label1:
    cmp ax, 0
    je print1
    mov bx, 16
    div bx
    push dx
    inc cx
    xor dx, dx
    jmp label1
    ;print hexadecimal number 
print1:
    cmp cx, 0
    je print
    pop dx
    cmp dx, 9
    jle continue
    add dx, 7
continue:
    add dx, 48
    mov ah, 02h
    int 21h
    dec cx
    jmp print1
    
    jmp print




;function to convert decimal to octal  
octal:
    ; Start timing
    mov ah, 00h
    int 1Ah
    mov start_time, dx
    ;print input msg  
    mov dx, offset msgnum1
    mov ah, 09h
    int 21h
    ;take input
    call scan_num
    mov num1, cx 
    ;print output msg 
    mov dx, offset msg5
    mov ah, 09h
    int 21h
    mov ax, num1
    mov bx, 8
    mov cx, 0

convert_loop1:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convert_loop1

display_binary2:
    pop dx
    mov ax, dx
    call print_num
    loop display_binary2
    jmp print
    
    
 
 
 
    
;func to find the determinant of 2x2 matrix 
determ:
   ; Start timing
    mov ah, 00h
    int 1Ah
    mov start_time, dx 
   mov dx, offset EnterA
    mov ah, 09h
    int 21h

    lea si, Matrix2x2
    mov bx, 4
input_loopz: 
    mov dx, offset msgElement
    mov ah, 09h
    int 21h

    call scan_num
    mov [si], cx
    add si, 2 
    dec bx
    cmp bx, 0
    jne input_loopz

    lea si, Matrix2x2

    mov ax, [si]
    mov bx, [si+6]
    imul bx
    mov resultofmatrix1, ax

    mov ax, [si+4]
    mov bx, [si+2]
    imul bx
    mov resultofmatrix2, ax


    mov ax, resultofmatrix1
    sub ax, resultofmatrix2
    mov determinants, ax

    mov dx, offset msgofResult
    mov ah, 09h
    int 21h

    mov ax, determinants
    call print_num
    jmp print
 



;Func to add 2 2x2 matrix  
matrixadd: 
   ; Start timing
    mov ah, 00h
    int 1Ah
    mov start_time, dx 
    mov dx, offset msgEnterA
    mov ah, 09h
    int 21h
    lea si, MatrixD
    mov bx, 0

inputD:
    mov dx, offset msgElement
    mov ah, 09h
    int 21h
    call scan_num
    mov [si + bx], cx
    add bx, 2
    cmp bx, 8
    jl inputD 

    mov dx, offset msgEnterB
    mov ah, 09h
    int 21h
    lea si, MatrixE
    mov bx, 0 

inputE:
    mov dx, offset msgElement
    mov ah, 09h
    int 21h
    call scan_num
    mov [si + bx], cx
    add bx, 2
    cmp bx, 8
    jl inputE

    lea si, MatrixD
    lea di, MatrixE
    lea bx, MatrixF
    mov cx, 4

addMatricez:
    mov ax, [si]
    add ax, [di]
    mov [bx], ax
    add si, 2
    add di, 2
    add bx, 2
    loop addMatricez 
    

    mov dx, offset msgResult
    mov ah, 09h
    int 21h
    lea si, MatrixF
    mov cx, 4
       
       
printF:
    mov ax, [si]
    call print_num
    mov dl, ' '
    mov ah, 02h
    int 21h
    add si, 2
    inc count
    cmp count, 2
    jne next1 
    mov dx, 0ah
    mov ah, 02h
    int 21h
    mov count, 0

next1:
    loop printF
    jmp print  
 
 
 
 
 
;func to find the detrminant of 3x3 Matrix    
deter: 
   ; Start timing
    mov ah, 00h
    int 1Ah
    mov start_time, dx 
    lea si, MatrixA
    mov bx, 9
input_loops: 
    mov dx, offset msgElement
    mov ah, 09h
    int 21h

    call scan_num
    mov [si], cx
    add si, 2 
    dec bx
    cmp bx, 0
    jne input_loops

    lea si, MatrixA

    mov ax, [si]
    mov ax, [si+8]
    mov bx, [si+16]
    imul bx
    mov resultofmatrix1, ax

    mov ax, [si+14]
    mov bx, [si+10]
    imul bx
    sub resultofmatrix1, ax

    mov ax, [si]
    mov bx, resultofmatrix1
    imul bx
    mov resultofmatrix1, ax

    mov ax, [si+6]
    mov bx, [si+16]
    imul bx
    mov resultofmatrix2, ax

    mov ax, [si+12]
    mov bx, [si+10]
    imul bx
    sub resultofmatrix2, ax

    mov ax, [si+2]
    mov bx, resultofmatrix2
    imul bx 
    mov resultofmatrix2, ax

    mov ax, [si+6]
    mov bx, [si+14]
    imul bx
    mov resultofmatrix3, ax

    mov ax, [si+8]
    mov bx, [si+12]
    imul bx
    sub resultofmatrix3, ax 
    mov ax, [si+4]
    mov bx, resultofmatrix3
    imul bx
    mov resultofmatrix3, ax

    mov ax, resultofmatrix1
    sub ax, resultofmatrix2
    add ax, resultofmatrix3
    mov determinant, ax

    mov dx, offset msgofResult
    mov ah, 09h
    int 21h

    mov ax, determinant
    call print_num 
    jmp print   





;func to calculate the sum of 2 3x3 Matrix    
matrix: 
    mov dx, offset msgEnterA
    mov ah, 09h
    int 21h
    lea si, MatrixA
    mov bx, 0

inputA:
    mov dx, offset msgElement
    mov ah, 09h
    int 21h
    call scan_num
    mov [si + bx], cx
    add bx, 2
    cmp bx, 18
    jl inputA 

    mov dx, offset msgEnterB
    mov ah, 09h
    int 21h
    lea si, MatrixB
    mov bx, 0 

inputB:
    mov dx, offset msgElement
    mov ah, 09h
    int 21h
    call scan_num
    mov [si + bx], cx
    add bx, 2
    cmp bx, 18
    jl inputB
    
  ; Start timing
    mov ah, 00h
    int 1Ah
    mov start_time, dx 
    lea si, MatrixA
    lea di, MatrixB
    lea bx, MatrixC
    mov cx, 9

addMatrices:
    mov ax, [si]
    add ax, [di]
    mov [bx], ax
    add si, 2
    add di, 2
    add bx, 2
    loop addMatrices 
    

    mov dx, offset msgResult
    mov ah, 09h
    int 21h
    lea si, MatrixC
    mov cx, 9
       
       
printC:
    mov ax, [si]
    call print_num
    mov dl, ' '
    mov ah, 02h
    int 21h
    add si, 2
    inc count
    cmp count, 3
    jne next2 
    mov dx, 0ah
    mov ah, 02h
    int 21h
    mov count, 0

next2:
    loop printC


 
;To print the Execution time of Calculation
print:
    mov ah, 00h
    int 1Ah
    mov end_ticks, dx

    mov ax, end_ticks
    sub ax, start_time
    mov elapsed_ticks, ax 
    mov ax, elapsed_ticks
    mov cx, 10
    mul cx                     
    mov cx, 182
    div cx 
    mov elapsed_ticks, ax 
    cmp elapsed_ticks, 60
    jge mins
    cmp char, 5
    jge ending 

    ; Display result
    mov dx, offset msg
    mov ah, 09h
    int 21h
    mov ax, result
    call print_num 
   
ending:                   

    mov dx, offset time_msg
    mov ah, 09h
    int 21h
    mov dl, '0'
    mov ah, 02h
    int 21h
    mov dl, 'h'
    mov ah, 02h
    int 21h 
    mov dl, ':'
    mov ah, 02h
    int 21h
    mov ax, min
    call print_num 
    mov dl, 'm'
    mov ah, 02h
    int 21h
    mov dl, ':'
    mov ah, 02h
    int 21h
    mov ax, elapsed_ticks
    call print_num
    mov dx, offset seconddisplay 
    mov ah, 09h
    int 21h 

    mov dx, offset newline
    mov ah, 09h
    int 21h
    ; Repeat
    jmp repeat


;to print msg if invalid input is entered 
invalid:
    ; Print invalid msg
    mov dx, offset error2
    mov ah, 09h
    int 21h
    jmp checking 



;Ending the program    
last: 
    mov dx, offset newline
    mov ah, 09h
    int 21h
    ;finding read/write/copy time 
    call memory_benchmark 
    ;to find turnaround time 
    mov ah, 00h
    int 1Ah
    mov endingtime, dx
    sub dx, starttime
    mov turnaround, dx 
    mov ax, turnaround
    mov cx, 10
    mul cx                     
    mov cx, 182
    div cx 
    mov turnaround , ax 
     cmp turnaround, 60
    jge turnaroundtimes
some:
    ;printing turnround time
    mov dx, offset msgforturn 
    mov ah, 09h
    int 21h 
    mov dl, '0'
    mov ah, 02h
    int 21h
    mov dl, 'h'
    mov ah, 02h
    int 21h 
    mov dl, ':'
    mov ah, 02h
    int 21h
    mov ax, min
    call print_num 
    mov dl, 'm'
    mov ah, 02h
    int 21h
    mov dl, ':'
    mov ah, 02h
    int 21h
    mov ax, turnaround
    call print_num
    mov dx, offset seconddisplay 
    mov ah, 09h
    int 21h
    ; End program
    mov dx, offset bye
    mov ah, 09h
    int 21h
    ;finally terminating the program  
    mov ah, 4ch
    int 21h
mins:    
    mov ax,elapsed_ticks
    mov bx, 60
    cwd
    div bx
    mov elapsed_ticks, ax
    mov min, dx
    jmp ending
     
turnaroundtimes:
    mov ax,turnaround
    mov bx, 60 
    cwd
    div bx
    mov turnaround, dx
    mov min, ax 
    jmp some
main endp

;func to find read/write/copy time 
memory_benchmark proc
    mov ah, 00h
    int 1Ah
    mov start_time, dx

    lea di, buffer
    mov cx, 500
    mov al, 55h
write_loop:
    stosb
    loop write_loop

    mov ah, 00h
    int 1Ah
    mov end_ticks, dx
    sub dx, start_time
    mov bx, dx 
    mov ax, bx
    mov cx, 10
    mul cx                     
    mov cx, 182
    div cx 
    mov elapsed_ticks, ax 
    mov dx, offset write_time_msg
    mov ah, 09h
    int 21h 
    mov dl, '0'
    mov ah, 02h
    int 21h
    mov dl, 'h'
    mov ah, 02h
    int 21h 
    mov dl, ':'
    mov ah, 02h
    int 21h
    mov ax, 0
    call print_num 
    mov dl, 'm'
    mov ah, 02h
    int 21h
    mov dl, ':' 
    mov ah, 02h
    int 21h
    mov ax, elapsed_ticks
    call print_num
    mov dx, offset seconddisplay 
    mov ah, 09h
    int 21h 

    mov ah, 00h
    int 1Ah
    mov start_time, dx

    lea si, buffer
    mov cx, 500
read_loop:
    lodsb
    loop read_loop

    mov ah, 00h
    int 1Ah
    mov end_ticks, dx
    sub dx, start_time
    mov bx, dx 
    mov ax, bx
    mov cx, 10
    mul cx                     
    mov cx, 182
    div cx
    mov elapsed_ticks, ax  
    mov dx, offset read_time_msg
    mov ah, 09h
    int 21h
    mov dl, '0'
    mov ah, 02h
    int 21h
    mov dl, 'h'
    mov ah, 02h
    int 21h 
    mov dl, ':'
    mov ah, 02h
    int 21h
    mov ax, 0
    call print_num 
    mov dl, 'm'
    mov ah, 02h
    int 21h
    mov dl, ':' 
    mov ah, 02h
    int 21h 
    mov ax, elapsed_ticks
    call print_num
    mov dx, offset seconddisplay 
    mov ah, 09h
    int 21h

    mov ah, 00h
    int 1Ah
    mov start_time, dx

    lea si, buffer
    lea di, buffer + 250
    mov cx, 250
    rep movsb

    mov ah, 00h
    int 1Ah
    mov end_ticks, dx
    sub dx, start_time
    mov bx, dx
    mov bx, dx 
    mov ax, bx
    mov cx, 10
    mul cx                     
    mov cx, 182
    div cx 
    mov elapsed_ticks, ax 
    mov dx, offset copy_time_msg
    mov ah, 09h
    int 21h
    mov dl, '0'
    mov ah, 02h
    int 21h
    mov dl, 'h'
    mov ah, 02h
    int 21h 
    mov dl, ':'
    mov ah, 02h
    int 21h
    mov ax, 0
    call print_num 
    mov dl, 'm'
    mov ah, 02h
    int 21h
    mov dl, ':' 
    mov ah, 02h
    int 21h 
    mov ax, elapsed_ticks
    call print_num
    mov dx, offset seconddisplay 
    mov ah, 09h
    int 21h
    
    ret
memory_benchmark endp 

;Macros 
define_scan_num
define_print_num
define_print_num_uns
end
