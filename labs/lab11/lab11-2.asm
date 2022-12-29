%include 'in_out.asm'

SECTION .data
    filename db 'vadim.txt', 0h ; Имя файла
    msg db 'Как Вас зовут?', 0h ; Сообщение
    yoou db 'Меня зовут ' ; Сообщение
    yooulen: equ $-yoou

SECTION .bss
    name resb 255 ; переменная для вводимой строки

SECTION .text
    global _start

_start:
    ; --- Печать сообщения `msg`
    mov eax,msg
    call sprintLF
    ; ---- Запись введеной с клавиатуры строки в `name`
    mov ecx, name
    mov edx, 255
    call sread

    mov ecx, 0777o ; Создание файла.
    mov ebx, filename ; в случае успешного создания файла,
    mov eax, 8 ; в регистр eax запишется дескриптор файла
    int 80h

    mov edx, yooulen ; количество байтов для записи
    mov ecx, yoou ; адрес строки для записи в файл
    mov ebx, eax ; дескриптор файла
    mov eax, 4 ; номер системного вызова `sys_write`
    int 80h
    mov eax, ebx

    mov edx, 2 ; значение смещения -- конец файла
    mov ecx, 0 ; смещение на 0 байт
    mov ebx, eax ; дескриптор файла
    mov eax, 19 ; номер системного вызова `sys_lseek`
    int 80h ; вызов ядра
    


    mov eax, name ; в `eax` запишется количество
    call slen ; введенных байтов
    dec eax
    mov esi, eax
    mov eax, ebx

    mov edx, esi ; Запись в конец файла
    mov ecx, name ; строки из переменной `name`
    mov eax, 4
    int 80h

    ; --- Закрываем файл (`sys_close`)
    
    call quit

close:
    mov ebx, esi
    mov eax, 6
    int 80h
    ret