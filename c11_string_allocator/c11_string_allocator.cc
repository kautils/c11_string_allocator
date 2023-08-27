
#include "c11_string_allocator.h"
#include <string>
#include <string.h>


uint64_t c11_string_current_pos(void * ptr_of_c11_string){ return reinterpret_cast<std::string*>(ptr_of_c11_string)->size(); }
void * c11_string_register(void * ptr_of_c11_string,uint64_t pos,const void * data){
    auto arr=reinterpret_cast<std::string*>(ptr_of_c11_string);
    if(arr->size() < pos+sizeof(uint64_t)) arr->resize(sizeof(uintptr_t) + arr->size());
    auto ptr = const_cast<char*>(arr->data()+pos);
    memcpy((char *)ptr,&data,sizeof(uintptr_t));
    return ptr;
}

void * c11_string_pointer(void * ptr_of_c11_string,uint64_t pos){
    auto arr=reinterpret_cast<std::string*>(ptr_of_c11_string);
    if(arr->size() < pos+sizeof(uint64_t)) return nullptr; 
    auto ptr = const_cast<char*>(arr->data()+pos);
    return *reinterpret_cast<void **>(ptr);
}


int tmain_kautil_c11_string_allocator_static(){

    auto alloc = std::string{};
    auto pos_null = c11_string_current_pos(&alloc);
    auto null = c11_string_register(&alloc,pos_null, nullptr);
    auto pos_intptr = c11_string_current_pos(&alloc);
    auto intptr = c11_string_register(&alloc,pos_intptr, new int(100));
    
    printf("%s\n",reinterpret_cast<void*>(c11_string_pointer(&alloc,pos_null)));
    printf("%d\n",*reinterpret_cast<int*>(c11_string_pointer(&alloc,pos_intptr)));
    delete reinterpret_cast<int*>(c11_string_pointer(&alloc,pos_intptr));
    
    return 0;
}