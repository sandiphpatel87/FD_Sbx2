({
    fetchOnHelper : function(component,event,helper) 
    {
        component.set('v.toggleSpinner',true);
        
        var pageSize = component.get("v.pageSize");
        var searchMonth = component.get("v.Month");
        var searchYear = component.get("v.Year");
        var searchDate = component.get("v.Date");
        var searchGroupCode = component.get("v.groupCode");
        var searchGroupName = component.get("v.groupName");
        
        if((component.get("v.Year") == undefined || component.get("v.Year") == "") || component.get("v.Date") != null)
        {
            searchYear = null;
        }
        if(component.get("v.Month") == undefined || component.get("v.Month") == "" || component.get("v.Date") != null)
        {
            searchMonth = null;
        }
        
        var action = component.get("c.fetchOnboarding");
        
        action.setParams({
            "searchMonth": searchMonth,
            "searchYear":searchYear,
            "searchDate":searchDate,
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
    },
    
    getPicklistValues: function(component, event) 
    {
        var action = component.get("c.getMonthFieldValue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result = response.getReturnValue();
                var fieldMap = [];
                for(var key in result)
                {
                    fieldMap.push({key: key, value: result[key]});
                }
                component.set("v.fieldMap", fieldMap);
            }
        });
        $A.enqueueAction(action);
    },
     sortBy: function(component, field) {

        var sortAsc = component.get("v.sortAsc"),

            sortField = component.get("v.sortField"),

            records = component.get("v.paginationList");

        sortAsc = sortField != field || !sortAsc;
debugger;
        records.sort(function(a,b){

            var t1 = a[field] == b[field],

                t2 = (!a[field] && b[field]) || (a[field] < b[field]);

            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);

        });

        component.set("v.sortAsc", sortAsc);

        component.set("v.sortField", field);

        component.set("v.paginationList", records);

        this.renderPage(component);

    },
})