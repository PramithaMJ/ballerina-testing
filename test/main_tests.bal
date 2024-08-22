import ballerina/test;

@test:Config{}
function testIsEven(){
    test:assertEquals(isEven(4),true,msg = "fail to identify an even number");
    test:assertEquals(isEven(5),true,msg = "fail to identify an odd number");
}