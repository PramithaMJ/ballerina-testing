import ballerina/io;

public function main() {
    io:println("Hello, World!");
}

# Description.
#
# + num - parameter description
# + return - return value description
public function isEven(int num) returns boolean{
    return num % 2 == 0;
}