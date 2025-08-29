({
    fetchOnboardList : function(component, event, helper) {
        
        const urlParams = new URLSearchParams(window.location.search); // Parse the query string
        const paramValue = urlParams.get('c__accountId'); // Get the value for the parameter
        if (paramValue) {
            component.set("v.recordId", paramValue); // Set the value to the Aura attribute
        }              
        var accRecordId = component.get("v.recordId");
        console.log('Record Id : ', accRecordId);
        var action = component.get("c.getOnboardingRecords");
        action.setParams({
            recordId: accRecordId
        });
        
        action.setCallback(this,function(response){
            var state =response.getState();
            if(state === 'SUCCESS'){
                var poList = response.getReturnValue();
                if(paramValue)
                {
                    component.set("v.pMasterWrapperlist", poList);
                    component.set("v.isShowViewAll", false);
                }
                else
                {
                    component.set("v.pMasterWrapperlist", poList.slice(0, 5));
                    if(poList.length > 5)
                    {
                        component.set("v.isShowViewAll", true);
                    }
                }
                
            }
            else {
                //alert('Error in getting data');
            }  
        });
        $A.enqueueAction(action);
    },
    /*sortBy: function(component,helper,field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.pMasterWrapperlist");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        console.log('Records : ', records);
        component.set("v.pMasterWrapperlist", records);
    }*/
    
    sortBy: function (component, helper, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.pMasterWrapperlist");
        
        sortAsc = sortField !== field || !sortAsc;
        
        // Helper function to dynamically get nested field value
        function getFieldValue(obj, path) {
            return path.split('.').reduce((value, key) => (value && value[key] !== undefined ? value[key] : null), obj);
        }
        
        records.sort(function (a, b) {
            var t1 = getFieldValue(a, field) === getFieldValue(b, field),
                t2 = (!getFieldValue(a, field) && getFieldValue(b, field)) || (getFieldValue(a, field) < getFieldValue(b, field));
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        console.log('Sorted Records:', records);
        component.set("v.pMasterWrapperlist", records);
    }
    
    
})