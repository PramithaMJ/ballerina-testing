import ballerina/http;

configurable int port = 9090;
configurable string host = "localhost";

listener http:Listener petstorelistner = new (port,config={host});

type Pet record{
    string id;
    string name;
    boolean isAvailable;
};

service / on petstorelistner {
    map<Pet> petInventory = {};

    resource function get pet/[string petId]() returns http:NotFound|Pet {
        Pet? pet  =self.petInventory[petId];
        
        if pet is (){
            return <http:NotFound>{ body:"No pet found with given id " + petId };
        }
        return pet;
    }

    resource function post pet(Pet payload) returns http:MethodNotAllowed|Pet {
       Pet? pet = self.petInventory[payload.id];

       if pet is Pet{
        return <http:MethodNotAllowed>{body:"A pet with given id " + payload.id +
        " is already available in petstore"};
       }

       self.petInventory[payload.id]=payload;

       return payload; 
    }

    resource function get pets() returns map<Pet> {
        return self.petInventory;
    }
}
