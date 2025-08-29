({
    doInit: function (component, event, helper) {  
        debugger
        var action = component.get('c.getCheckbox');  
        action.setParams({  
            onboardingId : component.get('v.recordId')
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            if ( state === 'SUCCESS' && component.isValid() ) {
                var result = response.getReturnValue();
                component.set('v.onboardRecord',result); 
                
                var str =result.Franchise_Type__c;
                if(str != undefined){
                    if( ((str.includes('Acura')) || (str.includes('Honda'))) == true)
                    {
                        component.set('v.isAcuraOrHonda',true); 
                    }
                    if( (str.includes('Subaru'))==true )
                    {
                        component.set('v.isSubaru',true); 
                    }
                    if( (str.includes('Mazda'))==true )
                    {
                        component.set('v.isMazda',true); 
                    }
                }
            }
            
        });  
        $A.enqueueAction(action);  
    }, 
    save: function (component, event, helper) {  
        debugger
         var checkedVal = true;
        var checkboxes = component.find("checkboxField7");
       
        for (var i=0; i<checkboxes.length; i++) {
            if(checkboxes[i].get('v.checked') == false){
                checkedVal = false;
                break;
            }
        }
        component.set("v.spinner", true); 
        var onboardingRecord = component.get('v.onboardRecord');
       	var action = component.get('c.saveOnboarding');  
        action.setParams({  
            onboardingRecord : onboardingRecord,
            checkedVal :checkedVal,
            tab :'7 day launch QA'
         });  
        action.setCallback(this, function(response) {  
            var state = response.getState();
           if (state === "SUCCESS") {
                component.set("v.spinner", false);
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: '7-Day QA Checklist has been successfully updated' ,
                    duration:' 4000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire(); 
                
            }
            else if (state === "ERROR") {
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                    errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message: errors[0].message ,
                            type: 'error',
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.spinner", false);
                 $A.get('e.force:refreshView').fire(); 
            }
        });  
        $A.enqueueAction(action);
    },
    change:function (component, event, helper) { 
        debugger
    },
})