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
    string res1 = awk_line(body, pattern, "y");
    print(res1);

    print("---------\n");

    string res2 = awk_line(body, "Mandarin", "n");
    print(res2);

    
    return 0;
}