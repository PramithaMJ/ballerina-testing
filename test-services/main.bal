import ballerina/http;

service http:Service /foo on new http:Listener(9090) {

    resource function get bar(int value) returns http:Ok|http:BadRequest {

        if value < 0 {
            return <http:BadRequest>{body: "Incorrect ID value"};
        }
        return <http:Ok>{body: "Retrieved ID " + value.toString()};
    }
}