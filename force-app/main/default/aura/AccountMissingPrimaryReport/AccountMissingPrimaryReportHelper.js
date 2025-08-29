({
    fetchOnHelper : function(component,event,helper) {
        debugger
        var pageSize = component.get("v.pageSize");
        var action = component.get("c.fetchAccountNoPrimary");
        action.setParams({
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
                    paginationList.push(response.getReturnValue()[i]);
                }
                component.set("v.paginationList", paginationList);
            }
        });
        $A.enqueueAction(action);
    }
})