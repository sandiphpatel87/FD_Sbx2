({
    
    doInit : function(component, event, helper) {
        component.set('v.mycolumn', [
            {label: 'Account Name', fieldName: 'Name', type: 'text',initialWidth: 350,wrapText :false,sortable : true },
            {label: 'Type', fieldName: 'Type__c', type: 'Text', initialWidth: 350,wrapText :false},
            {label:'Health Flag',initialWidth: 350,wrapText :false,cellAttributes: { class: { fieldName: 'Health_flag_color__c' } }},
        {label: 'Current Month Budget', fieldName: 'Current_Month_Budget__c', type: 'boolean', initialWidth: 350,wrapText :false},
            {label: 'New Month Budget', fieldName: 'New_Month_Budget__c', type: 'boolean', initialWidth: 350,wrapText :false},
            {label: 'All Opportunities', fieldName: 'All_Opportunities__c', type: 'text area', initialWidth: 500,wrapText :false}
     
        ]);
        helper.getAccontRecord(component); // Calling Helper method
        var templateName = $A.get("$Label.c.Email_Template");
        
        var array = [];
        var tempList = [];
        array = templateName.split(',');
        console.log('array -> ' +array[0]);
        
        for(var i=0; i< array.length;i++){
            tempList.push({id: i, label: array[i]});
        }
        /*var serverResponse = {
                selectedTempId: 2,
                templates: [
                    { id: 1, label: 'Media Budget' },
                    { id: 2, label: 'Current Month Media Budget', selected: true },
                    { id: 3, label: 'Old Media Budget' }
                ]
            };*/
        
        component.set('v.options', tempList);
        //component.set('v.selectedValue', serverResponse.selectedTempId);
    },
    
    handleRowAction : function(component, event, helper){
        var selRows = event.getParam('selectedRows');
        component.set('v.selected', selRows.length);
        //console.log('selRows -> ' + JSON.stringify(selRows));
        var selectedRowsIds = [];
        for(var i=0;i<selRows.length;i++){
            selectedRowsIds.push(selRows[i].Id);  
            //console.log('selectedRowsIds -> ' + selectedRowsIds);
        }
        component.set('v.selectedAccIds', selectedRowsIds);
    },
    
    sendEmailTemplate : function(component, event, helper) {
        debugger
         component.set("v.spinner", true);
        helper.sendEmail(component, event, helper);
    },
    
    hideExampleModal : function(component, event, helper) {
        helper.hideExampleModal(component);
    },
    
    showExampleModal : function(component, event, helper) {
        helper.showExampleModal(component);
        var b1=event.getSource('').get('v.label');
        component.set('v.btnLabel',b1);
        helper.getConData(component, event, helper);
    },
    handleSort : function(component,event,helper){
        debugger
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    },
    next : function(component, event, helper){
        debugger
        
       
        var conList = component.get("v.conRelated");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++) {
            if(conList.length > end ) {
                paginationList.push(conList[i]);
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
        debugger
       
        var conList = component.get("v.conRelated");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
         
        var paginationList = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++) {
            if(i > -1) {
                paginationList.push(conList[i]);
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
});