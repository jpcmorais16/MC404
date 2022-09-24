#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

typedef struct
{
    unsigned char e_ident[16];  // Magic number and other info
    unsigned short e_type;      // Object file type
    unsigned short e_machine;   // Architecture
    unsigned int e_version;     // Object file version
    unsigned int e_entry;       // Entry point virtual address
    unsigned int e_phoff;       // Program header table file offset
    unsigned int e_shoff;       // Section header table file offset
    unsigned int e_flags;       // Processor-specific flags
    unsigned short e_ehsize;    // ELF header size in bytes
    unsigned short e_phentsize; // Program header table entry size
    unsigned short e_phnum;     // Program header table entry count
    unsigned short e_shentsize; // Section header table entry size
    unsigned short e_shnum;     // Section header table entry count
    unsigned short e_shstrndx;  // Section header string table index
} Elf32_Ehdr;

typedef struct
{
    unsigned int sh_name;      // Section name (string tbl index)
    unsigned int sh_type;      // Section type
    unsigned int sh_flags;     // Section flags
    unsigned int sh_addr;      // Section virtual addr at execution
    unsigned int sh_offset;    // Section file offset
    unsigned int sh_size;      // Section size in bytes
    unsigned int sh_link;      // Link to another section
    unsigned int sh_info;      // Additional section information
    unsigned int sh_addralign; // Section alignment
    unsigned int sh_entsize;   // Entry size if section holds table
} Elf32_Shdr;

typedef struct
{
    unsigned int st_name;  // Symbol name (string tbl index)
    unsigned int st_value; // Symbol value
    unsigned int st_size;  // Symbol size
    unsigned char st_info; // Symbol type and binding
    unsigned char st_other;
    unsigned short st_shndx; // Section index
} Elf32_Sym;


int main( int argc, char *argv[ ]){

   

    unsigned char elf[100000];

    int fd = open( argv[2] , O_RDONLY);
    Elf32_Ehdr *header;

    read(fd, elf, 100000);
    header = (Elf32_Ehdr *) &elf;

    //printf("%s\n", (char*) &header->e_shoff);
    printf("%ld\n", header->e_shoff);

    int PosicaoHeaderShstrtab = header->e_shstrndx * 40 + header->e_shoff;
    //printf("%d\n", HeaderShstrtab);

    Elf32_Shdr *HeaderShstrtab = (Elf32_Shdr *) &(*(elf + PosicaoHeaderShstrtab));

    printf("%d\n", HeaderShstrtab->sh_offset);

    //printf("%d\n", header->e_entry);
    
}



