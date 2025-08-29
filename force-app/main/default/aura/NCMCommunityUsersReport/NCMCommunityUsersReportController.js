({
    doInit : function(component, event, helper) {
        helper.fetchOnHelper(component, event, helper);
    },
    showSpinner : function(component,event,helper){
        // display spinner when aura:waiting (server waiting)
        component.set("v.toggleSpinner", true);  
    },
    
    hideSpinner : function(component,event,helper){
        // hide when aura:downwaiting
        component.set("v.toggleSpinner", false);
    },
    first : function(component, event, helper) {
        var oppList = component.get("v.onList");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        for(var i=0; i< pageSize; i++) {
            paginationList.push(oppList[i]);
        }
        component.set("v.paginationList", paginationList);
    },
    
    last : function(component, event, helper) {
        var oppList = component.get("v.onList");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var paginationList = [];
        for(var i=totalSize-pageSize+1; i< totalSize; i++){
            paginationList.push(oppList[i]);
        }
        component.set("v.paginationList", paginationList);
        
    },
    
    next : function(component, event, helper){
        var oppList = component.get("v.onList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(oppList.length > end){
                paginationList.push(oppList[i]);
                counter ++ ;
            }
        }
        start = start + counter;
        
        end = end + counter;
        
        component.set("v.start",start);
        
        component.set("v.end",end);
        
        component.set("v.paginationList", paginationList);
        
    },
    
    previous : function(component, event, helper) {
        var oppList = component.get("v.onList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1) {
                paginationList.push(oppList[i]);
                counter ++;
            }
            else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.start",start);
        component.set("v.end",end);
        
        component.set("v.paginationList", paginationList);
        
    },
    sortByDate: function(component,event, helper) {
        var sortAsc = component.get("v.sortAsc");
        var   sortField = component.get("v.sortField");
        var   records = component.get("v.onList");
        sortAsc = !sortAsc;
        records.sort(function(a,b){
            var t1 = a[sortField] == b[sortField],
                t2 = (!a[sortField] && b[sortField]) || (a[sortField] < b[sortField]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
            
        });
        
        component.set("v.sortAsc", sortAsc);
        component.set("v.paginationList", records);
        this.renderPage(component);
        
    },
    searchData: function(component, event) {
        var searchNCM20Group = component.get("v.searchNCM20Group");
        console.log('searchNCM20Group:::::'+searchNCM20Group);
        var action = component.get("c.fetchUsers");
        action.setParams({
            "searchNCM20Group":searchNCM20Group
        });
        action.setCallback(this, function(a) {
            component.set("v.paginationList", a.getReturnValue());
        });
        $A.enqueueAction(action);
    }   
})