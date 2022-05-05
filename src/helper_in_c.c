#include <stdlib.h>
#include <stdio.h> 
#include <string.h>

int is_sub_string(char* text, int text_length, char* substr, int substr_length) {
    return -1;
}

char* awk_f(char* text, char* pattern) {
    char* res = (char *) malloc(1024);
    int res_len = 0;
    char *line, *str, *tofree;
    tofree = str = strdup(text);
    while ((line = strsep(&str, "\n"))) {
        if (strstr(line, pattern)) {
            strcpy(res+res_len, line);
            res_len += strlen(line);
            res[res_len] = '\n';
            res_len++;
        }
    }
    return res;
}

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
    return string;
}