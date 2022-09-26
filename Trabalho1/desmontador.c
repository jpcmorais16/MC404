#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

unsigned char ResultadoConversao[100];
unsigned char ResultadoIntStr[100];
unsigned char ListaRotulos[100][2][100];
unsigned char ResultadoOrdenacao[100][2][100];

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


int TamanhoString(unsigned char *str){

    int tamanho = 0;
    while(str[tamanho] != '\0') tamanho += 1;

    return tamanho;

}



int min(int n1, int n2){

	if(n1 <= n2) return n1;

	return n2;

}

int StrComp(unsigned char *str1, unsigned char *str2){

	int tamanho1 = 0;
	int tamanho2 = 0;

	while(str1[tamanho1] != '\0') tamanho1 += 1;
	while(str2[tamanho2] != '\0') tamanho2 += 1;

	for(int i=0; i < min(tamanho1, tamanho2); i++){

		if(str1[i] < str2[i]) return -1;

        if(str1[i] > str2[i]) return 1;


	}

	return 0;

}

void InverteString(char *str){

    int tamanho = 0;
    while(str[tamanho] != '\0') tamanho += 1;

    for(int i=0 ; i < tamanho; i++){

        ResultadoConversao[i] = str[tamanho - i - 1];
        
    }

    ResultadoConversao[tamanho] = '\0';

}

void OrdenaPorPosicao(unsigned char Lista[100][2][100], int TamanhoLista){

	

    for(int i=0; i < TamanhoLista; i++){

		int indiceMenor = 0;

		for(int j=0; j < TamanhoLista; j++){


        for(int k=0; k < 8; k++){


          if(Lista[j][0][k] < Lista[indiceMenor][0][k]){

            indiceMenor = j;
            break;
            
          }

          if(Lista[j][0][k] > Lista[indiceMenor][0][k]){

            break;
            
          }
        
      }
    }


		for(int k = 0; k < TamanhoString(Lista[indiceMenor][0]); k++){

			ResultadoOrdenacao[i][0][k] = Lista[indiceMenor][0][k];

		}


		for(int k = 0; k < TamanhoString(Lista[indiceMenor][1]); k++){

			ResultadoOrdenacao[i][1][k] = Lista[indiceMenor][1][k];

		}

		Lista[indiceMenor][0][0] = 'g';


	}


}

void DecHex(int entrada) {

  int it = 0;
  int dividendo = entrada;
  char resultado[100];

  while (dividendo != 0) {

    int resto = dividendo % 16;

    if (resto > 9) {
      switch (resto) {

      case (10):
        resultado[it] = 'a';
        break;
      case (11):
        resultado[it] = 'b';
        break;
      case (12):
        resultado[it] = 'c';
        break;
      case (13):
        resultado[it] = 'd';
        break;
      case (14):
        resultado[it] = 'e';
        break;
      case (15):
        resultado[it] = 'f';
        break;
      default:
        break;
      }

    } else {

      resultado[it] = resto + 48;
    }

    dividendo = dividendo / 16;
    it += 1;
  }

    while(it < 8){
        resultado[it] = '0';
        it += 1;
    }

  resultado[it] = '\0';
  InverteString(resultado);

}

int StringsIguais(char *str1, unsigned char *str2){

    int tamanho = 0;

    while(str1[tamanho] != '\0') tamanho += 1;

    for(int i = 0; i < tamanho; i++){

        if(str1[i] != str2[i]) return 0;
 
    }
    return 1;


}


int main( int argc, char *argv[ ]){

   
    


    unsigned char elf[1000000];

    int fd = open( argv[2] , O_RDONLY);
    Elf32_Ehdr *header;

    read(fd, elf, 100000);
    header = (Elf32_Ehdr *) &elf;

    int PosicaoHeaderShstrtab = header->e_shstrndx * 40 + header->e_shoff;


    Elf32_Shdr *HeaderShstrtab = (Elf32_Shdr *) &(*(elf + PosicaoHeaderShstrtab));

    Elf32_Shdr *SymtabHeader = NULL;
    Elf32_Shdr *StrtabHeader = NULL;
    Elf32_Shdr * TextHeader = NULL;
    
    for(int i = 0; i < header->e_shnum; i++){

        Elf32_Shdr *HeaderAtual = (Elf32_Shdr *) &(*(elf + header->e_shoff + 40*i));
        
        

        
        if(StringsIguais("symtab", (elf + 1 + HeaderShstrtab->sh_offset + HeaderAtual->sh_name))){

            SymtabHeader = HeaderAtual;
            

        }

        if(StringsIguais("strtab", (elf + 1 + HeaderShstrtab->sh_offset + HeaderAtual->sh_name))){

            StrtabHeader = HeaderAtual;
            

        }

        if(StringsIguais("text", (elf + 1 + HeaderShstrtab->sh_offset + HeaderAtual->sh_name))){

            TextHeader = HeaderAtual;
            

        }

    }

    Elf32_Sym *SymbolsList[100];
       
    for(int i=0; i < SymtabHeader->sh_size; i += 16){

        SymbolsList[i/16] = (Elf32_Sym *) (elf + SymtabHeader->sh_offset + i);

    }

    int TamanhoLista = 0;

    for(int i=0; i < SymtabHeader->sh_size; i += 16){

      DecHex(SymbolsList[i/16]->st_value);

      for(int j = 0; j < 8; j++){

        ListaRotulos[i/16][0][j] = ResultadoConversao[j];

        
        ListaRotulos[i/16][1][j] = (elf + SymbolsList[i/16]->st_name + StrtabHeader->sh_offset)[j];

		TamanhoLista += 1;
      }

      
    }

	OrdenaPorPosicao(ListaRotulos, TamanhoLista);


	


    write(1, "\n", 1);
    write(1, "test-01.x:	file format elf32-littleriscv", 40);
    write(1, "\n\n", 2);


    if(argv[1][1] == 't'){

           

        for(int i = 1; i < SymtabHeader->sh_size/16; i++){


            DecHex(SymbolsList[i]->st_value);

            char coluna2[1];
            coluna2[0] = 'l';
            if(SymbolsList[i]->st_info >> 4 == 1) coluna2[0] = 'g';

            
           
            
            write(1, ResultadoConversao, TamanhoString(ResultadoConversao));
            write(1, " ", 1);

            write(1, coluna2, 1);
            write(1, " ", 1);

            write(1, (elf + SymbolsList[i]->st_shndx + HeaderShstrtab->sh_offset), TamanhoString((elf + SymbolsList[i]->st_shndx + HeaderShstrtab->sh_offset)));
            write(1, " ", 1);

            DecHex(SymbolsList[i]->st_size);
            write(1, ResultadoConversao, TamanhoString(ResultadoConversao));
            write(1, " ", 1);

            write(1, (elf + SymbolsList[i]->st_name + StrtabHeader->sh_offset), TamanhoString((elf + SymbolsList[i]->st_name + StrtabHeader->sh_offset)));
            write(1, "\n", 1);

           
          
            

        }
       
    }

    else if(argv[1][1] == 'h'){

        //cada header tem 0x28 bytes

        write(1, "Sections:\n", 10);
        write(1, "Idx Name Size VMA Type\n", 23);


        for(int i=0; i < header->e_shnum; i++){
            
            Elf32_Shdr *HeaderAtual = (Elf32_Shdr *) (elf + header->e_shoff + 40 * i);
            char indice[2];
            indice[0] = i + 48;
            indice[1] = ' ';


            write(1, indice, 2);
            write(1, (elf + HeaderShstrtab->sh_offset + HeaderAtual->sh_name),
                  TamanhoString(elf + HeaderShstrtab->sh_offset + HeaderAtual->sh_name));

            DecHex(HeaderAtual->sh_size);
            write(1, " ", 1);
            write(1, ResultadoConversao, TamanhoString(ResultadoConversao));

            DecHex(HeaderAtual->sh_addr);
            write(1, " ", 1);
            write(1, ResultadoConversao, TamanhoString(ResultadoConversao));
         
            write(1, "\n", 1);
        }

    }

    else if(argv[1][1] == 'd'){

        for(int i=1; i < TamanhoLista; i++){
			DecHex(TextHeader->sh_offset);

          if(StrComp(ResultadoOrdenacao[i][0], ResultadoConversao) >= 0){

				write(1, ResultadoOrdenacao[i][0], TamanhoString(ResultadoOrdenacao[i][0]));
				write(1, " ", 1);

				write(1, ResultadoOrdenacao[i][1], TamanhoString(ResultadoOrdenacao[i][1]));
				write(1, "\n", 1);
				
          }
		  


        }

        
    }

    
    
}



