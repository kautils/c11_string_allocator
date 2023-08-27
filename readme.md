

### c11_string_allocator
* manage memory using std::string and offset
* this is used when conceal types in some library for example sqlite3

### example 

```c++
#include "c11_string_allocator.h"
int main(){

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

```