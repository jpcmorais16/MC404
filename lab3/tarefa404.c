#include <stdio.h>

int pot(int num, int pot) {

  int resultado = 1;
  for (int i = 0; i < pot; i++) {
    resultado *= num;
  }
  return resultado;
}

int str_int(char *entrada, int total) {

  char it = 0;
  int resultado = 0;
  while (entrada[it] != '\0') {

    int algarismo = entrada[it] - 48;
    printf("int: %d, char: %c ", algarismo, entrada[it]);

    resultado += algarismo * pot(10, total - it - 1);
    it += 1;
  }

  return resultado;
}

char *dec_hex(char *entrada) {

  int tamanho = 0;
  while (entrada[tamanho] != '\0')
    tamanho += 1;

  int dividendo = str_int(entrada, tamanho);
  printf("dividendo: %d\n", dividendo);
  char resultado[100];
  int it = 0;

  while (dividendo != 0) {

    int resto = dividendo % 16;
    printf("%d\n", dividendo);

    if (resto > 9) {
      switch (resto) {

      case (10):
        resultado[tamanho - it - 1] = 'a';
        break;
      case (11):
        resultado[tamanho - it - 1] = 'b';
        break;
      case (12):
        resultado[tamanho - it - 1] = 'c';
        break;
      case (13):
        resultado[tamanho - it - 1] = 'd';
        break;
      case (14):
        resultado[tamanho - it - 1] = 'e';
        break;
      case (15):
        resultado[tamanho - it - 1] = 'f';
        break;
      default:
        break;
      }

    } else {

      resultado[tamanho - it - 1] = resto + 48;
    }

    dividendo = dividendo / 16;
    it += 1;
  }
  resultado[it] = '\0';

  printf("%s\n", resultado);

  return resultado;
}

int hex_dec(char *entrada) {

  int it = 0;
  int resultado = 0;
  while (entrada[it] != '\0') {

    switch (entrada[it]) {

    case 'a':
      resultado += 10 * pot(16, it);
      break;
    case 'b':
      resultado += 11 * pot(16, it);
      break;
    case 'c':
      resultado += 12 * pot(16, it);
      break;
    case 'd':
      resultado += 13 * pot(16, it);
      break;
    case 'e':
      resultado += 14 * pot(16, it);
      break;
    case 'f':
      resultado += 15 * pot(16, it);
      break;
    default:
      resultado += (entrada[it] + 48) * pot(16, it);
      break;
    }
    it += 1;
  }
  return resultado;
}
char *complemento2(char *entrada) {

  int it = 0;
  char resultado[100];

  while (entrada[it] != '\0') {

    if (entrada[it] == '1') {
      entrada[it] = '0';
    }

    else {
      entrada[it] = '1';
    }
    it += 1;
  }
  printf("it2: %d\n", it);

  printf("%s\n", entrada);
  return resultado;
}

char *reverte_binario(char *entrada, int eh_negativo) {

  int tamanho = 0;
  while (entrada[tamanho] != '\0')
    tamanho += 1;

  printf("tamanho: %d\n", tamanho);

  char resultado[100];
	resultado[0] = '0';

  int i = 0;
  for (i; i < tamanho; i++) {
    resultado[i+1] = entrada[tamanho - i - 1];
  }
  resultado[i+1] = '\0';

  if (eh_negativo == 1) {
    printf("%s\n", resultado);
  } else {
    complemento2(resultado);
  }

  return resultado;
}

char *dec_bin(int entrada) {

  int eh_negativo = 1;
  int dividendo = entrada;

  if (entrada < 0) {

    dividendo = 0 - entrada;
    dividendo -= 1;
    eh_negativo = 0;
  }
  char resultado[100];
  int it = 0;
  int tamanho = 1;

  while (dividendo != 0) {

    int resto = dividendo % 2;

    resultado[it] = resto + 48;

    dividendo = dividendo / 2;
    it += 1;
  }
  resultado[it] = '\0';

  printf("it1: %d\n", it);
  reverte_binario(resultado, eh_negativo);
  printf("%s\n", resultado);
  return resultado;
}

int main(void) {

  dec_bin(-40);
  return 0;
}