int main() {
    string body = 
    "Guangzhou China Cantonese
Beijing China Mandarin
Hongkong China Cantonese
Singapore Singapore Mandarin
London UK English
Sydney Australia English";

    string pattern = "China";
    string res = awk_line(body, pattern, 1);
    print(res);
    print("---------\n");
    print(awk_line(body, "Mandarin",0));
    return 0;
}