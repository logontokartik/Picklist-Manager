Picklist-Manager
================
Manage picklists in any Salesforce Org from one place using OAuth 2.0 and Metadata API

<h2>Working Sites URL</h2>
<a>http://picklist-developer-edition.na15.force.com/</a>

The above is built using Force.com Sites

<h2>Configurartion</h2>
OAuth Custom Settings need to be defined for your application to work with Authentication. Right now I am using only Org wide defaults.
* OAuthURL  	 =  https://login.salesforce.com/services/oauth2/authorize?response_type=code
* Client ID 	 = "Your Client ID setup via Remote Access"
* Client Secrent = "Your Client Secret setup via Remote Access"
* Redirect URI   = "If you are using the Sites, redirect URI is the Sites Home Page"
* OAuthEndpoint  = https://login.salesforce.com/services/oauth2/token 

<TODO>
	* Need to write Apex Test Classes
	* Make it work with Large number of Picklist Value Inserts / Deletes (Batch process?)
		
