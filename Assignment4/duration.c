void duration(int selection){
	int i;

    if(selection == 49) { //If selection is 1, the on duration is roughly 100 msec
        for(i = 0; i < 10000000; i++);
    }
    else if(selection == 50) {
        for(i = 0; i < 20000000; i++);
    }
    else if(selection == 51) {
        for(i = 0; i < 30000000; i++);
    }
    else if(selection == 52) {
        for(i = 0; i < 40000000; i++);
    }
    else if(selection == 53) {
        for(i = 0; i < 50000000; i++);
    }
    else if(selection == 54) {
        for(i = 0; i < 60000000; i++);
    }
    else if(selection == 55) {
        for(i = 0; i < 70000000; i++);
    }
    else if(selection == 56) {
        for(i = 0; i < 100000000; i++);
    }
}
