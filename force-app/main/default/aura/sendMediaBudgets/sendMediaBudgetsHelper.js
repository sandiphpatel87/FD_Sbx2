({
    getAccontRecord : function( component ) {
        
        var action = component.get("c.fetchAccount"); //Calling Apex class controller 'getAccountRecord' method
        
        action.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.accLst", response.getReturnValue());
            console.log(response.getReturnValue());
            component.set('v.totalrecord',response.getReturnValue().length);// Adding values in Aura attribute variable.   
        });
        $A.enqueueAction(action);
    },
    
    showExampleModal : function(component) {      
        var modal = component.find("exampleModal");
        $A.util.removeClass(modal, 'hideDiv');        
    },
    
    sendEmail : function(component, event, helper) {
       
        var emailResult; 
        var selectedTemp = component.find("tempId").get("v.value"); 
        //console.log('selected Template -> '+selectedTemp);
        //console.log('selected AccIds -> '+component.get("v.selectedAccIds"));
        var fieldList = component.get("v.selectedAccIds");
        var roleType; 
        var btnClickLabel = component.get("v.btnLabel");
        console.log('selected button -> '+btnClickLabel); 
        
        var action = component.get("c.listofEmailTemplates"); //Calling Apex class controller 'getAccountRecord' method
        action.setParams({
            "emailTempName": selectedTemp,
            "accIds":JSON.stringify(fieldList),
            "roleType":btnClickLabel
        }); 
        action.setCallback(this, function(response) {
            debugger
            var state = response.getState(); //Checking response status
            //var result = JSON.stringify(response.getReturnValue());
            var result = response.getReturnValue();
            //if (component.isValid() && state === "SUCCESS"){
                console.log('SUCCESS -> ');
                if(response.getReturnValue() === "Success"){
                   
                    emailResult = "Email Sent";
                    //$A.get("e.force:closeQuickAction").fire();
                    this.showToast(component, event, helper);
                     component.set("v.spinner", false);
                    this.hideExampleModal(component);
                    console.log('Sent -> ');
                }else{
                    emailResult = "Email Fail";
                    console.log('Fail -> ');
                     component.set("v.spinner", false);
                    this.showError(component, event, helper);
                    this.hideExampleModal(component);
                } 
                
           // }
        });
        $A.enqueueAction(action); 
    },
    
    hideExampleModal : function(component) {
        var modal = component.find("exampleModal");
        $A.util.addClass(modal, 'hideDiv');
    },
    
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": "The emails have been sent successfully."
        });
        toastEvent.fire();
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title" : "Error",
            "message":"Invalid Email Template or Apex error",
            "type" : "error"
        });
        toastEvent.fire();
    },
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.accLst");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'NumberOfEmployees'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        //set sorted data to accountData attribute
        component.set("v.accLst",data);
    },
    getConData :function(component, event, helper) {
        debugger
        var emailResult; 
        var selectedTemp = component.find("tempId").get("v.value"); 
        var fieldList = component.get("v.selectedAccIds");
        var roleType; 
        var btnClickLabel = component.get("v.btnLabel");
        console.log('selected button -> '+btnClickLabel); 
        var pageSize = component.get("v.pageSize");
        
        var action = component.get("c.getContactRelation"); //Calling Apex class controller 'getAccountRecord' method
        action.setParams({
            "accIds":JSON.stringify(fieldList),
            "roleType":btnClickLabel
        }); 
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            component.set('v.conRelated',result);
            component.set("v.totalSize", component.get("v.conRelated").length);
            component.set("v.start",0);
            component.set("v.end",pageSize-1);
            var paginationList = [];
            for(var i=0; i< pageSize; i++) {
                if(component.get("v.totalSize") > i ){
                    paginationList.push(response.getReturnValue()[i]);
                }
            }
            component.set("v.paginationList", paginationList);
           
        });
        $A.enqueueAction(action); 
    }
    
})