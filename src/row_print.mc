int main() {
    string body = 
    "Guangzhou China Cantonese
Beijing China Mandarin
Hongkong China Cantonese
Singapore Singapore Mandarin
London UK English
Sydney Australia English";

    string pattern = "China";
    string decision = "y";
    print(awk_line(body, pattern, decision));

    print("---------\n");
    decision = "n";
    print(awk_line(body, "Mandarin", decision));
    return 0;
}