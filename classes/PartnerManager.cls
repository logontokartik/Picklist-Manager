public class PartnerManager{

	public static Map<String,List<partnerSoapSforceCom.picklistEntry>> picklistEntries;

    public class ResultsWrapper {

        public Integer successCnt = 0;
        public Integer failCnt 	  = 0;
        public List<String> successIds = new List<String>();
        public List<String> failedErrors  = new List<String>();

    }

		public static partnerSoapSforceCom.GetUserInfoResult getUserInfo(String sessionId, String instanceURL) {

			partnerSoapSforceCom.Soap service      			  = createPartnerService(sessionId,instanceURL);

			return service.getUserInfo();

		}

    public static Map<String,String> getGlobalObjects(String sessionId, String instanceURL){

    	Map<String,String> objectNameLabels = new Map<String,String>();

    	partnerSoapSforceCom.Soap service      			  = createPartnerService(sessionId,instanceURL);
    	partnerSoapSforceCom.DescribeGlobalResult result  = service.describeGlobal();

    	for(partnerSoapSforceCom.DescribeGlobalSObjectResult sobj : result.sobjects){
    		if(sobj.custom)
    			objectNameLabels.put(sobj.name,sobj.label);
    	}

    	return objectNameLabels;


    }

    public static Map<String,String> getSObjectPicklistFields(String sessionId, String instanceUrl, String sobjectType){

    	Map<String,String> fieldLabelNames = new Map<String,String>();
    	picklistEntries					   = new Map<String,List<partnerSoapSforceCom.picklistEntry>>();
    	partnerSoapSforceCom.Soap service      			  = createPartnerService(sessionId,instanceURL);
    	partnerSoapSforceCom.DescribeSObjectResult result = service.describeSObject(sobjectType);
    	List<partnerSoapSforceCom.Field> allFields 		  = result.fields;

    	for(partnerSoapSforceCom.Field f : allFields){
    		system.debug(f);
    		if(f.type_x == 'picklist'){
    			fieldLabelNames.put(f.name,f.label);
    			picklistEntries.put(f.name,f.picklistValues);
    		}
    	}

    	system.debug('Picklist Entries ' + picklistEntries);

    	return fieldLabelNames;

    }

    public static Map<String,String> getPicklistEntries(String fieldName){

    	Map<String,String> picklistEntriesMap = new Map<String,String>();
    	system.debug('picklistEntries.get(fieldName) ' + picklistEntries.get(fieldName) );
    	if(picklistEntries.get(fieldName) != null){
    		 for(partnerSoapSforceCom.PicklistEntry pe : picklistEntries.get(fieldName)){
    		 	picklistEntriesMap.put(pe.value,pe.Label);
    		 }

    	}

    	return picklistEntriesMap;
    }


    public static ResultsWrapper getAndUpdateRecords(String objectName, String fieldNames,String sessionId, String instanceURL){

        boolean done 	  = false;
        integer loopCount = 0;
        ResultsWrapper opResults = new ResultsWrapper();

        List<sobjectPartnerSoapSforceCom.sObject_x> records = new List<sobjectPartnerSoapSforceCom.sObject_x>(); // List to save records.

        partnerSoapSforceCom.Soap service      = createPartnerService(sessionId,instanceURL);
        service.QueryOptions				   = new partnerSoapSforceCom.QueryOptions_element();
        service.QueryOptions.batchSize		   = 500; // Set the Batch Size of number of records to return;

        String soqlQuery = 'SELECT Id, Name, ' + fieldNames + ' FROM ' + objectName; // Build the query

        partnerSoapSforceCom.QueryResult qresult = service.query(soqlQuery);  // Performs the SOAP Call to query the records

        // Loop through the batches of returned results
        while (!done) {
            records.addAll(qresult.records);
			system.debug('Loop Count ' + loopCount++);
            if (qresult.done) {
                done = true;
            } else {
                qresult = service.queryMore(qresult.queryLocator);
            }
        }

        for(sobjectPartnerSoapSforceCom.sObject_x s : records){
               	system.debug('Name ' + s.Name + ' Timezone Old ' +  s.TimeZone);
                String newTimezone = TimezoneManager.getNewTimezoneValue(s.TimeZone);
                if(newTimezone != '')
                    s.TimeZone = newTimezone;
            	system.debug('Name ' + s.Name + ' Timezone New ' +  s.TimeZone);
        }

        partnerSoapSforceCom.SaveResult[] saveResults = service.update_chg(records); // Update the Records with the new Timezone values.

        for (integer j = 0; j < saveResults.size(); j++) {
             if(saveResults[j].success){
                 system.debug('Record updated ' + saveResults[j].id);
                 opResults.successCnt++;
                 opResults.successIds.add(saveResults[j].id);
             }else{
             	 String errMsg = '';
                 for(Integer i=0;i<saveResults[j].errors.size();i++){
                     system.debug('errors ' + saveResults[j].errors[i].message);
                     errMsg += saveResults[j].errors[i].message;
                 }
				 opResults.failCnt++;
                 opResults.failedErrors.add(errMsg);
             }
        }

        return opResults;

    }


    public static partnerSoapSforceCom.Soap createPartnerService(String sessionId, String instanceURL){

        partnerSoapSforceCom.Soap service      = new partnerSoapSforceCom.Soap();
        service.sessionHeader			  	   = new partnerSoapSforceCom.SessionHeader_element();
        service.sessionHeader.sessionId   	   = sessionId;
        service.endpoint_x					   = instanceURL + '/services/Soap/u/27.0';

        return service;

    }

}