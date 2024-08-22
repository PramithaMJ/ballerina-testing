import ballerina/io;

public function main() {
    io:println("Hello, World!");
}

public function isEven(int num) returns boolean{
    return num % 2 == 0;
}