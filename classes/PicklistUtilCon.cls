/**
 * Copyright (c) 2013, Kartik Viswanadha
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 * to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

**/

/*
	Controller Apex Class to handle the Picklist Operations like Insert / Delete via Metadata API 
	This class handles the Authentication via OAuth 2.0. 

*/


public class PicklistUtilCon{
	
    public String username 		   {get;set;}
    public String password 		   {get;set;}
    
    public String objectName 	   {get;set;}
    public String fieldName  	   {get;set;}
    public String picklistValues   {get;set;}
    public boolean isAuthenticated {get;set;}
    public List<BatchJob__c> bJob  {get;set;}
    
    public List<SelectOption> allObjects {get;set;}
    public List<SelectOption> pFields 	 {get;set;}
    public String selectedObject 		 {get;set;}
    public String selectedField  		 {get;set;}
    public List<String> messages 		 {get;set;}
    
    public List<WPicklistEntries> picklistEntries {get;set;}
    
    public boolean isFieldSelected {get;set;}
    public boolean retrieveSuccess {get;set;}
    
   
    private Map<String,List<partnerSoapSforceCom.picklistEntry>> plistEntries;
    
    private Map<String,String> objectsNameLabelMap;
    private map<String,String> fNameLabels;
    private String sessionId;
    private String instanceURL;
    private String asyncStatusId;
    
    private OAuthSettings__c oSettings;
    
    public PicklistUtilCon(){
    	
    	bJob 				= new List<BatchJob__c>();
        isAuthenticated 	= false;
        isFieldSelected		= false;
        retrieveSuccess		= false;
        
        allObjects 			= new List<SelectOption>();
        pFields    			= new List<SelectOption>();
        objectsNameLabelMap = new Map<String,String>();
        picklistEntries 	= new List<WPicklistEntries>();
        messages 			= new List<String>();
        plistEntries 		= new Map<String,List<partnerSoapSforceCom.picklistEntry>>();
        messages.add('Authenticate First');
        try {
        	oSettings 			= OAuthSettings__c.getOrgDefaults();
        }catch(Exception e){
        	messages.add('OAuth Settings not defined');
        }
    
    }
   
    
    public Pagereference OAuthAccess() {
    	
    	if(Apexpages.currentPage().getParameters().get('code') == null){
      		
      		return null;
      		
      	}else {
      		
      		objectsNameLabelMap = new Map<String,String>();
      		allObjects 			= new List<SelectOption>();
      		allObjects.add(new SelectOption('','-- Select Object --'));
      		
      		String code = Apexpages.currentPage().getParameters().get('code');
            Httprequest req = new HttpRequest();    
            req.setMethod('POST');    
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            
            String ClientId = oSettings.ClientId__c;
            String ClientSecret = oSettings.ClientSecret__c;           
                     
            req.setBody('grant_type=authorization_code' + 
                  '&code=' + code + 
                  '&client_id=' + ClientId + 
                  '&client_secret=' + ClientSecret + 
                  '&redirect_uri='+oSettings.RedirectURI__c);     
            
            req.setEndpoint(oSettings.Endpoint__c);         
            Http http = new Http();
            HttpResponse res;
            
            system.debug(res);
            
            try {
              	res = http.send(req);                
                system.debug(res.getBody());
                ResponseClass resp = (ResponseClass)JSON.deserialize(res.getBody(),ResponseClass.class);
                sessionId    	   = resp.access_token;
                instanceURL  	   = resp.instance_url;
                
            }catch(system.CalloutException e){
              messages.add(e.getMessage());	
            }
        	
        	if(res.getStatusCode() > 300){
        		messages.add('Error in Authentication ' + res.getStatus() + ' ' + res.getBody());	
            	return null;
            
            }
        	
        	messages.add('Authentication Successful');
        	
        	isAuthenticated = true;
        	
        	objectsNameLabelMap = PartnerManager.getGlobalObjects(sessionId, instanceURL);
        	
        	for(String s : objectsNameLabelMap.keySet())
        	
        		allObjects.add(new SelectOption(s,objectsNameLabelMap.get(s)));
        	
      		}
      		
      		return null;
    	
    }
    
    public void getPicklistFields(){
    	
    	pFields = new List<SelectOption>();
    	pFields.add(new SelectOption('','-- Select Field (Picklist Type) --'));
    	fNameLabels = new Map<String,String>();
    	
    	fNameLabels  = PartnerManager.getSObjectPicklistFields(sessionId, instanceURL,selectedObject);
    	plistEntries = PartnerManager.picklistEntries;
    	for(String s : fNameLabels.keySet()){
    	
    		pFields.add(new SelectOption(s,fNameLabels.get(s)));
    			
    	}
    	
    }
    
    public void getPicklistEntries(){
    	
    	isFieldSelected = true;
    	
    	picklistEntries = new List<WPicklistEntries>();
    	
    	for(partnerSoapSforceCom.picklistEntry s : plistEntries.get(selectedField)){
    		picklistEntries.add(new WPicklistEntries(s.Label));
    	}
    	
    }
    
    public Pagereference validateUserCredentials(){
      		
      		
      		Pagereference OAuthPage = new Pagereference(oSettings.OAuthURL__c + '&client_id='+oSettings.ClientId__c+'&redirect_uri='+oSettings.RedirectURI__c);
      		
      		return OAuthPage;
      		
      		        
      }
      
    public void checkStatus(){
    	
    	String asyncResult = PicklistManager.checkAsyncRequest(asyncStatusId, sessionId, instanceURL);
    	
    	if(asyncResult == 'true'){
    		retrieveSuccess = true;
    		messages.add('Operation Successful');
    		getPicklistFields();
    		getPicklistEntries();
    		
    	}else if(asyncResult == 'false'){
    		retrieveSuccess = false;
    	}else{
    		retrieveSuccess = true;
    		messages.add(asyncResult); // Error when changing picklist entries
    	}
    	
    }  
    
    public void insertNewValues(){
    	
        if(picklistValues == '' || picklistValues == null){
        	messages = new List<String>();
        	messages.add('Enter Picklist values to insert');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Enter Picklist values to insert '));  
        	return;
        }
        
        asyncStatusId = PickListManager.addNewPicklistValues(picklistValues,instanceURL,sessionId, selectedObject,selectedField,fNameLabels.get(selectedField));
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'New Picklist Values Submitted to be Added - Check by logging into org if they are added'));        
    
    
    }
    
    public void issueDelete(){
    	
    	List<String> deletedVals = new List<String>();
    	
    	for(WPicklistEntries w : picklistEntries){
    		if(w.isSelected){
    			deletedVals.add(w.pickVal);
    		}
    	}
    	
    	if(deletedVals.size() == 0){
    		messages.add('Select at least one');
    		return;
    	}
    	
    	asyncStatusId = PicklistManager.deletePicklist(deletedVals, instanceURL, sessionId, selectedObject, selectedField);
    	
      /*  
        List<AsyncApexJob> apexJobs = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CompletedDate, CreatedBy.Username, CreatedBy.Email from AsyncApexJob where Status IN ('Queued','Processing','Preparing')];
        
        if(apexJobs.size() > 4){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There are already more than 4 jobs queued or processing. Wait for them to finish before submitting another'));  
            return;
        
        }
        
         if(picklistValues == '' || picklistValues == null){
        
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Enter Picklist values to insert '));  
        	return;
        }
        
        bJob = [Select Id, Name, jobId__c,Status__c,Type__c,Username__c from BatchJob__c where Username__c = :username AND Type__c = 'Delete Picklists' AND Status__c = 'New'];
        
        if(bJob.size() > 0){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There is a delete job in progress for this Org.'));  
            return;
        
        }
        
        BatchJob__c newBJob = new BatchJob__c();
        newBJob.Name      = 'Delete Picklists for ' + username;
        newBJOb.Type__c   = 'Delete Picklists';
        newBJob.Status__c = 'New';
        newBJob.Username__c = username;
        
        insert newBJob;
        
        List<String> deletedValues = new List<String>();                
        for(String s :  picklistValues.split(';')){        
            deletedValues.add(s.trim());
        }
        
        BatchPickListDelete bcDelete = new BatchPickListDelete(deletedValues,instanceURL,sessionId,newBJob);
        Id acJobId = Database.executeBatch(bcDelete,5);
        newBJob.JobId__c = acJobId; 
        
        update newBJob;
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Delete batch job submitted. Wait for it to finish and receive an email.'));  */
    }
    
    public class WPicklistEntries {
    	public boolean isSelected {get;set;}
    	public String pickVal     {get;set;}
    	
    	public WPicklistEntries(String pVal){
    		this.isSelected = false;
    		this.pickVal    = pVal;
    	}
    }
    
    public class ResponseClass {
    
        public String id {get;set;}
        public String access_token {get;set;}
        public String instance_url {get;set;}
        
    
    }
    
}