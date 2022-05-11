int main() {
    string body = 
    "Guangzhou China Cantonese
Beijing China Mandarin
Hongkong China Cantonese
Singapore Singapore Mandarin
London UK English
Sydney Australia English";

    string pattern = "China";
    string res = awk_line(body, pattern, "y");
    print(res);
    print("---------\n");
    print(awk_line(body, "Mandarin","n"));
    return 0;
}