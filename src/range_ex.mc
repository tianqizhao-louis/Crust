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
    string res = awk_line_range_end(body, pattern,2);
    print(res);
    print("------------------");
    string a = awk_col(body, pattern,4);
    print(a);




    return 0;
}