({
    doInit: function (component, event, helper) {  
        debugger
        var action = component.get('c.getCheckbox');  
        action.setParams({  
            campaignId : component.get('v.recordId')
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            if ( state === 'SUCCESS' && component.isValid() ) {
                var result = response.getReturnValue();
                component.set('v.campaignRecord',result); 
            }
        });  
        $A.enqueueAction(action);  
    }, 
     save: function (component, event, helper) {  
        debugger
         
    component.set("v.spinner", true); 
    var campaignRecord = component.get('v.campaignRecord');
       	var action = component.get('c.saveCampaign');  
        action.setParams({  
            campaignRecord : campaignRecord,
            tab :'Upsell'
         });  
        action.setCallback(this, function(response) {  
            var state = response.getState();
           if (state === "SUCCESS") {
                component.set("v.spinner", false);
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Standard Days has been successfully updated' ,
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
})