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
    string res = awk_line_range(body, pattern,1,7);
    print(res);

    return 0;
}