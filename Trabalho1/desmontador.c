#define TAMANHO_LINHA 79 //contando \n
#define TAMANHO_FINAL 18
#define TAMANHO_LINHA_NUMEROS_ESPACOS 48
#define TAMANHO_LINHA_SO_HEXAS 16

// contando quebras de linha
#define TAMANHO_MARCADOR_LINHA 8
#define POSICAO_ESHOFF 168
#define POSICAO_ESHNUM 247
#define POSICAO_ESHSTRNDX 253
#define TAMANHO_ENTRE_DUAS_LINHAS 31
//==================================

int posicaoHeader;
int tamanhoHeader;
int posicaoSection;
int tamanhoSection;
char elf[10000];
char entrada[100];
char saida[1000];
char variavelHex[100];
char resultadoInversao[100];
char resultadoCopia[100];

char e_shoffHexa[100];
int e_shoff;

char e_shstrndxHexa[100];
int e_shstrndx;

int e_shnum;


//TODO
/* 


    VER COMO O LEITOR DE ARQUIVOS FUNCIONA 
    IMPLEMENTAR UM COPIADOR DE STRINGS
    IMPLEMENTAR INVERSOR DE ENDIANESS



 */
//=============== TESTADAS ====================
unsigned long int pot(int num, int pot) {

    unsigned long int resultado = 1;
    for (int i = 0; i < pot; i++) {
        resultado *= num;

    }
    return resultado;
}

int HexDec(char * entrada) {

    int it = 0;
    int tamanho = 0;

    //long long int resultado=0;
    unsigned long int resultado = 0;


    while(entrada[tamanho] != '\0') tamanho += 1;


    for(int it=0; it < tamanho; it++){


        switch (entrada[it]) {

        case 'a':
            resultado += 10 * pot(16, tamanho - it - 1) ;
            break;
        case 'b':
            resultado += 11 * pot(16, tamanho - 1 - it) ;
            break;
        case 'c':
            resultado += 12 * pot(16, tamanho - 1 - it) ;
            break;
        case 'd':
            resultado += 13 * pot(16, tamanho - 1 - it) ;
            break;
        case 'e':
            resultado += 14 * pot(16, tamanho - 1 - it) ;
            break;
        case 'f':
            resultado += 15 * pot(16, tamanho - 1 - it);
            break;
        default:
            resultado += (entrada[it] - 48) * pot(16, tamanho - 1 - it) ;
            break;
        }


    }

    return resultado;
}

//ENCONTRA A POSICAO EXATA DO PRIMEIRO CARACTERE
int EncontraOffset(char *offsetHexa){//dado um offset a partir do inicio do arquivo

    int resultado = 10;
    unsigned long offsetDecimal = HexDec(offsetHexa);
    int trocasDeLinha = offsetDecimal / TAMANHO_LINHA_SO_HEXAS;

    if(trocasDeLinha > 1) resultado += TAMANHO_LINHA_NUMEROS_ESPACOS;

    resultado += (trocasDeLinha - 1) * TAMANHO_LINHA;
    resultado += TAMANHO_ENTRE_DUAS_LINHAS;

    if(offsetDecimal % 16 >= 8) resultado += 1;

    resultado += (offsetDecimal % 16) * 3;

    return resultado;

}

void InverteString(char *string){

    int tamanho = 0;
    while(string[tamanho] != '\0') tamanho += 1;

    for(int i=0; i < tamanho; i++){
        resultadoInversao[i] = string[tamanho - i - 1];

    }

    resultadoInversao[tamanho] = '\0';


}

void CopiaStringSemEspacos(char * str, int inicio, int fim){//de str[inicio] a str[fim - 1]

    int j = 0;
    for(int i = inicio; i < fim; i++){

        if(str[i] != ' '){

            resultadoCopia[j] = str[i];
            printf("%c\n", resultadoCopia[j]);
            j += 1;

        }

    }

    resultadoCopia[j] = '\0';

}

void InverteEndian(char *hexa){//hexa tem que ter numero par de caracteres

    int tamanho = 0;

    while(hexa[tamanho] != '\0') tamanho += 1;

    int i = 0; 
    while(i < tamanho){
         
        resultadoInversao[i] = hexa[tamanho - i - 2];
        resultadoInversao[i + 1] = hexa[tamanho - i - 1];
        i += 2;

    }

    resultadoInversao[i] = '\0';


}

int EncontraOffsetCasca(char * elf, int inicio, int tamanho){

    e_shoffHexa = CopiaStringSemEspacos(elf, inicio, inicio + tamanho);

    InverteEndian(resultadoCopia);

    int resultado = EncontraOffset(resultadoInversao);

    return resultado;
}
//=============================================================================

void ProcuraPalavrasIguais(){

}

void EncontraPosicaoHeader(char * tipo, char * elf){

    e_shoff = EncontraOffsetCasca(elf, POSICAO_ESHOFF, 12);

    CopiaStringSemEspacos(elf, POSICAO_ESHSTRNDX, POSICAO_ESHSTRNDX + 5);
    InverteEndian(resultadoCopia);
    e_shstrndx = HexDec(resultadoInversao);


    


}
 
void EncontraHeader(){









}



int main(){

    entrada = LeEntrada();
    LeArquivo();//vai traduzir a opcao de entrada para o nome da section que se procura

    //identificar qual o tipo de desmontagem
    char tipo;
    

    EncontraPosicaoHeader(tipo);
    EncontraHeader();
    EncontraSection();
    DesmontaSection(tipo);

    ImprimeSaida(saida);



}