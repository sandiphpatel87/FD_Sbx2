({
    doInit: function (component, event, helper) { 
        console.log('doInit of component called');
        var columns = [
            {
                type: 'url',
                fieldName: 'AccountURL',
                label: 'Account Name',
                typeAttributes: {
                    label: { fieldName: 'accountName' }
                }
            },
            {
                type: 'type',
                fieldName: 'Type',
                label: 'Type'
            }
            
        ];
        component.set('v.gridColumns', columns);
        
        
        var trecid = component.get('v.recordId');
        //var tsObjectName= component.get('v.ltngSobjectname');
        //var tparentFieldAPIname= component.get('v.ltngParentFieldAPIName');
        //var tlabelFieldAPIName= component.get('v.ltngLabelFieldAPIName');
        if(trecid){
            helper.callToServer(
                component,
                "c.findHierarchyData",
                function(response) {
                    var expandedRows = [];
                    var apexResponse = response;
                    var roles = {};
                    debugger
                    console.log('*******apexResponse:'+JSON.stringify(apexResponse));
                    var results = apexResponse;
                    for (let i = 0; i < apexResponse.length; i++) {
                        if(apexResponse[i].Id == component.get('v.recordId')){
                            component.set("v.accName",apexResponse[i].Name);
                        }
                    }
                    
                    roles[undefined] = { Name: "Root", _children: [] };
                    apexResponse.forEach(function(v) {
                        expandedRows.push(v.Id);
                        roles[v.Id] = { 
                            accountName: v.Name ,
                            name: v.Id, 
                            Type:v.Type__c,
                            Industry:v.Industry,
                            AccountURL:'/'+v.Id,
                            Phone: v.Phone,
                            BillingState: v.BillingState,
                            _children: [] };
                    });
                    apexResponse.forEach(function(v) {
                        roles[v.Sub_Parent__c]._children.push(roles[v.Id]);   
                    });                
                    component.set("v.gridData", roles[undefined]._children);
                    //component.set("v.accName",roles[v.Id].accountName);
                    console.log('*******treegrid data:'+JSON.stringify(roles[undefined]._children));
                    
                    component.set('v.gridExpandedRows', expandedRows);
                }, 
                {
                    recId: component.get('v.recordId')
                }
            );    
        }
        
        
        
        
    }
})