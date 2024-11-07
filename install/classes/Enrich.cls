global class Enrich {
    
    /* Geolocation: Enrich address of single account
       @author Maciej Szymczak
       @version 2022.08.26
     */
    
    @InvocableMethod
    global static List<Response> enrichBillingAddress(List<Param> params) {
        List<Response> res = new List<Response>();
        for (Param param :params ) {
            res.add( Enrich.enrichBillingAddress(param.accountId, param.apiKey) );
        }
        Return res;
    }
    
    global class Param {
        @InvocableVariable(required=true)
        global ID accountId;
        @InvocableVariable(required=true)
        global String apiKey;
    } 

    global class Response {
        @InvocableVariable(required=true)
        global String Status;
        @InvocableVariable(required=true)
        global String BillingStreet; 
        @InvocableVariable(required=true)
        global String BillingCity; 
        @InvocableVariable(required=true)
        global String BillingPostalCode;
        @InvocableVariable(required=true)
        global String BillingCountry;
        @InvocableVariable(required=true)
        global Decimal BillingLatitude;
        @InvocableVariable(required=true)
        global Decimal BillingLongitude;
        @InvocableVariable(required=true)
        global String RAWResponse;
    } 

    
    static Map<String,String> responseMap = new Map<String,String>();
    
    //@future(callout=true)
    public static Response enrichBillingAddress(Id accountId, String apiKey) {
        Account account =     
            [select Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude, BillingGeocodeAccuracy 
             from Account
             where Id = :accountId];
        
        String addressString = EncodingUtil.urlEncode(account.BillingStreet +','+ account.BillingCity +','+ account.BillingState +','+ account.BillingPostalCode +','+ account.BillingCountry, 'UTF-8');
        
        //check Setup->Security->Remote site settings
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/xml?address='+addressString+'&key='+apikey;
        String method = 'GET';
        
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setTimeout(120000);
        req.setEndpoint( endpoint );
        HttpResponse res;
        res = new HttpResponse();
        Http http = new Http();
        res = http.send(req);
        
        Response response = new Response();
        response.Status = String.valueOf(res.getStatusCode());
        
        if (res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            System.debug(responseBody);
            walkThroughAll(responseBody);
            
            String status        = responseMap.get('status');
            String subpremise    = String.isBlank( responseMap.get('subpremise'   ) )?'':responseMap.get('subpremise');
            String premise       = String.isBlank( responseMap.get('premise'      ) )?'':responseMap.get('premise'); 
            String street_number = String.isBlank( responseMap.get('street_number') )?'':responseMap.get('street_number');
            String route         = String.isBlank( responseMap.get('route'        ) )?'':responseMap.get('route'); 
            String postal_town   = String.isBlank( responseMap.get('postal_town'  ) )?'':responseMap.get('postal_town');  
            String postal_code   = String.isBlank( responseMap.get('postal_code'  ) )?'':responseMap.get('postal_code'); 
            String country       = String.isBlank( responseMap.get('country'      ) )?'':responseMap.get('country'); 
            String lat           = responseMap.get('ROOFTOP:lat');
            String lng           = responseMap.get('ROOFTOP:lng');
            
            System.debug(status+'|'+street_number+'|'+route+'|'+postal_town+'|'+postal_code+'|'+country+'|'+lat+'|'+lng);
            
            if (String.isNotBlank(subpremise)) subpremise = subpremise + ', ';
            if (String.isNotBlank(premise)) premise = premise + ', ';

            response.Status             = status;
            response.BillingStreet      = (subpremise + premise +street_number + ' ' + route).Trim();
            response.BillingCity        = postal_town;
            response.BillingPostalCode  = postal_code;
            response.BillingCountry     = country;
            response.BillingLatitude    = lat==null?null:decimal.ValueOf(lat);
            response.BillingLongitude   = lng==null?null:decimal.ValueOf(lng) ;
            response.RAWResponse        = responseBody;
             
            /* Minimal set of values to be considered as correct response
                //&& String.isNotBlank(subpremise)
                //&& String.isNotBlank(premise)
                //&& String.isNotBlank(street_number)
                   String.isNotBlank(route)
                && String.isNotBlank(postal_town)
                && String.isNotBlank(postal_code)
                && String.isNotBlank(country)
                && String.isNotBlank(lat)
                && String.isNotBlank(lng)
           */
            
        }      
        return response;
    }
    
    private static void walkThroughAll(String toParse) {
        DOM.Document doc = new DOM.Document();      
        doc.load(toParse);    
        DOM.XMLNode root = doc.getRootElement();
        walkThrough(root,'');
    }
    
    static string long_name;
    static string lat;
    static string lng;
    private static void walkThrough(DOM.XMLNode node, String priorNodeName) {
        if (node.getText().trim() != '') {
            //String fullNodeName = priorNodeName +'.'+ node.getName();
            String NodeName = node.getName();
            String NodeText = node.getText().trim();
            System.debug(NodeName+':'+NodeText+':'+lat+':'+lng);
            if (NodeName == 'long_name')  long_name = NodeText;
            if (NodeName == 'lat')        lat = NodeText;
            if (NodeName == 'lng')        lng = NodeText;
            if (NodeName == 'location_type') {
                if (NodeText=='ROOFTOP' || NodeText=='GEOMETRIC_CENTER') { //can also be: APPROXIMATE
                    responseMap.put('ROOFTOP:lat', lat);                    
                    responseMap.put('ROOFTOP:lng', lng);                    
                }
            }
            if (NodeName=='status') {
                responseMap.put('status', NodeText);                    
            }
            if (NodeName == 'type') {
                responseMap.put(NodeText, long_name);                    
            }      
        }      
        for (Dom.XMLNode child: node.getChildElements()) {
            walkThrough(child, priorNodeName +'.'+ node.getName());
        }
    }
    
}