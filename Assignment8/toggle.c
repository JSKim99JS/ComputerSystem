unsigned volatile char * gpio_led = (unsigned char *) 0x41200000;
unsigned volatile char * gpio_switch =  (unsigned char *) 0x41210000;

int toggle()
{

 int count;
 unsigned char before_switch = (* gpio_switch) & 1;

 while (1) {

 	for (count=0; count < 0x400000; count++) ;

 	*gpio_led = 0xC3;

 	for (count=0; count < 0x400000; count++) ;

 	*gpio_led = 0x3C;

 	if (before_switch != (unsigned char)((* gpio_switch) & 1))
 		return 0;

  }

 return 0;


}
