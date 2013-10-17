/* Tiago de Almeida
 * tiago@almeida.inf.br
 *
 * Library of useful macros.
 */

/* Used for error messages. Sends the message to stderr. */
#define error(msg, ...)\
do{\
	fprintf(stderr, "Error: " msg "\n", ##__VA_ARGS__);\
	fflush(stderr);\
} while(0)

/* Macro used for verbose messages. Sends the message to stdout. */
#define verbose(msg, ...)\
do{\
	fprintf(stdout, " - " msg "\n", ##__VA_ARGS__);\
	fflush(stdout);\
} while(0)

/* Debugging macro */
#define db_line()\
	do { fprintf(stderr, "line %d\n", __LINE__); fflush(stderr); } while(0)

/* Typed allocation */
#define talloc(ty, sz) (ty*)malloc((sz)*sizeof(ty))

/* Expression expectation */
#define LIKELY(exp) (__builtin_expect((exp), 1))
#define UNLIKELY(exp) (__builtin_expect((exp), 0))

/* Atomic operations */
#define atomic_add(var, n)\
        __sync_add_and_fetch(&(var), n)

#define atomic_sub(var, n)\
        __sync_sub_and_fetch(&(var), n)

#define atomic_inc(var)\
	__sync_add_and_fetch(&(var), 1)

#define atomic_dec(var)\
	__sync_sub_and_fetch(&(var), 1)

#define atomic_set(var, n)\
	__sync_lock_test_and_set(&(var), n)

#define CAS(where, old, new)\
	__sync_bool_compare_and_swap(where, old, new)
