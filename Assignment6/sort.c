//#pragma GCC target ("thumb")
#pragma GCC target ("arm")

int main()
{
	int indata[32] = { 2, 0, -7, -1, 3, 8, -4, 10,
					  -9, -16, 15, 13, 1, 4, -3, 14,
					  -8, -10, -15, 6, -13, -5, 9, 12,
					  -11, -14, -6, 11, 5, 7, -2, -12 };
	int outdata[32] = { 0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0, 0,};
	int i, j, minIndex, tmp;

	///selection sort
	for(i = 0; i < 31; i++) {
	    minIndex = i; // initialize minIndex with i
	    for(j = i+1; j < 32; j++){
	        if(indata[minIndex] > indata[j])
	        	minIndex = j; // if original indata[minIndex] is larger than indata[j], then change the minIndex with j
	    }
	    tmp = indata[i]; // switch the min value and indata[i]
	    indata[i] = indata[minIndex];
	    indata[minIndex] = tmp;
	}

	for(i = 0; i < 32; i++) {
		outdata[i] = indata[i]; // move data from indata to outdata
	}

	return 0;
}
