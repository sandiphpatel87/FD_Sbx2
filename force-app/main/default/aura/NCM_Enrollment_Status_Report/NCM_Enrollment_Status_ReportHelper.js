({
    fetchOnHelper : function(component,event,helper) 
    {
        component.set('v.toggleSpinner',true);
        
        var pageSize = component.get("v.pageSize");
        var searchGroupCode = component.get("v.groupCode");
        var searchGroupName = component.get("v.groupName");
                
        var action = component.get("c.getAccountRelatedOpportunityAndContact");
        
        action.setParams({
            "searchGroupCode":searchGroupCode,
            "searchGroupName":searchGroupName
        });
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if (state === "SUCCESS") 
                               {
                                   console.log('Result : ', response.getReturnValue());
                                   component.set("v.onList", response.getReturnValue());
                                   component.set("v.totalSize", component.get("v.onList").length);
                                   component.set('v.count', component.get("v.onList").length);
                                   component.set("v.start", 0);
                                   component.set("v.end", pageSize - 1);
                                   
                                   var paginationList = [];
                                   
                                   for(var i = 0; i < pageSize; i++) 
                                   {
                                       paginationList.push(response.getReturnValue()[i]);
                                   }
                                   
                                   component.set("v.paginationList", paginationList);
                                   component.set('v.toggleSpinner',false);
                               }
                           });
        $A.enqueueAction(action);
    }
    
})