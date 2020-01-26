// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	volatile unsigned int *LED_PIO = (unsigned int*)0x80; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x60;
	volatile unsigned int *KEY_PIO = (unsigned int*)0x50;

	*LED_PIO = 0; //clear all LEDs
	unsigned int total = 0;
	unsigned int current = 0;
	while (1) //infinite loop
	{
		/*
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
		 */
		if(*KEY_PIO == 0x2)
			total &= 0x0;
		else if(*KEY_PIO == 0x1){
			while(*KEY_PIO == 0x1);
			current = *(SW_PIO);
			total = (total + current)%256;
		}
		*LED_PIO = total;
	}
	return 1; //never gets here
}
