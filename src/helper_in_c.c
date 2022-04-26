#include <stdlib.h>
#include <stdio.h> 
#include <string.h>

char* string_of_int_f(int input) {
    char* string = (char *) malloc(33);
    sprintf(string,"%d", input);
    return string;

}

char* string_of_float_f(double input) {
    char* string = (char *) malloc(65);
    sprintf(string,"%f", input);
    return string;
}

char* string_of_bool_f(int input) {
    char* string = (char* ) malloc(10);
    if (input == 0) {
        strcpy(string, "false");
    } else {
        strcpy(string, "true");
    }
}