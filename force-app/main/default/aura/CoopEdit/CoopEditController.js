({
    doInit: function (component, event, helper) {  
        debugger
        
       	helper.doInit(component, event, helper);
        var action = component.get('c.getCoop');  
        action.setParams({  
            coopId : component.get('v.recordId')
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();  
            if ( state === 'SUCCESS' && component.isValid() ) {
                var result = response.getReturnValue();
                component.set('v.coopRecord',result.coopObj); 
                if(result.mapOfField != undefined){
                    var custs = [];
                    for(var key in result.mapOfField){
                        var val =result.mapOfField[key];
                        custs.push({value:result.mapOfField[key], key:key, checked:true});
                    }
                    component.set('v.oldCoopRecord',custs); 
                }
                 if(result.mapOfApiName != undefined){
                   component.set('v.mapApiName',result.mapOfApiName);
                }
              
                var keys = [];
                component.find("monthId").set("v.value", result.coopObj.Month__c);
                component.find("yearId").set("v.value", result.coopObj.Year__c);
                if(result.coopObj.Notary_Required__c != undefined){
                    var selectValue= [];
                    var value = result.coopObj.Notary_Required__c;
                    if(value.includes(';')){
                        var splitVal = value.split(';');
                        component.set("v.selectedGenreList", splitVal);
                    }
                    else {
                        keys.push(value);
                        component.set("v.selectedGenreList", keys);
                    }
                }
            }
            
        });  
        $A.enqueueAction(action);  
    },  
    save: function (component, event, helper) {  
        debugger
        var coopRecord = component.get('v.coopRecord');
        
        coopRecord.Month__c = component.find("monthId").get('v.value');
        coopRecord.Year__c = component.find("yearId").get("v.value");
       var selectvalue = component.find("selectGenre").get('v.value');
        var notyValue ='#' ;
         if(selectvalue != undefined && selectvalue.length > 0){
         for (var i = 0; i < selectvalue.length; i++) { 
             notyValue = selectvalue[i]+';'+notyValue;
        }
       coopRecord.Notary_Required__c = notyValue.replace(';#','');
        }
        else{
            coopRecord.Notary_Required__c = null;
        }
        if(component.get("v.selectedLookUpAccount").Id != undefined){
            coopRecord.Account__c = component.get("v.selectedLookUpAccount").Id;
           // coopRecord.Account__r.Name = component.get("v.selectedLookUpAccount").Name;
        } 
        if(component.get("v.selectedLookUpContact4").Id != undefined){
            coopRecord.Contact_4__c = component.get("v.selectedLookUpContact4").Id;
           // coopRecord.Contact_4__r.Name = component.get("v.selectedLookUpContact4").Name;
        }
        if(component.get("v.selectedLookUpContact3").Id != undefined){
            coopRecord.Contact3__c = component.get("v.selectedLookUpContact3").Id;
            // coopRecord.Contact3__r.Name = component.get("v.selectedLookUpContact3").Name;
        }
        if(component.get("v.selectedLookUpContact2").Id != undefined){
            coopRecord.Contact_2__c = component.get("v.selectedLookUpContact2").Id;
           //  coopRecord.Contact_2__r.Name = component.get("v.selectedLookUpContact2").Name;
        }
        if(component.get("v.selectedLookUpContact").Id != undefined){
            coopRecord.Contact__c = component.get("v.selectedLookUpContact").Id;
            // coopRecord.Contact__r.Name = component.get("v.selectedLookUpContact").Name;
        }
        var action = component.get('c.saveCoop');  
        action.setParams({  
            coopObj : coopRecord  
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Coop record was created' ,
                    duration:' 4000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                window.location.href= '/'+result.Id;
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
        
       // coopRecord[value] = check;
        component.set('v.coopRecord',coopRecord);
    },
    closeModel: function (component, event, helper) { 
    $A.get("e.force:closeQuickAction").fire();
    },
})