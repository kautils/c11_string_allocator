#ifndef KAUTIL_C11_STRING_ALLOCATOR_C11_STRING_ALLOCATOR_H
#define KAUTIL_C11_STRING_ALLOCATOR_C11_STRING_ALLOCATOR_H

#include <stdint.h>
uint64_t c11_string_current_pos(void * ptr_of_c11_string);
void * c11_string_register(void * ptr_of_c11_string,uint64_t pos,const void * data);
void * c11_string_pointer(void * ptr_of_c11_string,uint64_t pos);

#endif