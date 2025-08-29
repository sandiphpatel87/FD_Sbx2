({
	handleEdit : function(component, event, helper) {
		component.set('v.isEdit',true);
	},
    doInit : function(component, event, helper) {
        var action = component.get('c.getEntity'); 
        action.setParams({
            "recordId" : component.get('v.recordId') 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                if(result.Notes__c == undefined && result.Notes__c == null){
                    component.set('v.isEdit',true);
                }
                else{
                  component.set('v.textBoxValue', result.Notes__c);
                }
            }
        });
        $A.enqueueAction(action);
    },
    save : function(component, event, helper) {
        debugger
        var value = component.find('textAreaId').get('v.value');
        var action = component.get('c.saveData'); 
        action.setParams({
            "recordId" : component.get('v.recordId'),
            "Note" : value
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                if(result.Notes__c != undefined && result.Notes__c != null){
                    component.set('v.isEdit',false);
                    component.set('v.textBoxValue', result.Notes__c);
                }
                else{
                    component.set('v.isEdit',true); 
                }
            }
        });
        $A.enqueueAction(action);
    }
})