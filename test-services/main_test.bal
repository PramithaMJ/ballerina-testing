import ballerina/test;
import ballerina/http;

http:Client testClient = check new ("http://localhost:9090/foo");

# Description.
# + return - return value description
@test:Config
public function testGet() returns error? {
    http:Response response = check testClient->/bar.get(value = 10);
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertEquals(response.getTextPayload(), "Retrieved ID 10");

    response = check testClient->/bar.get(value = -5);
    test:assertEquals(response.statusCode, http:STATUS_BAD_REQUEST);
    test:assertEquals(response.getTextPayload(), "Incorrect ID value");
}