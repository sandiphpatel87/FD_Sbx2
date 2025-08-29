({
    fetchOpportunities : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        
        var action = component.get("c.getOpportunities");
        action.setParams({
            loggedInUserId: userId
        });
        
        action.setCallback(this,function(response){
            var state =response.getState();
            if(state === 'SUCCESS'){
                var poList = response.getReturnValue();
                
                component.set("v.pMasterWrapperlist", poList);
                //component.set("v.masterlistSize", component.get("v.pMasterWrapperlist").length);
                //component.set("v.startPosn",0);
                //component.set("v.endPosn",component.get("v.pageSize")-1);
                //this.paginate(component);
            }
            else {
                alert('Error in getting data');
            }  
        });
        $A.enqueueAction(action);
    },
    /*  
    paginate : function(component) {
        var wlist = component.get("v.pMasterWrapperlist");
        component.set("v.pWrapperlist", wlist);
        component.set("v.startPosn",0);
        component.set("v.endPosn",component.get("v.pageSize")-1);
        if(wlist.length > component.get("v.pageSize")){
            var subWrapperlist = [];
            for(var i=0; i<component.get("v.pageSize"); i++){
                subWrapperlist.push(wlist[i]);
            }
            debugger;
            component.set("v.pWrapperlist", subWrapperlist);
            debugger;
        }
    }, 
    next : function(component) {
        var wlist = component.get("v.pMasterWrapperlist");
        var endPosn = component.get("v.endPosn");
        var startPosn = component.get("v.startPosn");
        var subWrapperlist = [];
        for(var i=0; i<component.get("v.pageSize"); i++){
            endPosn++;
            if(wlist.length > endPosn){
                subWrapperlist.push(wlist[endPosn]);
            }
            startPosn++;
        }
        component.set("v.pWrapperlist",subWrapperlist);
        component.set("v.startPosn",startPosn);
        component.set("v.endPosn",endPosn);
    },
    previous : function(component) {
        var wlist = component.get("v.pMasterWrapperlist");
        var startPosn = component.get("v.startPosn");
        var endPosn = component.get("v.endPosn");
        var subWrapperlist = [];
        var pageSize = component.get("v.pageSize");
        startPosn -= pageSize;
        if(startPosn > -1){
            for(var i=0; i<pageSize; i++){
                if(startPosn > -1){
                    subWrapperlist.push(wlist[startPosn]);
                    startPosn++;
                    endPosn--;
                }
            }
            startPosn -= pageSize;
            component.set("v.pWrapperlist",subWrapperlist);
            component.set("v.startPosn",startPosn);
            component.set("v.endPosn",endPosn);
        }
    },
    First : function(component) {
        var wlist = component.get("v.pMasterWrapperlist");
        var startPosn = component.get("v.startPosn");
        var endPosn = component.get("v.endPosn");
        var subWrapperlist = [];
        var pageSize = component.get("v.pageSize");
        startPosn=0;
        if(startPosn > -1){
            for(var i=0; i<pageSize; i++){
                if(startPosn > -1){
                    subWrapperlist.push(wlist[startPosn]);
                    startPosn++;
                }
            }
            startPosn=0;
            endPosn=pageSize-1;
            component.set("v.pWrapperlist",subWrapperlist);
            component.set("v.startPosn",startPosn);
            component.set("v.endPosn",endPosn);
        }
    },
    Last : function(component) {
        var wlist = component.get("v.pMasterWrapperlist");
        var startPosn = component.get("v.startPosn");
        var endPosn = component.get("v.endPosn");
        var subWrapperlist = [];
        var pageSize = component.get("v.pageSize");
        var l=wlist.length;
        var po=l-(l%pageSize);
        if((l%pageSize)!=0){
            startPosn=po;
        }
        else{
            startPosn=po-pageSize;
        }
        endPosn=l-1;
        if(startPosn <=endPosn ){
            for(var i=startPosn; i<=endPosn; i++){
                
                subWrapperlist.push(wlist[i]);
            }
            component.set("v.pWrapperlist",subWrapperlist);
            component.set("v.startPosn",startPosn);
            component.set("v.endPosn",endPosn);
        }
    },
    */
    sortBy: function(component,helper,field) {
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
        component.set("v.pMasterWrapperlist", records);
        //var startPosn = component.get("v.startPosn");
        //var endPosn = component.get("v.endPosn");
        //var pageSize = component.get("v.pageSize");
        //startPosn=0;
        //endPosn=pageSize-1;
        //component.set("v.startPosn", startPosn);
        //component.set("v.endPosn", endPosn);
        //helper.paginate(component);
    }
    
})