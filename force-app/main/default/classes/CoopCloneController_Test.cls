@isTest
public class CoopCloneController_Test {
    @isTest
    public static void test(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='Feb';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        coop__c obj1 = new coop__c();
        obj1.Bing_Final_URL_Report__c = true;
        obj1.Month__c='Jan';
        obj1.Year__c ='2021';
        obj1.Date__c = Date.today();
        insert obj1;
        /* map<string,string> mapOfCheckboxField = new map<String,string>();
mapOfWCoopField.put('test',true);
mapOfWCoopField.put(fieldLabel,true);*/
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        CoopCloneController.getCoop(obj.Id);
        CoopCloneController.saveCoop(obj);
        CoopCloneController.getPiklistValues();
        customLookUpController.fetchLookUpValues('test','Coop__c');
        CoopEditController.getCoop(obj1.Id);
        CoopEditController.saveCoop(obj1);
        CoopEditController.getPiklistValues();
        CoopTabController.getCoopCheckbox(obj.Id);
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
        
    }
    @isTest
    public static void test1(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='Jan';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
    }
    @isTest
    public static void test2(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='Mar';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
    }
    @isTest
    public static void test3(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='Apr';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
    }
    @isTest
    public static void test4(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='May';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
    }
    @isTest
    public static void test5(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='jun';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
    }
    @isTest
    public static void test6(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='jul';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
    }
    @isTest
    public static void test7(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='aug';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
    }
    @isTest
    public static void test8(){
        coop__c obj = new coop__c();
        obj.Bing_Final_URL_Report__c = true;
        obj.Date__c = Date.today();
        obj.Month__c='sep';
        obj.Year__c ='2024';
        insert obj;
        Working_coop__c objwCoop = new Working_coop__c();
        objwCoop.Bing_Final_URL_Report__c = true;
        objwCoop.coop__c = obj.Id;
        insert objwCoop;
        map<string,object> mapOfCheckboxField = new map<string,object>();
        mapOfCheckboxField.put('Bing Ad Screenshot',true);
        mapOfCheckboxField.put('Facebook Ad Screenshot',true);
        
        CoopTabController.saveCoop(objwCoop,mapOfCheckboxField);
    }
}