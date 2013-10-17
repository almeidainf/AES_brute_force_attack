#include <stdint.h>
#include <stdio.h>
#include <wmmintrin.h>
#include <pthread.h>
#include <string.h>

#include "almeidamacros.h"

#define KEYLEN 128

#ifndef TOTAL_LENGTH
#define TOTAL_LENGTH 32
#endif

#ifndef LENGTH
#define LENGTH 32
#endif

#ifndef NTHREADS
#define NTHREADS 8
#endif

typedef struct KEY_SCHEDULE{
        unsigned char KEY[16*15];
	unsigned int nr;
}AES_KEY;

uint8_t PARTIAL_KEY[] = {0x4b, 0x65, 0x79, 0x32, 0x47, 0x72, 0x6f, 0x75, 0x70, 0x30, 0x39};
uint8_t *cipher_text;

// Check for a readable ascii text
inline int analyse(uint8_t *text){
	int i;
	for(i=0; i<LENGTH; i++){
		if(text[i] == 0)
			continue;
		if(text[i] < 32 || text[i] > 126)
			return 0;
	}
	return 1;
}

int decrypt(AES_KEY *key, uint8_t *previous_text){
	
	uint8_t *remaining_cipher_text = talloc(uint8_t, TOTAL_LENGTH - LENGTH);
	uint8_t *decrypted_text = talloc(uint8_t, TOTAL_LENGTH + 1);
	
	int i;
	for(i=0; i<TOTAL_LENGTH - LENGTH; i++)
		fscanf(stdin, "%02x", &remaining_cipher_text[i]);
	
	memcpy(decrypted_text, previous_text, LENGTH);

	AES_ECB_decrypt(remaining_cipher_text, &decrypted_text[LENGTH], TOTAL_LENGTH - LENGTH, key->KEY, key->nr);

	decrypted_text[TOTAL_LENGTH] = '\0';
	verbose("Decrypted text:\n\t%s", decrypted_text);
}

void *thread_function(void *index){
	// Thread index
	int tindex = *(int*)index;

	// Key and indexes
	AES_KEY key;
	uint8_t local_key[16];
	int i, i1, i2, i3, i4, i5;

	// Allocating text memory
	uint8_t *decrypted_text = talloc(uint8_t, LENGTH);

	// Defining cipher text and base key
	memcpy(local_key, PARTIAL_KEY, 11);

	// Defining indexes for this thread
	int begin, end;
	if(tindex == 0) begin = 33;
	else begin = 33 + (tindex * (94/NTHREADS)) + 3;
	if(tindex == NTHREADS-1) end = 126;
	else end = 33 + ((tindex+1) * (94/NTHREADS) + 2);

	// Verbosing about the range
	verbose("Thread #%d running in the range %d..%d.", tindex, begin, end);

	// Brute force
	for(i1=begin; i1<=end; i1++){
		local_key[11] = i1;
		for(i2=33; i2<=126; i2++){
			local_key[12] = i2;
			for(i3=33; i3<=126; i3++){
				local_key[13] = i3;
				for(i4=33; i4<=126; i4++){
					local_key[14] = i4;
					for(i5=33; i5<=126; i5++){
						local_key[15] = i5;
						AES_set_decrypt_key(local_key, KEYLEN, &key);
						AES_ECB_decrypt(cipher_text, decrypted_text, LENGTH, key.KEY, key.nr);
						if(analyse(decrypted_text)){
							verbose("Decrypted!");
							verbose("Thread #%d found the key.", tindex);
							printf(" - Key: ");
							for(i=0; i<KEYLEN/8; i++)
								printf("%c", local_key[i]);
							printf("\n");

							decrypt(&key, decrypted_text);
							exit(1);
						}
					}
				}
			}
		}
	}

	verbose("Thread #%d is done.", tindex);

	return;
}

int main(){

	int i, j;
	pthread_t *threads;
	int *thread_index;
	char dummy;

	// Checking CPU support
	if (!Check_CPU_support_AES()){
		verbose("Cpu does not support AES instruction set. Bailing out."); return 1;
	}
	verbose("CPU support AES instruction set.");

	// Reading input
	cipher_text = talloc(uint8_t, LENGTH);
	for(i=0; i<LENGTH; i++)
		fscanf(stdin, "%02x", &cipher_text[i]);
	
	// Printing input
	printf(" - Input: ");
	for(i=0; i< LENGTH; i++)
		printf("%02x", cipher_text[i]);
	printf("\n");

	// Allocating thread indexes
	threads = talloc(pthread_t, NTHREADS);
	thread_index = talloc(int, NTHREADS);

	// Creating threads
	for(i=0; i< NTHREADS; i++){
		thread_index[i] = i;
		if(pthread_create(&threads[i], NULL, &thread_function, &thread_index[i]))
			error("Creation of thread #%d failed.", i);
		else
			verbose("Thread #%d created successfully.", i);
	}
	
	// Waiting for threads
	for(i=0; i< NTHREADS; i++)
		pthread_join(threads[i], NULL);
	verbose("All threads are done.");

	return 1;
}
