({
    doInit : function(component, event, helper) 
    {
        helper.fetchOnHelper(component, event, helper);
    },
    
    first : function(component, event, helper) 
    {
        var oppList = component.get("v.onList");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        
        for(var i = 0; i < pageSize; i++) 
        {
            paginationList.push(oppList[i]);
        }
        
        component.set("v.paginationList", paginationList);
    },
    
    last : function(component, event, helper) 
    {
        var oppList = component.get("v.onList");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var paginationList = [];
        
        for(var i = totalSize-pageSize + 1; i < totalSize; i++)
        {
            paginationList.push(oppList[i]);
        }
        component.set("v.paginationList", paginationList);
    },
    
    next : function(component, event, helper)
    {
        var oppList = component.get("v.onList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        
        for(var i = end + 1; i < end + pageSize + 1; i++)
        {
            if(oppList.length > end)
            {
                paginationList.push(oppList[i]);
                counter ++ ;
            }
        }
        start = start + counter;
        end = end + counter;
        
        component.set("v.start", start);
        component.set("v.end", end);
        component.set("v.paginationList", paginationList);
    },
    
    previous : function(component, event, helper) 
    {
        var oppList = component.get("v.onList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        
        for(var i = start - pageSize; i < start ; i++)
        {
            if(i > -1) 
            {
                paginationList.push(oppList[i]);
                counter ++;
            }
            else 
            {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        
        component.set("v.start", start);
        component.set("v.end", end);
        component.set("v.paginationList", paginationList);
    },
    
    sortByDate: function(component,event, helper) 
    {
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        var records = component.get("v.paginationList");
        sortAsc = !sortAsc;
        
        records.sort(function(a,b)
                     {
            var t1 = a[sortField] == b[sortField],
                t2 = (!a[sortField] && b[sortField]) || (a[sortField] < b[sortField]);
            return t1? 0: (sortAsc?-1:1) * (t2?1:-1);
            
        });
        
        component.set("v.sortAsc", sortAsc);
        component.set("v.paginationList", records);
        this.renderPage(component);
    },
    
    searchData: function(component, event) 
    {
        var searchGroupCode = component.get("v.groupCode");
        var searchGroupName = component.get("v.groupName");
        
        var action = component.get("c.fetchOnboarding");
        action.setParams({
            "searchGroupCode":searchGroupCode,
            "searchGroupName":searchGroupName
        });
        action.setCallback(this, function(a) {
            component.set("v.paginationList", a.getReturnValue());
        });
        $A.enqueueAction(action);
    }   
})