//void _AES_128_Key_Expansion(const unsigned char* userkey,
//				unsigned char* key_schedule)

#.align 16,0x90
.globl _AES_128_Key_Expansion
_AES_128_Key_Expansion:
# parameter 1: %rdi
# parameter 2: %rsi
	movl      $10, 240(%rsi)
	movdqu    (%rdi), %xmm1
	movdqa    %xmm1, (%rsi)

ASSISTS:
	aeskeygenassist $1, %xmm1, %xmm2
	call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 16(%rsi)
	aeskeygenassist $2, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 32(%rsi)
    aeskeygenassist $4, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 48(%rsi)
    aeskeygenassist $8, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 64(%rsi)
    aeskeygenassist $16, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 80(%rsi)
    aeskeygenassist $32, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 96(%rsi)
    aeskeygenassist $64, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 112(%rsi)
    aeskeygenassist $0x80, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 128(%rsi)
    aeskeygenassist $0x1b, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 144(%rsi)
    aeskeygenassist $0x36, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
	movdqa %xmm1, 160(%rsi)
	ret

PREPARE_ROUNDKEY_128:
	pshufd $255, %xmm2, %xmm2
	movdqa %xmm1, %xmm3
	pslldq $4, %xmm3
	pxor %xmm3, %xmm1
	pslldq $4, %xmm3
	pxor %xmm3, %xmm1
	pslldq $4, %xmm3
	pxor %xmm3, %xmm1
	pxor %xmm2, %xmm1
	ret

//void _AES_192_Key_Expansion (const unsigned char *userkey, unsigned char *key)

.globl _AES_192_Key_Expansion
_AES_192_Key_Expansion:
# parameter 1: %rdi
# parameter 2: %rsi

	movdqu (%rdi), %xmm1
	movdqu 16(%rdi), %xmm3
	movdqa %xmm1, (%rsi)
	movdqa %xmm3, %xmm5
	
	aeskeygenassist $0x1, %xmm3, %xmm2
	call PREPARE_ROUNDKEY_192
	shufpd $0, %xmm1, %xmm5
	movdqa %xmm5, 16(%rsi)
	movdqa %xmm1, %xmm6
	shufpd $1, %xmm3, %xmm6
	movdqa %xmm6, 32(%rsi)
	
	aeskeygenassist $0x2, %xmm3, %xmm2
	call PREPARE_ROUNDKEY_192
	movdqa %xmm1, 48(%rsi)
	movdqa %xmm3, %xmm5
	
	aeskeygenassist $0x4, %xmm3, %xmm2
	call PREPARE_ROUNDKEY_192
	shufpd $0, %xmm1, %xmm5
	movdqa %xmm5, 64(%rsi)
	movdqa %xmm1, %xmm6
	shufpd $1, %xmm3, %xmm6
	movdqa %xmm6, 80(%rsi)
	
	aeskeygenassist $0x8, %xmm3, %xmm2
	call PREPARE_ROUNDKEY_192
	movdqa %xmm1, 96(%rsi)
	movdqa %xmm3, %xmm5
	
	aeskeygenassist $0x10, %xmm3, %xmm2
	call PREPARE_ROUNDKEY_192
	shufpd $0, %xmm1, %xmm5
	movdqa %xmm5, 112(%rsi)
	movdqa %xmm1, %xmm6
	shufpd $1, %xmm3, %xmm6
	movdqa %xmm6, 128(%rsi)
	
	aeskeygenassist $0x20, %xmm3, %xmm2
	call PREPARE_ROUNDKEY_192
	movdqa %xmm1, 144(%rsi)
	movdqa %xmm3, %xmm5

	aeskeygenassist $0x40, %xmm3, %xmm2
	call PREPARE_ROUNDKEY_192
	shufpd $0, %xmm1, %xmm5
	movdqa %xmm5, 160(%rsi)
	movdqa %xmm1, %xmm6
	shufpd $1, %xmm3, %xmm6
	movdqa %xmm6, 176(%rsi)
	
	aeskeygenassist $0x80, %xmm3, %xmm2
	call PREPARE_ROUNDKEY_192
	movdqa %xmm1, 192(%rsi)
	ret

PREPARE_ROUNDKEY_192:
	pshufd $0x55, %xmm2, %xmm2
	movdqu %xmm1, %xmm4
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm1
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm1
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm1
	pxor   %xmm2, %xmm1
	pshufd $0xff, %xmm1, %xmm2
	movdqu %xmm3, %xmm4
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm3
	pxor   %xmm2, %xmm3
	ret

//void _AES_256_Key_Expansion (const unsigned char *userkey, unsigned char *key)
.globl _AES_256_Key_Expansion
_AES_256_Key_Expansion:
# parameter 1: %rdi
# parameter 2: %rsi

	movdqu (%rdi), %xmm1
	movdqu 16(%rdi), %xmm3
	movdqa %xmm1, (%rsi)
	movdqa %xmm3, 16(%rsi)
	
	aeskeygenassist $0x1, %xmm3, %xmm2
	call MAKE_RK256_a
	movdqa %xmm1, 32(%rsi)
	aeskeygenassist $0x0, %xmm1, %xmm2
	call MAKE_RK256_b
	movdqa %xmm3, 48(%rsi)
	aeskeygenassist $0x2, %xmm3, %xmm2
	call MAKE_RK256_a
	movdqa %xmm1, 64(%rsi)
	aeskeygenassist $0x0, %xmm1, %xmm2
	call MAKE_RK256_b
	movdqa %xmm3, 80(%rsi)
	aeskeygenassist $0x4, %xmm3, %xmm2
	call MAKE_RK256_a
	movdqa %xmm1, 96(%rsi)
	aeskeygenassist $0x0, %xmm1, %xmm2
	call MAKE_RK256_b
	movdqa %xmm3, 112(%rsi)
	aeskeygenassist $0x8, %xmm3, %xmm2
	call MAKE_RK256_a
	movdqa %xmm1, 128(%rsi)
	aeskeygenassist $0x0, %xmm1, %xmm2
	call MAKE_RK256_b
	movdqa %xmm3, 144(%rsi)
	aeskeygenassist $0x10, %xmm3, %xmm2
	call MAKE_RK256_a
	movdqa %xmm1, 160(%rsi)
	aeskeygenassist $0x0, %xmm1, %xmm2
	call MAKE_RK256_b
	movdqa %xmm3, 176(%rsi)
	aeskeygenassist $0x20, %xmm3, %xmm2
	call MAKE_RK256_a
	movdqa %xmm1, 192(%rsi)
	aeskeygenassist $0x0, %xmm1, %xmm2
	call MAKE_RK256_b
	movdqa %xmm3, 208(%rsi)
	aeskeygenassist $0x40, %xmm3, %xmm2
	call MAKE_RK256_a
	movdqa %xmm1, 224(%rsi)
	ret

MAKE_RK256_a:
	pshufd $0xff, %xmm2, %xmm2
	movdqa %xmm1, %xmm4
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm1
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm1
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm1
	pxor   %xmm2, %xmm1
	ret

MAKE_RK256_b:
	pshufd $0xaa, %xmm2, %xmm2
	movdqa %xmm3, %xmm4
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm3
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm3
	pslldq $4, %xmm4
	pxor   %xmm4, %xmm3
	pxor   %xmm2, %xmm3
	ret
