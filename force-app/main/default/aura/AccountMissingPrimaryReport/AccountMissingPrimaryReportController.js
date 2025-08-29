({
    doInit : function(component, event, helper) {
       
        helper.fetchOnHelper(component, event, helper);
        
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
        
    }
})