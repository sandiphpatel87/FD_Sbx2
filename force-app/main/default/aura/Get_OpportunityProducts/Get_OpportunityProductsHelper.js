({
	fetchProducts : function(component, event, helper) {
        var action = component.get("c.getProduct");
		var accountId = component.get("v.recordId");
        action.setParams({
            objIds: accountId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //State can be success, error or incomplete
            if(state == 'SUCCESS'){
                var productList = response.getReturnValue();
                console.log(productList);
                component.set("v.productList",productList);
            }
            else{
                //alert('Error in getting data');
            }
        });
	
        $A.enqueueAction(action);
    }
   
})