import ballerina/http;
import ballerina/test;

@test:Config
public function testGetRandomJoke() returns error? {
    http:Client clientEndpoint = test:mock(http:Client);

    test:prepare(clientEndpoint).whenResource("::path").withPathParameters({path: ["random"]}).onMethod("get").thenReturn(getMockResponse());

    http:Response result = check clientEndpoint->/random;
    json payload = check result.getJsonPayload();

    test:assertEquals(payload, {"value": "When Chuck Norris wants an egg, he cracks open a chicken."});    
}

function getMockResponse() returns http:Response {
    http:Response mockResponse = new;
    mockResponse.setPayload({"value": "When Chuck Norris wants an egg, he cracks open a chicken."});
    return mockResponse;
}