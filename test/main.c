// 文件名: main.c

#include <stdio.h>

// 宣告組合語言函數
extern void add_numbers(int *arr);

int main() {
    int arr[3] = {1,2,3};
    add_numbers(arr);
    for (int i = 0; i < 3; i++) {
        printf("%d\n", arr[i]);
    }
    return 0;
}
