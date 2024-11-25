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
    li   s11,0   
    li   s5,0 # Images count
    li   a0, 0x2000 # loads SW register address 
    li   a2, 0x4000 # Loads Buttons register addres
    li   a4, 0x5000 # Addres Uart A control
    li   a6, 0x8000 # Addres Uart B control
    li   s4,0x3000 # leds address0

    # lui s3,0xFD
    # addi s3,s3,0x20
    li   s3,4
    j    SCAN

SCAN:
    lw   a1,0(a4)  # content of UA control
    li   s1,0x2 # loads 1 to s1
    beq  a1,s1,RECEIVE_IMAGE_PREP # If controlA is 2 the pc is sending an image

    lw   a3,0(a6)  # content of UB control
    li   s1,0x2  
    beq a3,s1,SEND_IMAGE_PREP # If controlB is 1 we send data to the FPGA

    j SCAN
RECEIVE_IMAGE_PREP:
    add s10,s10,s11   # initial address memory
    li s1,0   # i = 0

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
    li   t2,0x6000 # Address of the byte receive
    lb   t3,0(t2) # load the byte
    sb   t3,0(s10) # save the byte

    # slli t0,s1,2   # i* 4 offset
    addi s10,s10,1 # adds the offset for the next byte
    
    addi s1,s1,1 # i++
    blt  s1,s3,RECEIVE_IMAGE # if actual bytes < total bytes -> repit

    lui  t1,0x3F 
    addi t1,zero,0x48
    add  s11,s11,t1 # add 1 more image to the index

    addi s5,s5,1 # Imges + 1
    sw   s5,0(s4) # Saves the images count on leds

    j    SCAN

SEND_IMAGE_PREP:
    # S10 contains the initial addres
    li   s1,0   # i = 0
    # lui  t1,0x3F 
    # addi t1,zero,0x48
    # neg  t2,t2
    # add  t3,s11,t2
    add  s9,s11,s10 # Initial Address
    
    j SEND_IMAGE
SEND_IMAGE:
    li   t2,0x9000 # Address of the byte receive

    lb   t3,0(s9) # loads the memory data
    sb   t3,0(t2) # saves the memory data to Uart B data register

    sw  zero,0(s9) # clean data

    addi s9,s9,1 # address+1 (next byte)
    addi s1,s1,1 # i++
    blt  s1,s3,SEND_IMAGE # if actual bytes < total bytes -> repit

    neg  s3,s3 # s3 =-s3
    add  s11,s11,s3      # decrease the memory offset
    addi s5,s5,-1 # Images - 1
    sw   s5,0(s4) # Saves the images count on leds
    j SCAN