/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000040;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

//Debug Use
//Print a word
void printWord(uchar* word){
	for(int i=0;i<4;i++)
		printf("%x",word[i]);
	printf("\n");
}
void printState(uchar* state){
	for(int i = 0;i<4;i++){
		for(int j = 0;j<4;j++){
			printf("%x ",state[j*4 + i]);
		}
		printf("\n");
	}
	printf("\n");
}
/**
 * Helper Function
 * 1. KeyExpansion
 * 2. SubBytes
 * 3. ShiftRows
 * 4. MixColumns
 * 5. AddRoundKey
 */

//SubBytes
uchar SubBytes(uchar orgChar){
	return aes_sbox[(orgChar / 16) * 16 + orgChar % 16];
}

//RotWord
void RotWord(uchar* word){
	uchar firstChar = word[0];
	for(int i = 0;i<3;i++){
		word[i] = word[i+1];
	}
	word[3] = firstChar;
}

void RotWordRow(uchar* word){
	uchar firstChar = word[0];
	for(int i = 0;i<16;i+=4){
		word[i] = word[i+4];
	}
	word[12] = firstChar;
}

//SubWord
void SubWord(uchar* word){
	for(int i = 0;i<4;i++){
		word[i] = SubBytes(word[i]);
	}
}
//Sub a state in each round
void SubState(uchar* state){
	for(int i = 0;i<16;i++){
		state[i] = SubBytes(state[i]);
	}
}

//ShiftRows
void ShiftRows(uchar* word){
	for(int i = 1;i<4;i++){
		for(int r = 0;r < i; r++)
			RotWordRow(word + i);
	}
}

//Word XOR
void WordXOR(uchar* word1, uchar* word2, uchar* res){
	for(int idx = 0; idx < 4; idx++) {
		res[idx] = word1[idx] ^ word2[idx];
	}
}

uchar* NumToWord(uint rcon){
	uchar* recon = malloc(sizeof(uchar) * 4);
	uint curr = rcon;
	for(int i=3;i>=0;i--){
		recon[i] = curr % (16 * 16);
		curr = curr / (16 * 16);
	}
	return recon;
}
//KeyExpansion
uchar* KeyExpansion(uchar* initKeys){
	uchar* roundKeys = malloc(sizeof(uchar) * 4 * 4 * 11);
	//Initialize
	for(int col = 0;col<4;col++){
		for(int row = 0;row<4;row++)
			roundKeys[col*4 + row] = initKeys[col*4 + row];
	}
	//Iteration
	uchar* prev = malloc(4 * sizeof(uchar));
	uchar* prev4 = malloc(4 * sizeof(uchar));
	uchar* result = malloc(4 * sizeof(uchar));
	for(int i=4;i<4*11;i++){
		for(int idx = 0;idx<4;idx++){
			prev[idx] = roundKeys[(i-1)*4 + idx];
			prev4[idx] = roundKeys[(i-4)*4 + idx];
		}
		if(i%4 == 0){
			RotWord(prev);
			SubWord(prev);
			WordXOR(prev,NumToWord(Rcon[i/4]),prev);
		}
		WordXOR(prev,prev4,result);
		for(int idx = 0;idx<4;idx++)
			roundKeys[i*4 + idx] = result[idx];
	}
	free(prev);
	free(prev4);
	free(result);
	return roundKeys;
}

//Multiply in GF(2^8)
/*uchar multiGF(uchar matVal,uchar msgVal){
	int matNum = matVal % 16;
	if(matNum == 1)
		return msgVal;
	uchar partialResult = msgVal << 1;
	uchar bitMask = 0x80;
	if(msgVal & bitMask){
		partialResult = partialResult ^ 0x1b;
	if(matNum == 2)
		return partialResult;
	return partialResult ^ msgVal;
	}
}*/

uchar multiGF(uchar a, uchar b) {
	uchar p = 0; /* the product of the multiplication */
	while (a && b) {
            if (b & 1) /* if b is odd, then add the corresponding a to p (final product = sum of all a's corresponding to odd b's) */
                p ^= a; /* since we're in GF(2^m), addition is an XOR */

            if (a & 0x80) /* GF modulo: if a >= 128, then it will overflow when shifted left, so reduce */
                a = (a << 1) ^ 0x11b; /* XOR with the primitive polynomial x^8 + x^4 + x^3 + x + 1 (0b1_0001_1011) – you can change it but it must be irreducible */
            else
                a <<= 1; /* equivalent to a*2 */
            b >>= 1; /* equivalent to b // 2 */
	}
	return p;
}
//MixColumns
void MixColumns(uchar* msg){
	for(int col = 0; col < 4; col++){
		uchar val0 = msg[col*4];
		uchar val1 = msg[col*4+1];
		uchar val2 = msg[col*4+2];
		uchar val3 = msg[col*4+3];
		msg[col*4] = multiGF(0x02,val0)^multiGF(0x03,val1)^val2^val3;
		msg[col*4+1] = val0^multiGF(0x02,val1)^multiGF(0x03,val2)^val3;
		msg[col*4+2] = val0^val1^multiGF(0x02,val2)^multiGF(0x03,val3);
		msg[col*4+3] = multiGF(0x03,val0)^val1^val2^multiGF(0x02,val3);
	}
}
//AddRoundKey
void AddRoundKey(uchar* msg, uchar* roundKeys, int i){
	uchar * roundKey = malloc(sizeof(uchar)*16);
	for(int col = 0;col<4; col++){
		for(int row = 0; row<4; row++){
			roundKey[col*4 + row] = roundKeys[(col+i*4)*4+row];
		}
	}
	for(int col = 0;col<4; col++){
		WordXOR(msg+col*4,roundKey+col*4,msg+col*4);
	}
}
/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
	for(int col = 0;col<4;col++){
		for(int row = 0;row<4;row++){
			key_ascii[col*4 + row] = col*4 + row;
		}
	}
	for(int row = 0;row<4;row++){
		uchar cur;
		switch(row){
		case 0: cur = 0xec;
			break;
		case 1: cur = 0xe2;
			break;
		case 2: cur = 0x98;
			break;
		case 3: cur = 0xdc;
		}
		for(int col = 0;col<4;col++){
			msg_ascii[col*4 + row] = cur;
		}
	}
	/*msg_enc = malloc(sizeof(msg_ascii));
	key = malloc(sizeof(key_ascii));
	memcpy(msg_ascii, msg_enc, sizeof(msg_ascii));
	memcpy(key_ascii, key, sizeof(key_ascii));*/
	uchar* roundKeys = KeyExpansion(key_ascii);
	printState(msg_ascii);
	AddRoundKey(msg_ascii,roundKeys,0);
	printState(msg_ascii);
	for(int i = 1;i<10;i++){
		printf("%d\n",i);
		SubState(msg_ascii);
		printf("After sub_bytes\n");
		printState(msg_ascii);
		ShiftRows(msg_ascii);
		printf("After shift_rows\n");
		printState(msg_ascii);
		MixColumns(msg_ascii);
		printf("After mix_columns\n");
		printState(msg_ascii);
		AddRoundKey(msg_ascii,roundKeys,i);
		printf("Round key\n");
		printState(msg_ascii);
	}
	printf("CheckPoint3\n");
	SubState(msg_ascii);
	printState(msg_ascii);
	ShiftRows(msg_ascii);
	printState(msg_ascii);
	AddRoundKey(msg_ascii,roundKeys,10);
	printf("Final State\n");
	printState(msg_ascii);
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking, 2 for self-testing: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else if (run_mode == 2){
		//Test SubBytes Lookup
		//printf("%x\n",SubBytes(0x4F));

		//Test RotWord
		/*
		uchar* word = malloc(4 * sizeof(uchar));
		word[0] = 0x01;
		word[1] = 0x02;
		word[2] = 0x03;
		word[3] = 0x04;
		for(int i = 0;i<4;i++)
			printf("%x",word[i]);
		printf("\n");
		RotWord(word);
		for(int i = 0;i<4;i++)
			printf("%x",word[i]);*/
		//Test RCon
		//printf("%x", RCon(1));
		//Test SubWord
		/*
		uchar* word = malloc(4 * sizeof(uchar));
		word[0] = 0xCF;
		word[1] = 0x4F;
		word[2] = 0x3C;
		word[3] = 0x09;
		for(int i = 0;i<4;i++)
			printf("%x",word[i]);
		printf("\n");
		SubWord(word);
		for(int i = 0;i<4;i++)
			printf("%x",word[i]);*/

		//Test KeyExpansion
		/*
		unsigned char test_key[33];
		for(int col = 0;col<4;col++){
			for(int row = 0;row<4;row++){
				test_key[col*4 + row] = col*4 + row;
			}
		}
		uchar* roundKeys = KeyExpansion(test_key);
		for(int i = 0;i<4;i++){
			for(int j = 0;j<44;j++){
				printf("%x ",roundKeys[j*4 + i]);
			}
			printf("\n");
		}
		*/
		//Test NumToWord
		//uchar* recon = NumToWord(0x01000000);

		//Test ShiftRows
		/*
		unsigned char test_msg[33];
		for(int col = 0;col<4;col++){
			for(int row = 0;row<4;row++){
				test_msg[col*4 + row] = col*4 + row;
			}
		}
		for(int col = 0;col<4;col++){
			for(int row = 0;row<4;row++){
				printf("%x ",test_msg[row*4 + col]);
			}
			printf("\n");
		}
		printf("\n");
		ShiftRows(test_msg);
		for(int col = 0;col<4;col++){
			for(int row = 0;row<4;row++){
				printf("%x ",test_msg[row*4 + col]);
			}
			printf("\n");
		}
		*/
		//Test multiGF
		//printf("%x\n",multiGF(0x03,0xd4));
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	/*
	int i = 0;
	for(i; i<16;i++){
		AES_PTR[i] = 0xDEADBEEF;
		if(AES_PTR[i] != 0xDEADBEEF)
			printf("Error!,%d\n",i);
		else
			printf("ok!");
		AES_PTR[i] = 0xFFFFFFFF;
	}
	*/
	return 0;
}
