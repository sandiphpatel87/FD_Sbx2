({
    getOpportunitiesList : function(component, event, helper) {
        helper.fetchOpportunities(component,event,helper);
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
        helper.sortBy(component,helper, "Contract_Signed_Date__c");
        var a=component.get("v.sortAsc");
        component.set("v.Date",a);
    },
    /*
    next:function(component,event,helper){
        helper.next(component);
    },
    previous:function(component,event,helper){
        helper.previous(component);
    },    
    First:function(component,event,helper){
        helper.First(component);
    },
    Last:function(component,event,helper){
        helper.Last(component);
    },
    onSelectChange: function(component, event, helper) {
        component.set("v.pageSize",component.find("recordSize").get("v.value"));
        helper.paginate(component);
    },
    */
     openVfPage: function(component, event, helper) {
        var oppId = event.target.id;
          var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/apex/OpportunityVfFile?recordId="+oppId
        });
        urlEvent.fire(); 
     },
	 openVfPageAsPdf: function(component, event, helper) {
        var fileId = event.target.id;
         var attachmentUrl = '/servlet/servlet.FileDownload?file='+fileId;    
window.open(attachmentUrl);
          /*
           * var oppId = event.target.id;
           * var urlEvent = $A.get("e.force:navigateToSObject");
      urlEvent.setParams({
            "url":"/apex/OpportunityVfFile?recordId="+oppId+"&isPdf=true"
        });
        /*urlEvent.setParams({
            "url": "/sfc/servlet.shepherd/document/download/"+oppId+"?operationContext=S1"
        });
        urlEvent.fire(); */
     }
     
})