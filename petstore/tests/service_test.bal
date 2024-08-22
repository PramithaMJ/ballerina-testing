import ballerina/http;
import ballerina/test;

string petstoreUrl = "http://localhost:9090";

http:Client petstoreClient = check new(petstoreUrl);

@test:Config{}

function addNewPetTest() returns error? {
    http:Response response =check petstoreClient->/pet.post({id:"P001",name:"Dakota",isAvailable:true});
    test:assertEquals(response.statusCode,http:STATUS_CREATED,"New Pet addition fails");
    test:assertEquals(response.getJsonPayload(),{id:"P001",name:"Dakota",isAvailable:true},
    "New creation did not return expected message");
}