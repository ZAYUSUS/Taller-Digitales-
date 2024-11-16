.section .text
# memory control
# Switch address 0x2000
# Leds address 0x3000
# Buttons addres 0x4000
# Uart A control 0x5000
# UART A DATA 1 0x6000
# UART A DATA 2 0x7000
# UART B Ctrl 0x8000
# UART B Data1 0x9000
# UART B Data2 0x10000
# ROM from 0x0000 to 0x0FFC
# RAM from 0x40000 to 0x80000
start:
    li   s10, 0x40000 # Initial image address
    j    SCAN

SCAN:

    li   a0, 0x2000 # loads SW register address  
    lw   a1,0(a0)   # loads the content of the SW register

    li   a2, 0x4000 # Loads Buttons register addres
    lw   a3,0(a2)   # loads the content buttons register

    li   a4, 0x5000 # Addres Uart A control
    lw   a5,0(a4)  # conternt of UA control

    li   a6,0x8000 # Addres Uart B control
    lw   a7,0(a6)  # conternt of UB control

    li   s1,0x2 # loads 1 to s1
    beq  a5,s1,RECEIVE_IMAGE_PREP # If controlA is 2 the pc is sending an image
    # addi s1,-1,s1 # s1-1
    # bne  a5,s1,SEND_DATA # If the control A is 1, we send data

    j SCAN
/*
code UART:
Control =1 send
Control =2 receive
*/
RECEIVE_IMAGE_PREP:
    lui s2, 0x3F        # Load upper 20 bits of the constant into s2 (0x3F000)
    addi s2, s2, 0x48   # Add the lower 12 bits of the constant (0x48)
    add s2,s2,s10    # end memory for this image
    add s10,s10,s11   # initial address memory
    j RECEIVE_IMAGE
RECEIVE_IMAGE:
        /*
        Img1 0x40000 - 0x43F48
        Img2 0x43F48 - 0x47E90
        Img3 0x47E90 - 0x4BDD8
        Img4 0x4BDD8 - 0x4FD20
        Img5 0x4FD20 - 0x53C68
        Img6 0x53C68 - 0x57BB0
        Img7 0x57BB0 - 0x5BAF8
        Img8 0x5BAF8 - 0x5FA40
        each image is about 518400 bits or 64800 bytes
    */
    li   t1,0x6000 # Address of the byte receive
    lb   t2,0(t1) # load the byte
    sb   t2,0(s10) # save the byte 

    addi s10,s10,8 # adds the offset for the next byte

    bne  s10,s2,RECEIVE_IMAGE # if actual bytes < total bytes -> repit
    lui  t0,0x3F 
    addi t0,zero,0x48
    add  s11,s11,t0 # add 1 more image to the index
    j    SCAN