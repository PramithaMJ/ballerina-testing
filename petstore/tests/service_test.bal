import ballerina/http;
import ballerina/test;
import ballerina/io;

string petstoreUrl = "http://localhost:9090";

http:Client petstoreClient = check new(petstoreUrl);

@test:BeforeEach
function printPetDetails() {
    map<Pet>|http:ClientError pets = petstoreClient->/pets;
    io:println("Pet details before test run: ",pets);
    
}

@test:Config{}
function getNonExistPetDetails() returns error?{
    http:Response response = check petstoreClient->/pet/P001;
    test:assertEquals(response.statusCode,http:STATUS_NOT_FOUND,"Unexpected pet record found");
    test:assertEquals(response.getTextPayload(),"No pet fount with given id P001");
};

@test:Config{
    dependsOn: [getNonExistPetDetails]
}
function addNewPetTest(Pet pet) returns error? {
    http:Response response =check petstoreClient->/pet.post(pet);
    test:assertEquals(response.statusCode,http:STATUS_CREATED,"New Pet addition fails");
    test:assertEquals(response.getJsonPayload(),pet,
    "New creation did not return expected message");
}

function petData() returns map<[Pet]>|error{
    return{
        "P001":[{id:"P001",name:"Dakota",isAvailable: true}],
        "P002":[{id:"P002",name:"Bella",isAvailable: true}],
        "P003":[{id:"P003",name:"Charlie",isAvailable: true}]
    };
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