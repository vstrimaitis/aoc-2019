#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

const int ERR_CANNOT_OPEN_FILE = 1;
const int ERR_UNKNOWN_OPCODE = 2;
const int ERR_FAILED_STDIN = 3;

void readFile(char* filename, char** buffer) {
    *buffer = NULL;
    FILE* fin = fopen(filename, "r");
    if (fin == NULL) {
        return;
    }
    long len;
    fseek(fin, 0, SEEK_END);
    len = ftell(fin);
    fseek(fin, 0, SEEK_SET);
    *buffer = calloc(len+1, sizeof(char));
    long read = fread(*buffer, 1, len, fin);
    if (read != len) return;
    fclose(fin);
}

void parseSource(char* source, int64_t** prog, int* progLen) {
    int i = 0;
    char c;
    int commaCount = 0;
    while((c = source[i++]) != 0) commaCount += c == ',';
    *prog = (int64_t*)calloc(commaCount+1, sizeof(int64_t));
    *progLen = commaCount+1;
    i = 0;
    int j = 0;
    int sign = 1;
    while((c = source[i++]) != 0) {
        if (c == ',') {
            (*prog)[j++] *= sign;
            sign = 1;
        } else if(c == '-') {
            sign = -1;
        } else {
            (*prog)[j] = (*prog)[j]*10+c-'0';
        }
    }
}

void expand(int64_t** mem, int* oldSize, int newSize) {
    if(realloc(*mem, newSize) == NULL) {
        fprintf(stderr, "Failed to expand memory to size %d\n", newSize);
        return;
    }
    int i;
    for(i = *oldSize; i < newSize; i++) {
        (*mem)[i] = 0;
    }
    *oldSize = newSize;
}

void getArgs(int64_t* mem, int ip, int relBase, int count, int** indices) {
    *indices = (int*)malloc(count * sizeof(int));
    int divider = 100;
    int i;
    for(i = 0; i < count; i++) {
        (*indices)[i] = mem[ip] / divider % 10;
        divider *= 10;
    }
    for(i = 0; i < count; i++) {
        int m = (*indices)[i];
        int idx;
        if (m == 0) {
            idx = mem[ip+i+1];
        } else if(m == 1) {
            idx = ip+i+1;
        } else {
            idx = relBase+mem[ip+i+1];
        }
        (*indices)[i] = idx;
    }
}

void dumpMemory(int64_t* mem, int size) {
    int i;
    printf("[memdump] ");
    for(i = 0; i < size; i++) {
        printf("%ld ", mem[i]);
    }
    printf("\n");
}

int run(int64_t* program, int memSize) {
    int ip = 0;
    int relBase = 0;
    int* argIndices;
    while(1) {
        int curr = program[ip];
        int opcode = curr%100;
        // printf("ip=%d, relBase=%d\n", ip, relBase);
        // dumpMemory(program, memSize);
        switch(opcode) {
            case 1:
                // add
                getArgs(program, ip, relBase, 3, &argIndices);
                program[argIndices[2]] = program[argIndices[0]] + program[argIndices[1]];
                ip += 4;
                break;
            case 2:
                // multiply
                getArgs(program, ip, relBase, 3, &argIndices);
                program[argIndices[2]] = program[argIndices[0]] * program[argIndices[1]];
                ip += 4;
                break;
            case 3:
                // input
                getArgs(program, ip, relBase, 1, &argIndices);
                int64_t inp;
                if(!scanf("%ld", &inp)) {
                    fprintf(stderr, "Failed to get input.\n");
                    return ERR_FAILED_STDIN;
                }
                program[argIndices[0]] = inp;
                ip += 2;
                break;
            case 4:
                // output
                getArgs(program, ip, relBase, 1, &argIndices);
                printf("%ld\n", program[argIndices[0]]);
                ip += 2;
                break;
            case 5:
                // jump if true
                getArgs(program, ip, relBase, 2, &argIndices);
                if (program[argIndices[0]] != 0) {
                    ip = program[argIndices[1]];
                } else {
                    ip += 3;
                }
                break;
            case 6:
                // jump if false
                getArgs(program, ip, relBase, 2, &argIndices);
                if (program[argIndices[0]] == 0) {
                    ip = program[argIndices[1]];
                } else {
                    ip += 3;
                }
                break;
            case 7:
                // less than
                getArgs(program, ip, relBase, 3, &argIndices);
                program[argIndices[2]] = program[argIndices[0]] < program[argIndices[1]];
                ip += 4;
                break;
            case 8:
                // equals
                getArgs(program, ip, relBase, 3, &argIndices);
                program[argIndices[2]] = program[argIndices[0]] == program[argIndices[1]];
                ip += 4;
                break;
            case 9:
                // adjust relative base
                getArgs(program, ip, relBase, 1, &argIndices);
                relBase += program[argIndices[0]];
                ip += 2;
                break;
            case 99:
                return 0;
            default:
                fprintf(stderr, "Unrecognized opcode %d at position %d.\n", opcode, ip);
                return ERR_UNKNOWN_OPCODE;
        }
        if(ip >= memSize) {
            expand(&program, &memSize, ip+1);
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: intc <intcode-file>\n");
        return 0;
    }
    char* source;
    readFile(argv[1], &source);
    if (source == NULL) {
        printf("Cannot open file\n");
        return ERR_CANNOT_OPEN_FILE;
    }

    int64_t* program;
    int programLength;
    parseSource(source, &program, &programLength);

    return run(program, programLength);
}