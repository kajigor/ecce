struct worker *free_wam(void);
BOOL program_usage(Argdecl);
BOOL internal_symbol_usage(Argdecl);
BOOL statistics(Argdecl);
BOOL total_usage(Argdecl);
TAGGED *checkalloc(int size);
TAGGED *checkrealloc(TAGGED *ptr, int decr, int size);
struct worker *create_wam_storage(void);
void checkdealloc(TAGGED *ptr, int decr);
void create_wam_areas(Argdecl);
void init_alloc(void);
extern ENG_INT total_mem_count;
extern ENG_INT num_of_predicates;
void release_wam(Argdecl);
