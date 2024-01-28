void sw_btn(){
    int i;
    unsigned char *sw = (unsigned char *) 0x41210000;
    
    if(*sw >= 0b10000000) { //If SW7 is in the up position, the on duration is roughly 100 msec
        for(i = 0; i < 10000000; i++);
    }
    else if(*sw >= 0b01000000) { //If SW6 is in the up position, the on duration is roughly 200 msec
        for(i = 0; i < 20000000; i++);
    }
    else if(*sw >= 0b00100000) { //If SW5 is in the up position, the on duration is roughly 300 msec
        for(i = 0; i < 30000000; i++);
    }
    else if(*sw >= 0b00010000) { //If SW4 is in the up position, the on duration is roughly 400 msec
        for(i = 0; i < 40000000; i++);
    }
    else if(*sw >= 0b00001000) { //If SW3 is in the up position, the on duration is roughly 500 msec
        for(i = 0; i < 50000000; i++);
    }
    else if(*sw >= 0b00000100) { //If SW2 is in the up position, the on duration is roughly 600 msec
        for(i = 0; i < 60000000; i++);
    }
    else if(*sw >= 0b00000010) { //If SW1 is in the up position, the on duration is roughly 700 msec
        for(i = 0; i < 70000000; i++);
    }
    else if(*sw >= 0b00000001) { //If SW0 is in the up position, the on duration is roughly 800 msec
        for(i = 0; i < 80000000; i++);
    }
    else{ //Otherwise, the LED¡¯s on duration is roughly 1 second.
        for(i = 0; i < 100000000; i++);
    }

}
