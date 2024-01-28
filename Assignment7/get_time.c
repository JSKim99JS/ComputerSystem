void get_time(char* time) {
	// get hour, minute, second from memory by changing ascii num to int num
	int hour = 10 * (time[0] - 48) + (time[1] - 48);
	int minute = 10 * (time[4] - 48) + (time[5] - 48);
	int second = 10 * (time[8] - 48) + (time[9] - 48);
	int isS = 0, isM = 0; // isS means if computed second is over 59 or not. similarly isM means if computed minute is over 59 or not.

	// computing new second, minute, hour
	isS = (second + 1) / 60;
	second = (second + 1) % 60;
	isM = (minute + isS) / 60;
	minute = (minute + isS) % 60;
	hour = (hour + isM) % 24;

	// putting new time to memory
	time[0] = (char)(hour / 10 + 48);
	time[1] = (char)(hour % 10 + 48);
	time[4] = (char)(minute / 10 + 48);
	time[5] = (char)(minute % 10 + 48);
	time[8] = (char)(second / 10 + 48);
	time[9] = (char)(second % 10 + 48);
}
