({
   
    
    doInit: function (component, event, helper) {  
        debugger
          var mylist =[
             { label: '1', value: '1' },
            { label: '2', value: '2' },
            { label: '3', value: '3' },
            { label: '4', value: '4' },
            { label: '5', value: '5' },
            { label: '6', value: '6' },
            { label: '7', value: '7' },
            { label: '8', value: '8' },
            { label: '9', value: '9' },
            { label: '10', value: '10' },
            { label: '11', value: '11' },
            { label: '12', value: '12' },
            { label: '13', value: '13' },
            { label: '14', value: '14' },
            { label: '15', value: '15' },
            { label: '16', value: '16' },
            { label: '17', value: '17' }]
        
        component.set("v.options",mylist);
         var action = component.get('c.getCheckbox'); 
         action.setParams({  
            onboardingId : component.get('v.recordId')
            });  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            if ( state === 'SUCCESS' && component.isValid() ) {
                var result = response.getReturnValue();
                component.set('v.onboardRecord',result); 
                                                   
            }
            
        });  
        $A.enqueueAction(action);  
    }, 
    save: function (component, event, helper) {  
        debugger
        var checkedVal = true;
        var checkboxes = component.find("checkboxField");
       
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
            tab :'RPM'
         });  
        action.setCallback(this, function(response) {  
            var state = response.getState();
           if (state === "SUCCESS") {
                component.set("v.spinner", false);
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'RPM Checklist has been successfully updated' ,
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