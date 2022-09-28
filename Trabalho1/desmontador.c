#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

unsigned char ResultadoConversao[100];
unsigned char ResultadoIntStr[100];
unsigned char ResultadoRemocao[100];
unsigned char ResultadoConversaoHexDec[100];
unsigned char Instrucao[100];
unsigned char BinarioParcial[100];
unsigned char Binario[100];
unsigned int TamanhoAtualBinario = 0;

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

typedef struct{

	unsigned char str1[100];
	unsigned char str2[100];
	unsigned int n1;



} Lista;

Lista ListaRotulos[1000];
Lista ResultadoOrdenacao[1000];

int pot(int n, int potencia){


	int resultado = 1;
	
	for(int i=0 ; i < potencia; i++){

		resultado = resultado * n;

	}
	return resultado;


}


int TamanhoString(unsigned char *str){

    int tamanho = 0;
    while(str[tamanho] != '\0') tamanho += 1;

    return tamanho;

}



int min(int n1, int n2){

	if(n1 <= n2) return n1;

	return n2;

}

int max(int n1, int n2){

	if(n1 >= n2) return n1;

	return n2;

}

int StrComp(unsigned char *str1, unsigned char *str2){

	int tamanho1 = 0;
	int tamanho2 = 0;

	while(str1[tamanho1] != '\0') tamanho1 += 1;
	while(str2[tamanho2] != '\0') tamanho2 += 1;

	for(int i=0; i < max(min(tamanho1, tamanho2), 1); i++){

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

void OrdenaPorPosicao(Lista Lista[1000], int TamanhoLista){

	

    for(int i=0; i < TamanhoLista; i++){

		int indiceMenor = 0;

		for(int j=0; j < TamanhoLista; j++){


        for(int k=0; k < 8; k++){


          if(Lista[j].str1[k] < Lista[indiceMenor].str1[k]){

            indiceMenor = j;
            break;
            
          }

          if(Lista[j].str1[k] > Lista[indiceMenor].str1[k]){

            break;
            
          }
        
      }
    }


		for(int k = 0; k < TamanhoString(Lista[indiceMenor].str1); k++){

			ResultadoOrdenacao[i].str1[k] = Lista[indiceMenor].str1[k];

		}
		ResultadoOrdenacao[i].str1[TamanhoString(Lista[indiceMenor].str1)] = '\0';


		for(int k = 0; k < TamanhoString(Lista[indiceMenor].str2); k++){

			ResultadoOrdenacao[i].str2[k] = Lista[indiceMenor].str2[k];

		}
		ResultadoOrdenacao[i].str2[TamanhoString(Lista[indiceMenor].str2)] = '\0';

		ResultadoOrdenacao[i].n1 = Lista[indiceMenor].n1;
		
		

		Lista[indiceMenor].str1[0] = 'g';


	}


}

int HexDec(unsigned char *entrada){

	int tamanho = TamanhoString(entrada);
	int resultado = 0;

	for(int i=0; i < tamanho; i++){

		if(entrada[i] >= 'a' && entrada[i] <= 'g'){

			//char - 87
			resultado += (entrada[i] - 87) * pot(16, tamanho - i - 1);

		}

		else{

			resultado += (entrada[i] - 48) * pot(16, tamanho - i - 1);


		}
		
	}
	return resultado;


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

void RemoveZerosDaFrente(unsigned char *string){

	int tamanho = TamanhoString(string);
	int gatilho = 0;
	int defasagem;

	for(int i=0 ; i < tamanho; i++){

		if((gatilho == 0 && (string[i] != '0' || i == tamanho - 2))){
			gatilho = 1;
			defasagem = i;
			//printf("\nDEFASAGEM: %d\n", defasagem);
		} 

		if(gatilho == 1) ResultadoRemocao[i - defasagem] = string[i];

	}
	ResultadoRemocao[tamanho - defasagem] = '\0';

}

int StringsIguais(char *str1, unsigned char *str2){

    int tamanho = 0;

    while(str1[tamanho] != '\0') tamanho += 1;

    for(int i = 0; i < tamanho; i++){

        if(str1[i] != str2[i]) return 0;
 
    }
    return 1;


}

int SizedStrComp(char *str1, unsigned char *str2, int begin, int size){

	
	for(int i= begin; i < begin + size + 1; i ++){
		//printf("\n%c %c\n", str1[i], str2[i]);

		if(str1[i] < str2[i]) {//printf("FIM\n");
		 return -1;}

        if(str1[i] > str2[i]) {//printf("FIM\n");
		return 1;}

	}
	
	return 0;

}



void AdicionaAoBinario(char *entrada){


	for(int i = 0; i < 4; i ++)
		Binario[TamanhoAtualBinario + i] = entrada[i];

	
	TamanhoAtualBinario += 4;

}

void HexBin(unsigned char *hexa){

	TamanhoAtualBinario = 0;

	for(int i = 0; i < 32; i += 4){

		switch(hexa[i/4]){

			case 'f': AdicionaAoBinario("1111"); break;
			case 'e': AdicionaAoBinario("1110"); break;
			case 'd': AdicionaAoBinario("1101"); break;
			case 'c': AdicionaAoBinario("1100"); break;
			case 'b': AdicionaAoBinario("1011"); break;
			case 'a': AdicionaAoBinario("1010"); break;
			case '9': AdicionaAoBinario("1001"); break;
			case '8': AdicionaAoBinario("1000"); break;
			case '7': AdicionaAoBinario("0111"); break;
			case '6': AdicionaAoBinario("0110"); break;
			case '5': AdicionaAoBinario("0101"); break;
			case '4': AdicionaAoBinario("0100"); break;
			case '3': AdicionaAoBinario("0011"); break;
			case '2': AdicionaAoBinario("0010"); break;
			case '1': AdicionaAoBinario("0001"); break;
			case '0': AdicionaAoBinario("0000"); break;
			default: break;

		}
	}
}

void CopiaInstrucao(char *instr){

	int tamanho = TamanhoString((unsigned char *) instr);

	for(int i=0; i < tamanho; i++){
		Instrucao[i] = instr[i];
	}
}


void DescobreInstrucao(unsigned char *elf, unsigned int offset){


	unsigned char hexa[100];
	for(int i = 0; i < 8; i += 2){

		DecHex(*(elf + offset + i/2));
		//printf("\n Resultado: %s\n", ResultadoConversao);

		hexa[i] = ResultadoConversao[6];
		hexa[i + 1] = ResultadoConversao[7];
	}
	hexa[8] = '\0';

	HexBin(hexa);
	//printf("Binario: %s\n", Binario);

	//printf("\nAQUI\n");
	//SizedStrComp("1111011\n", Binario, 0, 7);

	if(SizedStrComp("1110110", Binario, 1, 7) == 0) CopiaInstrucao("lui");
	else if(SizedStrComp("1110100", Binario, 0, 7) == 0) CopiaInstrucao("auipc");
	else if(SizedStrComp("1111011", Binario, 0, 7) == 0) CopiaInstrucao("jal");
	else if(SizedStrComp("1110011", Binario, 0, 7) == 0) {CopiaInstrucao("jalr");}

	else if(SizedStrComp("1110110", Binario, 0, 7) == 0) {

		if(SizedStrComp("000", Binario, 12, 3) == 0) CopiaInstrucao("beq");
		if(SizedStrComp("100", Binario, 12, 3) == 0) CopiaInstrucao("bne");
		if(SizedStrComp("001", Binario, 12, 3) == 0) CopiaInstrucao("blt");
		if(SizedStrComp("101", Binario, 12, 3) == 0) CopiaInstrucao("bge");
		if(SizedStrComp("011", Binario, 12, 3) == 0) CopiaInstrucao("bltu");
		if(SizedStrComp("111", Binario, 12, 3) == 0) CopiaInstrucao("bgeu");

	}

	else if(SizedStrComp("1100000", Binario, 0, 7) == 0){

		if(SizedStrComp("000", Binario, 12, 3) == 0) CopiaInstrucao("lb");
		if(SizedStrComp("100", Binario, 12, 3) == 0) CopiaInstrucao("lh");
		if(SizedStrComp("010", Binario, 12, 3) == 0) CopiaInstrucao("lw");
		if(SizedStrComp("001", Binario, 12, 3) == 0) CopiaInstrucao("lbu");
		if(SizedStrComp("101", Binario, 12, 3) == 0) CopiaInstrucao("lhu");

	}

	else if(SizedStrComp("1100010", Binario, 0, 7) == 0){
		
		if(SizedStrComp("000", Binario, 12, 3) == 0) CopiaInstrucao("sb");
		if(SizedStrComp("100", Binario, 12, 3) == 0) CopiaInstrucao("sh");
		if(SizedStrComp("010", Binario, 12, 3) == 0) CopiaInstrucao("sw");

	}

	else if(SizedStrComp("1100100", Binario, 0, 7) == 0){

		if(SizedStrComp("000", Binario, 12, 3) == 0) CopiaInstrucao("addi");
		if(SizedStrComp("010", Binario, 12, 3) == 0) CopiaInstrucao("slti");
		if(SizedStrComp("110", Binario, 12, 3) == 0) CopiaInstrucao("sltiu");
		if(SizedStrComp("001", Binario, 12, 3) == 0) CopiaInstrucao("xori");
		if(SizedStrComp("011", Binario, 12, 3) == 0) CopiaInstrucao("ori");
		if(SizedStrComp("111", Binario, 12, 3) == 0) CopiaInstrucao("andi");
		if(SizedStrComp("100", Binario, 12, 3) == 0) CopiaInstrucao("slli");

		if(SizedStrComp("101", Binario, 12, 3) == 0){

			if(SizedStrComp("0000000", Binario, 25, 7) == 0) CopiaInstrucao("srli");
			if(SizedStrComp("0000010", Binario, 25, 7) == 0) CopiaInstrucao("srai");
		
		}
		
	}	

	else if(SizedStrComp("1100110", Binario, 0, 7) == 0){

		if(SizedStrComp("000", Binario, 12, 3) == 0){

			if(SizedStrComp("0000000", Binario, 25, 7) == 0) CopiaInstrucao("add");
			if(SizedStrComp("0000010", Binario, 25, 7) == 0) CopiaInstrucao("sub");
		}

		if(SizedStrComp("100", Binario, 12, 3) == 0) CopiaInstrucao("sll");
		if(SizedStrComp("010", Binario, 12, 3) == 0) CopiaInstrucao("slt");
		if(SizedStrComp("110", Binario, 12, 3) == 0) CopiaInstrucao("sltu");
		if(SizedStrComp("001", Binario, 12, 3) == 0) CopiaInstrucao("xor");

		if(SizedStrComp("101", Binario, 12, 3) == 0){

			if(SizedStrComp("0000000", Binario, 25, 7) == 0) CopiaInstrucao("srl");
			if(SizedStrComp("0000010", Binario, 25, 7) == 0) CopiaInstrucao("sra");
		}

		if(SizedStrComp("011", Binario, 12, 3) == 0) CopiaInstrucao("or");
		if(SizedStrComp("111", Binario, 12, 3) == 0) CopiaInstrucao("and");
	}
	
	else if(SizedStrComp("1111000", Binario, 0, 7) == 0){

		if(SizedStrComp("000", Binario, 12, 3) == 0) CopiaInstrucao("fence");
		if(SizedStrComp("100", Binario, 12, 3) == 0) CopiaInstrucao("fence.i");
	}

	else if(SizedStrComp("1100111", Binario, 0, 7) == 0){

		if(SizedStrComp("000", Binario, 12, 3) == 0) {

			if(SizedStrComp("0000000", Binario, 25, 7) == 0) CopiaInstrucao("ecall");
			if(SizedStrComp("1000000", Binario, 25, 7) == 0) CopiaInstrucao("ebreak");				
		}

		if(SizedStrComp("100", Binario, 12, 3) == 0) CopiaInstrucao("csrrw");		
		if(SizedStrComp("010", Binario, 12, 3) == 0) CopiaInstrucao("csrrs");
		if(SizedStrComp("110", Binario, 12, 3) == 0) CopiaInstrucao("csrrc");
		if(SizedStrComp("101", Binario, 12, 3) == 0) CopiaInstrucao("csrrwi");
		if(SizedStrComp("011", Binario, 12, 3) == 0) CopiaInstrucao("csrrsi");
		if(SizedStrComp("111", Binario, 12, 3) == 0) CopiaInstrucao("csrrci");

	}
	else {
		CopiaInstrucao("<unknown>");
	}


}




int main( int argc, char *argv[ ]){

    unsigned char elf[1000000];


    int fd = open( argv[2] , O_RDONLY);
	//int fd = open( "bin/test-19.x" , O_RDONLY);
    Elf32_Ehdr *header;

    read(fd, elf, 1000000);
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

    

	
    write(1, "\n", 1);
	write(1, argv[2], TamanhoString((unsigned char*)argv[2]));
    write(1, ": file format elf32-littleriscv", 31);
    write(1, "\n\n", 2);


    if(argv[1][1] == 't'){
	//if(0){

           
		write(1, "SYMBOL TABLE:\n", TamanhoString((unsigned char *)"SYMBOL TABLE:\n"));
        for(int i = 1; i < SymtabHeader->sh_size/16; i++){

            DecHex(SymbolsList[i]->st_value);

            char coluna2[1];
            coluna2[0] = 'l';
            if(SymbolsList[i]->st_info >> 4 == 1) coluna2[0] = 'g';

            
           
            
            write(1, ResultadoConversao, TamanhoString(ResultadoConversao));
            write(1, " ", 1);

            write(1, coluna2, 1);
            write(1, " ", 1);

			int contadorPontos = 0;
			int it = 0;
			int gatilho = 0;
			while(contadorPontos < SymbolsList[i]->st_shndx){

				if(*(elf + HeaderShstrtab->sh_offset + it) == '.') contadorPontos += 1;

				it += 1;
				if(SymbolsList[i]->st_shndx > 1000){
					gatilho = 1;
					break;
				}


			}
			
            if(gatilho == 0){
				write(1, (elf + it + HeaderShstrtab->sh_offset - 1), TamanhoString((elf + it + HeaderShstrtab->sh_offset - 1)));
			}
			else {
				write(1, "*ABS*", 5);
			}
			
            write(1, " ", 1);

            DecHex(SymbolsList[i]->st_size);
            write(1, ResultadoConversao, TamanhoString(ResultadoConversao));
            write(1, " ", 1);

            write(1, (elf + SymbolsList[i]->st_name + StrtabHeader->sh_offset), TamanhoString((elf + SymbolsList[i]->st_name + StrtabHeader->sh_offset)));
            write(1, "\n", 1);

           
          
            

        }
       
    }

    else if(argv[1][1] == 'h'){
	//else if(0){

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
		write(1, "\n", 1);

    }

    else if(argv[1][1] == 'd'){
	//else if(1){
		write(1, "\n", 1);

		for(int i=0; i < SymtabHeader->sh_size; i += 16){

      DecHex(SymbolsList[i/16]->st_value);

      for(int j = 0; j < 8; j++){

        ListaRotulos[i/16].str1[j] = ResultadoConversao[j];

        
        ListaRotulos[i/16].str2[j] = (elf + SymbolsList[i/16]->st_name + StrtabHeader->sh_offset)[j];

		ListaRotulos[i/16].n1 = SymbolsList[i/16]->st_size;

		TamanhoLista += 1;
      }

      
    }

	OrdenaPorPosicao(ListaRotulos, TamanhoLista);



		DecHex(TextHeader->sh_offset);
		write(1, "Disassembly of section .text:\n\n", TamanhoString((unsigned char*)"Disassembly of section .text:\n\n"));

		int offset = 0;	
        for(int i=1; i < TamanhoLista && offset < TextHeader->sh_size; i++){
			

		  //NAO PRINTAR ROTULOS SEM INSTRUCAO			
          if(StrComp(ResultadoOrdenacao[i].str1, ResultadoConversao) >= 0){
		
				write(1, ResultadoOrdenacao[i].str1, TamanhoString(ResultadoOrdenacao[i].str1));
				write(1, " ", 1);

				write(1, "<", 1);
				write(1, ResultadoOrdenacao[i].str2, TamanhoString(ResultadoOrdenacao[i].str2));
				write(1, ">:", 2);
				write(1, "\n", 1);

				int linhaText = HexDec(ResultadoOrdenacao[i].str1);	
				


				while(offset < TextHeader->sh_size){
					if(i < TamanhoLista - 1 && linhaText >= HexDec(ResultadoOrdenacao[i + 1].str1)) break;

					DecHex(linhaText);
					RemoveZerosDaFrente(ResultadoConversao);
					
					write(1, "\t", 1);

					
					write(1, ResultadoRemocao, TamanhoString(ResultadoRemocao));
					

					write(1, ": ", 2);

					int valor = *(elf + TextHeader->sh_offset + offset);//tem que converter pra hexa ainda
					//printf("aqui%d\n", *(elf + TextHeader->sh_offset + offset + 1));

          			DecHex(valor);
					RemoveZerosDaFrente(ResultadoConversao);
					//printf("%s\n", ResultadoConversao);


					write(1, ResultadoRemocao, 2);

					valor = *(elf + TextHeader->sh_offset + offset + 1);
					DecHex(valor);
					RemoveZerosDaFrente(ResultadoConversao);
					write(1, " ", 1);

					write(1, ResultadoRemocao, 2);

					valor = *(elf + TextHeader->sh_offset + offset + 2);
					DecHex(valor);
					RemoveZerosDaFrente(ResultadoConversao);
					write(1, " ", 1);

					write(1, ResultadoRemocao, 2);

					valor = *(elf + TextHeader->sh_offset + offset + 3);
					DecHex(valor);
					RemoveZerosDaFrente(ResultadoConversao);
					write(1, " ", 1);


					write(1, ResultadoRemocao, 2);

					DescobreInstrucao(elf, TextHeader->sh_offset + offset);

					write(1, "\n", 1);
					//printf("Instrucao: %s\n", Instrucao);
					
					linhaText += 4;
					offset += 4;
				}
				write(1, "\n", 1);
				
          }
		  

        }

        
    }

    
    
}



