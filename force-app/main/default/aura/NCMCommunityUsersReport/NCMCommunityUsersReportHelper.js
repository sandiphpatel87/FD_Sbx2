({
    fetchOnHelper : function(component,event,helper) {
        debugger
        component.set('v.toggleSpinner',true);
        var pageSize = component.get("v.pageSize");
        var searchNCM20Group = component.get("v.searchNCM20Group");
        
        
        var action = component.get("c.fetchUsers");
        action.setParams({
            "searchNCM20Group":searchNCM20Group
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.onList", response.getReturnValue());
                component.set("v.totalSize", component.get("v.onList").length);
                component.set('v.count',component.get("v.onList").length);
                component.set("v.start",0);
                component.set("v.end",pageSize-1);
                var paginationList = [];
                for(var i=0; i< pageSize; i++) {
                    if(response.getReturnValue()[i] == '' || response.getReturnValue()[i] == undefined)
                    {
                    }
                    else{paginationList.push(response.getReturnValue()[i]);}
                }
                component.set("v.paginationList", paginationList);
                //component.set("v.pageSize", response.getReturnValue().length);
                component.set('v.toggleSpinner',false);
            }
        });
        $A.enqueueAction(action);
    },
})