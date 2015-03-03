public class PicklistManager{

	//@Deprecated
	/*
	public static String checkAsyncRequest(String aresult,String sessionId, String instanceURL){
		// Check the status of the retrieve request

        MetadataService.MetadataPort service = createService(sessionId,instanceURL);
        MetadataService.AsyncResult[] aysncResults;

        if(!Test.isRunningTest())
        	aysncResults = service.checkDeployStatus(new String[] { aresult },true);

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

	}*/
    public static Boolean deletePicklist(List<String> picklists,String instanceURL, String sessionId, String objectName,String fieldName){

    	List<MetadataService.Metadata> delData      = new List<MetadataService.Metadata>();
    	List<String> picklistVal				            = new List<String>();
    	MetadataService.MetadataPort service    	  = createService(sessionId,instanceURL);


        for(String s : picklists){

		        MetadataService.Metadata mt 						= new MetadataService.Metadata();
		        metadataservice.PicklistValue newP      = new metadataservice.PicklistValue();
		        newP.fullName                           = objectName + '.' + fieldName +  '.' + s;
		        newP.default_x                          = false ;
		        mt = newP;
		        delData.add(mt);
						picklistVal.add(newP.fullName);
        }

        MetadataService.DeleteResult[] results = service.deleteMetadata('PicklistValue',picklistVal);
        return results[0].success;

    }

   // @future(callout=true)
    public static Boolean addNewPicklistValues(String newValue,String instanceURL, String sessionId, String objectName, String fieldName, String fieldLabel){
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

        MetadataService.SaveResult[] results   = service.updateMetadata(new List<MetadataService.Metadata> {customField});
        return results[0].success;

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