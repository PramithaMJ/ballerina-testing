import ballerina/http;
import ballerina/test;

string petstoreUrl = "http://localhost:9090";

http:Client petstoreClient = check new(petstoreUrl);

@test:Config{}
function getNonExistPetDetails() returns error?{
    http:Response response = check petstoreClient->/pet/P001;
    test:assertEquals(response.statusCode,http:STATUS_NOT_FOUND,"Unexpected pet record found");
    test:assertEquals(response.getTextPayload(),"No pet fount with given id P001");
};

@test:Config{
    dependsOn: [getNonExistPetDetails]
}
function addNewPetTest() returns error? {
    http:Response response =check petstoreClient->/pet.post({id:"P001",name:"Dakota",isAvailable:true});
    test:assertEquals(response.statusCode,http:STATUS_CREATED,"New Pet addition fails");
    test:assertEquals(response.getJsonPayload(),{id:"P001",name:"Dakota",isAvailable:true},
    "New creation did not return expected message");
}

@test:Config{
    dependsOn: [addNewPetTest]
}
function getPetDetailsTest() returns error?{
    http:Response response = check petstoreClient->/pet/P001;
    test:assertEquals(response.statusCode,http:STATUS_OK,"Get pet details request failed.");
    test:assertEquals(response.getJsonPayload(),{id:"P001",name:"Dakota",isAvailable:true},
    "expected response message was not recieved.");
}

@test:Config{
    dependsOn: [getPetDetailsTest]
}
function addNewPet() returns error?{
    http:Response response = check petstoreClient->/pet.post({id:"P001",name:"Dakota",isAvailable:true});
    test:assertEquals(response.statusCode,http:STATUS_METHOD_NOT_ALLOWED,"Expected code not available");
    test:assertEquals(response.getTextPayload(),"A pet with given id P001 is already available in pet store");
}