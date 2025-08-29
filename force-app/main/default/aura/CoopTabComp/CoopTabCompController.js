({
    doInit: function (component, event, helper) {  
        debugger
        var action = component.get('c.getCoopCheckbox');  
        action.setParams({  
            coopId : component.get('v.recordId')
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            if ( state === 'SUCCESS' && component.isValid() ) {
                var result = response.getReturnValue();
                if(result.mapSize == 0){
                    component.set('v.truthy',false);
                }
                else{
                    component.set('v.truthy',true);
                }
                component.set('v.coopRecord',result.wCoopObj); 
                if(result.mapOfField != undefined){
                    var custs = [];
                    component.set('v.wCoopCheckValue',result.mapOfWCoop);
                    for(var key in result.mapOfField){
                        var val =result.mapOfField[key];
                        if(result.mapOfWCoopSize > 0 ){
                            for(var keyWCoop in result.mapOfWCoop){
                                if(keyWCoop == key ){
                                    custs.push({value:result.mapOfField[key], key:key, checked:result.mapOfWCoop[keyWCoop]});
                                }
                            }
                        }
                        else{
                            custs.push({value:result.mapOfField[key], key:key, checked:false});  
                        }   
                    }
                    component.set('v.oldCoopRecord',custs); 
                }
                if(result.mapOfApiName != undefined){
                    component.set('v.mapApiName',result.mapOfApiName);
                }
            }
            
        });  
        $A.enqueueAction(action);  
    }, 
    save: function (component, event, helper) {  
        debugger
        component.set("v.spinner", true); 
        var coopRecord = component.get('v.coopRecord');
        var wCoopRecord = component.get('v.wCoopCheckValue')[0];
        var action = component.get('c.saveCoop');  
        action.setParams({  
            coopObj : coopRecord,
            wCoop : wCoopRecord
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.spinner", false);
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Coop record has been successfully updated' ,
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
            }
        });  
        $A.enqueueAction(action);
    },
    change:function (component, event, helper) { 
        debugger
        var label = event.getSource().get('v.label');
        var check = event.getSource().get('v.checked');
        var coopRecord = component.get('v.coopRecord');
        var mapValue = component.get('v.mapApiName');
        var wCoopCheck = component.get('v.wCoopCheckValue');
        if(mapValue[0] != undefined){
            var arry = [];
            for(var key in mapValue[0]){
                console.log('==key=='+key);
                console.log('==label=='+label);
                if(key == label){
                    var val = mapValue[0][key];
                    coopRecord[val] = check;
                    break;
                }
            }
        }             
        if(wCoopCheck[0] != undefined){
            for(var key in wCoopCheck[0]){
                console.log('==key=='+key);
                console.log('==label=='+label);
                if(key == label){
                   wCoopCheck[0][key] = check;
                    break;
                }
            }  
        }
        // coopRecord[value] = check;
        component.set('v.wCoopCheckValue',wCoopCheck);
        component.set('v.coopRecord',coopRecord);
    },
})