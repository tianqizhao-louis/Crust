int main() {
    print(strlen("abcd"));
    print("\n");

    string pattern = "China";
    string res = awk(body, pattern);
    print(res);
    print("---------\n");
    print(awk(body, "Mandarin"));
    print("---------\n");
    print(awk_line(body, "Mandarin","y"));

    return 0;
}