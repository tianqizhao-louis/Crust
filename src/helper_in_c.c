#include <stdlib.h>
#include <stdio.h> 
#include <string.h>
#include <regex.h> 


int str_neq_f(char* first, char* second) {
    return (strcmp(first, second) != 0);
}



int str_eq_f(char* first, char* second) {
    return (strcmp(first, second) == 0);
}

char* str_concat_f(char* first, char* second) {
    char* res = (char *) malloc(strlen(first) + strlen(second) + 1);
    strcpy(res, first);
    strcpy(res + strlen(first), second);
    return res;
}

char* awk_f(char* text, char* pattern) {
    char* res = (char *) malloc(strlen(text) + 1);
    int res_len = 0;
    char *line, *str, *tofree;

    tofree = str = strdup(text);
    while ((line = strsep(&str, "\n"))) {
        regex_t regex;
        char msgbuf[100];
        int reti;
        reti = regcomp(&regex, pattern, REG_EXTENDED);
        if (reti) {
            fprintf(stderr, "Could not compile regex\n");
            exit(1);
        }
        reti = regexec(&regex, line, 0, NULL, 0);
        if (!reti || strstr(line, pattern)) {
            strcpy(res+res_len, line);
            res_len += strlen(line);
            res[res_len] = '\n';
            res_len++;
        }
        else if (reti != REG_NOMATCH) {
            regerror(reti, &regex, msgbuf, sizeof(msgbuf));
            fprintf(stderr, "Regex match failed: %s\n", msgbuf);
            exit(1);
        }

        /* Free memory allocated to the pattern buffer by regcomp() */
        regfree(&regex);

    }
    res[res_len] = '\0';
    return res;
}

char* awk_line_f(char* text, char* pattern, char* decision) {
    int count = 1;   
    char* res = (char *) malloc(1024);
    int res_len = 0;
    char *line, *str, *tofree;
    tofree = str = strdup(text);

    if ((strcmp("y", decision)) == 0){
        char buffer[1024];
        while ((line = strsep(&str, "\n"))) {
            if (strstr(line, pattern)) {
                sprintf(buffer, "%d. %s", count, line);
                line = buffer;
                strcpy(res+res_len, line);
                res_len += strlen(line);
                res[res_len] = '\n';
                res_len++;
            }
            count++;
        }
    }else{
        while ((line = strsep(&str, "\n"))) {
            if (strstr(line, pattern)) {
                strcpy(res+res_len, line);
                res_len += strlen(line);
                res[res_len] = '\n';
                res_len++;
            }
        }
    }
     return res;
}

char* awk_line_range_f(char* text, char* pattern, int start, int end) {
    int count = 1;   
    char* res = (char *) malloc(1024);
    int res_len = 0;
    char *line, *str, *tofree;
    tofree = str = strdup(text);
    char buffer[1024];
    while ((line = strsep(&str, "\n"))) {
        if (strstr(line, pattern)) {
            if ((count>= start) && (count <= end)){
                sprintf(buffer, "%d. %s", count, line);
                line = buffer;
                strcpy(res+res_len, line);
                res_len += strlen(line);
                res[res_len] = '\n';
                res_len++;
            }

        }
        count++;
    }
    return res;
}

char* awk_line_range_start_f(char* text, char* pattern, int start) {
    int count = 1;   
    char* res = (char *) malloc(1024);
    int res_len = 0;
    char *line, *str, *tofree;
    tofree = str = strdup(text);
    char buffer[1024];
    while ((line = strsep(&str, "\n"))) {
        if (strstr(line, pattern)) {
            if (count>= start){
                sprintf(buffer, "%d. %s", count, line);
                line = buffer;
                strcpy(res+res_len, line);
                res_len += strlen(line);
                res[res_len] = '\n';
                res_len++;
            }

        }
        count++;
    }
    return res;
}

char* awk_line_range_end_f(char* text, char* pattern, int end) {
    int count = 1;   
    char* res = (char *) malloc(1024);
    int res_len = 0;
    char *line, *str, *tofree;
    tofree = str = strdup(text);
    char buffer[1024];
    while ((line = strsep(&str, "\n"))) {
        if (strstr(line, pattern)) {
            if (count <= end){
                sprintf(buffer, "%d. %s", count, line);
                line = buffer;
                strcpy(res+res_len, line);
                res_len += strlen(line);
                res[res_len] = '\n';
                res_len++;
            }

        }
        count++;
    }
    return res;
}


char* awk_col_f(char* text, char* pattern, int col_num) {

    int col_count = 0;
    char* res = (char *) malloc(1024);
    int res_len = 0;
    char *line, *str, *tofree, *tmp, *tmp_line;
    tofree = str = tmp = strdup(text);

    char buffer[10000];
    strcpy(buffer, strdup(text));
    char * buff_pointer;
    buff_pointer = buffer;

    tmp_line = strsep(&buff_pointer, "\n");
    char * token = strtok(tmp_line, " ");
    // loop through the string to extract all other tokens
    while( token != NULL ) {
        // printf( " %s\n", token ); //printing each token
        token = strtok(NULL, " ");
        col_count++;
    }
    if (col_count < col_num) {
        printf("Invalid column number");
        exit(0);
    }

    while ((line = strsep(&str, "\n"))) {
        int row_count = 1;
        char * token = strtok(line, " ");
        char *target;
        // loop through the string to extract all other tokens
        while( token != NULL ) {
            
            // printf( " %s,%d\n", token,row_count ); //printing each token
            if (row_count == col_num){
                strcpy(target, token);
            }
            token = strtok(NULL, " ");
            row_count ++;
        }

        // strncat(res,token, sizeof(token));
        // strncat(res,"\n", 10);


        strcpy(res+res_len, line);
        res_len += strlen(line);
        res[res_len] = '\n';
        res_len++;
        
    }

    // printf("%s", str);

    // while ((line = strsep(&str, "\n"))) {
    //     printf("%s/n", line);
    //     int tmp_col_count = 1;
    //     line = strsep(&str, "\n");
    //     char * token = strtok(line, " ");
    //     while( token != NULL ) {
    //         if (tmp_col_count == col_num) {
    //             line = token;
    //         }
    //         token = strtok(NULL, " ");
    //         tmp_col_count++;
    //     }
    //     strcpy(res+res_len, line);
    //     res_len += strlen(line);
    //     res[res_len] = '\n';
    //     res_len++;
    // }
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