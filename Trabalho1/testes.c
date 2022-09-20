#include <stdio.h>

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

void InverteString(char *string){

    int tamanho = 0;
    while(string[tamanho] != '\0') tamanho += 1;

    for(int i=0; i < tamanho; i++){
        resultadoInversao[i] = string[tamanho - i - 1];

    }

    resultadoInversao[tamanho] = '\0';


}

int main(){

    InverteString("jonas");
    printf("iai %s\n", resultadoInversao);

    return 0;


}