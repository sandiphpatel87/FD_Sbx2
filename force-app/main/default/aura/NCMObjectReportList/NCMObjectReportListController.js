({
    getOnboardList : function(component, event, helper) {
        helper.fetchOnboardList(component,event,helper);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){  
        component.set("v.spinner", false);
    },
    sortByName: function(component, event, helper) {
        helper.sortBy(component,helper, "Name"); 
        var a=component.get("v.sortAsc");
        component.set("v.Name",a);
    },
    sortByDate: function(component, event, helper) {
        helper.sortBy(component,helper, "Contract_Signed__c");
        var a=component.get("v.sortAsc");
        component.set("v.Date",a);
    },
    sortByStage: function(component, event, helper) {
        helper.sortBy(component,helper, "Opportunity__r.StageName");
        var a=component.get("v.sortAsc");
        component.set("v.Stage",a);
    },
    calculateWidth : function(component, event, helper) {
        var childObj = event.target
        var parObj = childObj.parentNode;
        var count = 1;
        while(parObj.tagName != 'TH') {
            parObj = parObj.parentNode;
            count++;
        }
        console.log('final tag Name'+parObj.tagName);
        var mouseStart=event.clientX;
        component.set("v.mouseStart",mouseStart);
        component.set("v.oldWidth",parObj.offsetWidth);
    },
    setNewWidth : function(component, event, helper) {
        var childObj = event.target
        var parObj = childObj.parentNode;
        var count = 1;
        while(parObj.tagName != 'TH') {
            parObj = parObj.parentNode;
            count++;
        }
        var mouseStart = component.get("v.mouseStart");
        var oldWidth = component.get("v.oldWidth");
        var newWidth = event.clientX- parseFloat(mouseStart)+parseFloat(oldWidth);
        parObj.style.width = newWidth+'px';
    },
    handleViewAll: function (component, event, helper) {
        const accountId = component.get("v.recordId");
        const url = `/lightning/n/NCM_Report_List?c__accountId=${accountId}`;
        
        // Navigate using window.location
        window.open(url, "_self");
        }
        
        })