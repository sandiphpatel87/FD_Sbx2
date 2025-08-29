({
	doInit : function(component, event, helper) {
         //$A.get("e.force:closeQuickAction").fire();
		 var action = component.get('c.createCampaign');  
        action.setParams({  
            oppId : component.get('v.recordId')  
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS") {
                 $A.get("e.force:closeQuickAction").fire();
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Campaign record was created' ,
                    duration:' 4000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                //$A. get('e. force:refreshView'). fire();
               // window.location.href= '/'+result.Id;
            }
            else if (state === "ERROR") {
                 $A.get("e.force:closeQuickAction").fire();
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
            }
        });  
        $A.enqueueAction(action);
	}
})