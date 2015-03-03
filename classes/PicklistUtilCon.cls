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

    public String objectName 	     {get;set;}
    public String fieldName  	     {get;set;}
    public String picklistValues   {get;set;}
    public boolean isAuthenticated {get;set;}

    public List<SelectOption> allObjects {get;set;}
    public List<SelectOption> pFields 	 {get;set;}
    public String selectedObject 		 {get;set;}
    public String selectedField  		 {get;set;}
    public List<String> messages 		 {get;set;}
    public List<WPicklistEntries> picklistEntries {get;set;}
    public boolean isFieldSelected {get;set;}
		public boolean isSuccess {get;set;}
    public UserWrapper loggedInUser {get;set;}

    private Map<String,List<partnerSoapSforceCom.picklistEntry>> plistEntries;

    private Map<String,String> objectsNameLabelMap;
    private Map<String,String> fNameLabels;
    private String sessionId;
    private String instanceURL;
    private String asyncStatusId;

    private OAuthSettings__c oSettings;

    public PicklistUtilCon(){

        isAuthenticated 	= false;
        isFieldSelected		= false;
				isSuccess         = false;
        loggedInUser      = new UserWrapper();

        allObjects 			= new List<SelectOption>();
        pFields    			= new List<SelectOption>();
        objectsNameLabelMap = new Map<String,String>();
        picklistEntries 	= new List<WPicklistEntries>();
        messages 			    = new List<String>();
        plistEntries 		  = new Map<String,List<partnerSoapSforceCom.picklistEntry>>();

        try {
        	oSettings 			= OAuthSettings__c.getOrgDefaults();
        } catch (Exception e) {
        	messages.add('OAuth Settings not defined');
        }

    }


    public Pagereference OAuthAccess() {

    	if (Apexpages.currentPage().getParameters().get('code') == null) {

      		return null;

      } else {

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

          } catch (System.CalloutException e) {
            messages.add(e.getMessage());
          }

        	if (res.getStatusCode() > 300) {
        		messages.add('Error in Authentication ' + res.getStatus() + ' ' + res.getBody());
            return null;
          }

        	messages.add('Authentication Successful');

        	isAuthenticated = true;

          // Get basic user details.

          partnerSoapSforceCom.GetUserInfoResult userInfo = PartnerManager.getUserInfo(sessionId, instanceURL);

          loggedInUser.userDefaultCurrencyIsoCode = userInfo.userDefaultCurrencyIsoCode;
          loggedInUser.userEmail                  = userInfo.userEmail;
          loggedInUser.userFullName               = userInfo.userFullName;
          loggedInUser.userId                     = userInfo.userId;
          loggedInUser.userLanguage               = userInfo.userLanguage;
          loggedInUser.userName                   = userInfo.userName;
          loggedInUser.userLocale                 = userInfo.userLocale;
          loggedInUser.userTimeZone               = userInfo.userTimeZone;
          loggedInUser.userType                   = userInfo.userType;
          loggedInUser.userUiSkin                 = userInfo.userUiSkin;
          loggedInUser.organizationName           = userInfo.organizationName;

          // Get all objects in the org
        	objectsNameLabelMap = PartnerManager.getGlobalObjects(sessionId, instanceURL);

        	for (String s : objectsNameLabelMap.keySet())
        		allObjects.add(new SelectOption(s,objectsNameLabelMap.get(s)));
      }

      return null;

    }

    public void getPicklistFields() {

    	pFields = new List<SelectOption>();
    	pFields.add(new SelectOption('','-- Select Field (Picklist Type) --'));
    	fNameLabels = new Map<String,String>();
    	fNameLabels  = PartnerManager.getSObjectPicklistFields(sessionId, instanceURL,selectedObject);
    	plistEntries = PartnerManager.picklistEntries;

      for(String s : fNameLabels.keySet()) {
    		pFields.add(new SelectOption(s,fNameLabels.get(s)));
    	}

    }

    public void getPicklistEntries(){

    	isFieldSelected = true;
    	picklistEntries = new List<WPicklistEntries>();

    	for(partnerSoapSforceCom.picklistEntry s : plistEntries.get(selectedField)) {
    		picklistEntries.add(new WPicklistEntries(s.Label));
    	}

    }

    public Pagereference validateUserCredentials(){

      		Pagereference OAuthPage = new Pagereference(oSettings.OAuthURL__c + '&client_id='+oSettings.ClientId__c+'&redirect_uri='+oSettings.RedirectURI__c);
      		return OAuthPage;
    }

    public void insertNewValues() {

        if (picklistValues == '' || picklistValues == null) {
        	messages = new List<String>();
        	messages.add('Enter Picklist values to insert');
        	return;
        }

        isSuccess = PickListManager.addNewPicklistValues(picklistValues,instanceURL,sessionId, selectedObject,selectedField,fNameLabels.get(selectedField));

        if (isSuccess) {
				  getPicklistFields();
				  getPicklistEntries();
        }
    }


    public void issueDelete(){

    	List<String> deletedVals = new List<String>();

    	for (WPicklistEntries w : picklistEntries) {
    		if (w.isSelected) {
    			deletedVals.add(w.pickVal);
    		}
    	}

    	if (deletedVals.size() == 0) {
    		messages.add('Select at least one');
    		return;
    	}

    	isSuccess = PicklistManager.deletePicklist(deletedVals, instanceURL, sessionId, selectedObject, selectedField);

      if (isSuccess) {
			  getPicklistFields();
			  getPicklistEntries();
      }
      
    }

    public class WPicklistEntries {
    	public boolean isSelected {get;set;}
    	public String pickVal     {get;set;}

    	public WPicklistEntries(String pVal){
    		this.isSelected = false;
    		this.pickVal    = pVal;
    	}
    }

    public class UserWrapper {
      public String userDefaultCurrencyIsoCode {get;set;}
      public String userEmail {get;set;}
      public String userFullName {get;set;}
      public String userId {get;set;}
      public String userLanguage {get;set;}
      public String userLocale {get;set;}
      public String userName {get;set;}
      public String userTimeZone {get;set;}
      public String userType {get;set;}
      public String userUiSkin {get;set;}
      public String organizationName {get;set;}
    }

    public class ResponseClass {
        public String id {get;set;}
        public String access_token {get;set;}
        public String instance_url {get;set;}

    }

}