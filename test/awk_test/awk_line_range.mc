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
    string res1 = awk_line_range(body, pattern, 1,4);
    print(res1);

    return 0;
}