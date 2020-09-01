@isTest
global class ParkServiceMock implements WebServiceMock{
    global void doInvoke(
    Object stub,
    Object request,
    Map<String,Object> response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
        String responseType) {
            ParkService.byCountryResponse response_x = new ParkService.byCountryResponse();
            response_x.return_x = new List<String>{'Garner State Park', 'Fowler Park', 'Hoosier National Forest Park'};
                response.put('response_x',response_x);
        }

}