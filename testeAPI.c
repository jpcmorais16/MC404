
void puts ( const char * str );
char * gets ( char * str );
int atoi (const char * str);
char *  itoa ( int value, char * str, int base );
unsigned int get_time(void);
void sleep(int ms);
int approx_sqrt(int x, int iterations);
void filter_1d_image(char * img, char * filter);


int main(){
    char buffer[3];
    // buffer[0] = '1';
    // buffer[1] = '2';
    // buffer[2] = '3';
    gets(buffer);
    puts(buffer);
    while(1);
    return 0; 
}