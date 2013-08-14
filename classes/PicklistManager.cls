public class PicklistManager{
	
	public static String checkAsyncRequest(String aresult,String sessionId, String instanceURL){
		// Check the status of the retrieve request
        
        MetadataService.MetadataPort service = createService(sessionId,instanceURL);
        MetadataService.AsyncResult[] aysncResults;
        
        if(!Test.isRunningTest())
        	aysncResults = service.checkStatus(new String[] { aresult });
        
        if(aysncResults[0].done){
            // Errors?
            if(aysncResults[0].state == 'Error'){
                system.debug(aysncResults[0].message);
                return aysncResults[0].message;       
            }else{
              	
              	if(aysncResults[0].state == 'InProgress')
             		return 'false';
             	else 
             		return 'true';	  
            }
        }else{
            return 'false';
        }   

        return null;
		
	}
    public static String deletePicklist(List<String> picklists,String instanceURL, String sessionId, String objectName,String fieldName){
    	
    	List<MetadataService.Metadata> delData      = new List<MetadataService.Metadata>();
    	List<String> picklistVal				    = new List<String>();
    	MetadataService.MetadataPort service    	= createService(sessionId,instanceURL);    	
       
        
        for(String s : picklists){
        	
		        MetadataService.Metadata mt 			= new MetadataService.Metadata();	        
		        metadataservice.PicklistValue newP      = new metadataservice.PicklistValue();
		        newP.fullName                           = objectName + '.' + fieldName +  '.' + s;
		        newP.default_x                          = false ;        
		        mt = newP;
		        delData.add(mt);        	
        }
        
        MetadataService.AsyncResult[] results = service.deleteMetadata(delData);
        return results[0].id;
        
    }
    
   // @future(callout=true)
    public static String addNewPicklistValues(String newValue,String instanceURL, String sessionId, String objectName, String fieldName, String fieldLabel){
        if(newValue == null)
            return null;
        
        List<String> newPickvalues              = newValue.split(';');
        List<metadataservice.PicklistValue> newpicklists = new list<metadataservice.PicklistValue>();
        
        MetadataService.MetadataPort service    = createService(sessionId,instanceURL);     
        MetadataService.CustomField customField = new MetadataService.CustomField();        
        customField.label                       = fieldLabel;
        customField.fullName                    = objectName + '.' + fieldName;
        customField.type_x                      = 'Picklist';
        metadataservice.Picklist pt             = new metadataservice.Picklist();
        pt.sorted                               = true;
        
        for(String s : newPickvalues){
          metadataservice.PicklistValue newP      = new metadataservice.PicklistValue();
          newP.fullName                           = s.trim();
          newP.default_x                          = false ;
            newpicklists.add(newP);
        }
        
        pt.picklistValues                       = newpicklists;
        customField.picklist                    = pt ;         
        MetadataService.UpdateMetadata ut       = new MetadataService.UpdateMetadata();
        ut.currentName                          = objectName + '.' + fieldName;
        ut.metadata                             = customField; 
         
        MetadataService.AsyncResult[] results   = service.updateMetadata(new List<MetadataService.updateMetadata> {ut});
        return results[0].Id;
        
    }
    
    public static MetadataService.MetadataPort createService(String session,String instanceURL)
    
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = session;
        service.endpoint_x = instanceURL + '/services/Soap/m/25.0';
        return service;     
    }    
    
}