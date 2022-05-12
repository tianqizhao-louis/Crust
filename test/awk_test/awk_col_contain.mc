int main() {
    string body = 
    "Guangzhou China Cantonese
Beijing China Mandarin
Hongkong China Cantonese
Singapore Singapore Mandarin
London UK English
Sydney Australia English
Nanjing China Mandarin";

    string pattern = "China";
    int res1 = awk_col_contain(body, pattern, 2);
    print(string_of_int(res1));
    print("--------------------");
    int res2 = awk_col_contain(body, pattern, 3);
    print(string_of_int(res2));


    return 0;
}