trigger MediaBudgetTrigger on Media_Budget__c (before update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Media_Budget__c').getDescribe().fields.getMap();
        for(Media_Budget__c obj : Trigger.new){
            list<String> val0ToxUpdatedList = new list<String>();
            list<String> valxTo0UpdatedList = new list<String>();
            String val0Tox_Field = obj.From_0_to_x__c;
            String valxTo0_Field = obj.From_x_to_0__c;
            String val0ToxUpdated = '';
            String valxTo0Updated = '';
            
            if(Trigger.newMap.get(obj.Id).New_Search__c != Trigger.oldMap.get(obj.Id).New_Search__c ){
                if((Trigger.oldMap.get(obj.Id).New_Search__c == 0 || Trigger.oldMap.get(obj.Id).New_Search__c == null) && Trigger.newMap.get(obj.Id).New_Search__c > 0){
                    val0ToxUpdated = fieldMap.get('New_Search__c').getDescribe().getLabel() +';'+val0ToxUpdated; 
                    val0ToxUpdatedList.add(fieldMap.get('New_Search__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).New_Search__c > 0 && (Trigger.newMap.get(obj.Id).New_Search__c == 0 || Trigger.newMap.get(obj.Id).New_Search__c == null)){
                    valxTo0Updated = fieldMap.get('New_Search__c').getDescribe().getLabel()+';'+valxTo0Updated; 
                    valxTo0UpdatedList.add(fieldMap.get('New_Search__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).Service_Search__c != Trigger.oldMap.get(obj.Id).Service_Search__c ){
                if((Trigger.oldMap.get(obj.Id).Service_Search__c == 0 || Trigger.oldMap.get(obj.Id).Service_Search__c == null) && Trigger.newMap.get(obj.Id).Service_Search__c > 0){
                    val0ToxUpdated = fieldMap.get('Service_Search__c').getDescribe().getLabel() +';'+val0ToxUpdated;
                    val0ToxUpdatedList.add(fieldMap.get('Service_Search__c').getDescribe().getLabel());
                }
                
                if(Trigger.oldMap.get(obj.Id).Service_Search__c > 0 && (Trigger.newMap.get(obj.Id).Service_Search__c == 0 || Trigger.newMap.get(obj.Id).Service_Search__c == null)){
                    valxTo0Updated = fieldMap.get('Service_Search__c').getDescribe().getLabel()+';'+valxTo0Updated; 
                    valxTo0UpdatedList.add(fieldMap.get('Service_Search__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).Display__c != Trigger.oldMap.get(obj.Id).Display__c ){
                if((Trigger.oldMap.get(obj.Id).Display__c == 0 || Trigger.oldMap.get(obj.Id).Display__c == null) && Trigger.newMap.get(obj.Id).Display__c > 0){
                    val0ToxUpdated = fieldMap.get('Display__c').getDescribe().getLabel() +';'+val0ToxUpdated;
                    val0ToxUpdatedList.add(fieldMap.get('Display__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).Display__c > 0 && (Trigger.newMap.get(obj.Id).Display__c == 0 || Trigger.newMap.get(obj.Id).Display__c == null)){
                    valxTo0Updated = fieldMap.get('Display__c').getDescribe().getLabel()+';'+valxTo0Updated;
                    valxTo0UpdatedList.add(fieldMap.get('Display__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).Video__c != Trigger.oldMap.get(obj.Id).Video__c ){
                if((Trigger.oldMap.get(obj.Id).Video__c == 0 || Trigger.oldMap.get(obj.Id).Video__c == null) && Trigger.newMap.get(obj.Id).Video__c > 0){
                    val0ToxUpdated = fieldMap.get('Video__c').getDescribe().getLabel() +';'+val0ToxUpdated;
                    val0ToxUpdatedList.add(fieldMap.get('Video__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).Video__c > 0 && (Trigger.newMap.get(obj.Id).Video__c == 0 || Trigger.newMap.get(obj.Id).Video__c == null)){
                    valxTo0Updated = fieldMap.get('Video__c').getDescribe().getLabel()+';'+valxTo0Updated;
                    valxTo0UpdatedList.add(fieldMap.get('Video__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).FB__c != Trigger.oldMap.get(obj.Id).FB__c ){
                if((Trigger.oldMap.get(obj.Id).FB__c == 0 || Trigger.oldMap.get(obj.Id).FB__c == null) && Trigger.newMap.get(obj.Id).FB__c > 0){
                    val0ToxUpdated = fieldMap.get('FB__c').getDescribe().getLabel() +';'+val0ToxUpdated; 
                    val0ToxUpdatedList.add(fieldMap.get('FB__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).FB__c > 0 && (Trigger.newMap.get(obj.Id).FB__c == 0 || Trigger.newMap.get(obj.Id).FB__c == null)){
                    valxTo0Updated = fieldMap.get('FB__c').getDescribe().getLabel()+';'+valxTo0Updated; 
                    valxTo0UpdatedList.add(fieldMap.get('FB__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).Facebook_Service__c != Trigger.oldMap.get(obj.Id).Facebook_Service__c ){
                if((Trigger.oldMap.get(obj.Id).Facebook_Service__c == 0 || Trigger.oldMap.get(obj.Id).Facebook_Service__c == null) && Trigger.newMap.get(obj.Id).Facebook_Service__c > 0){
                    val0ToxUpdated = fieldMap.get('Facebook_Service__c').getDescribe().getLabel() +';'+val0ToxUpdated;
                    val0ToxUpdatedList.add(fieldMap.get('Facebook_Service__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).Facebook_Service__c > 0 && (Trigger.newMap.get(obj.Id).Facebook_Service__c == 0 || Trigger.newMap.get(obj.Id).Facebook_Service__c == null)){
                    valxTo0Updated = fieldMap.get('Facebook_Service__c').getDescribe().getLabel()+';'+valxTo0Updated;
                    valxTo0UpdatedList.add(fieldMap.get('Facebook_Service__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).Used_Search__c != Trigger.oldMap.get(obj.Id).Used_Search__c ){
                if((Trigger.oldMap.get(obj.Id).Used_Search__c == 0 || Trigger.oldMap.get(obj.Id).Used_Search__c == null) && Trigger.newMap.get(obj.Id).Used_Search__c > 0){
                    val0ToxUpdated = fieldMap.get('Used_Search__c').getDescribe().getLabel() +';'+val0ToxUpdated; 
                    val0ToxUpdatedList.add(fieldMap.get('Used_Search__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).Used_Search__c > 0 && (Trigger.newMap.get(obj.Id).Used_Search__c == 0 || Trigger.newMap.get(obj.Id).Used_Search__c == null)){
                    valxTo0Updated = fieldMap.get('Used_Search__c').getDescribe().getLabel()+';'+valxTo0Updated; 
                    valxTo0UpdatedList.add(fieldMap.get('Used_Search__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).Tech_Fee__c != Trigger.oldMap.get(obj.Id).Tech_Fee__c ){
                if((Trigger.oldMap.get(obj.Id).Tech_Fee__c == 0 || Trigger.oldMap.get(obj.Id).Tech_Fee__c == null) && Trigger.newMap.get(obj.Id).Tech_Fee__c > 0){
                    val0ToxUpdated = fieldMap.get('Tech_Fee__c').getDescribe().getLabel() +';'+val0ToxUpdated;
                    val0ToxUpdatedList.add(fieldMap.get('Tech_Fee__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).Tech_Fee__c > 0 && (Trigger.newMap.get(obj.Id).Tech_Fee__c == 0 || Trigger.newMap.get(obj.Id).Tech_Fee__c == null)){
                    valxTo0Updated = fieldMap.get('Tech_Fee__c').getDescribe().getLabel()+';'+valxTo0Updated; 
                    valxTo0UpdatedList.add(fieldMap.get('Tech_Fee__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).Used_Video__c != Trigger.oldMap.get(obj.Id).Used_Video__c ){
                if((Trigger.oldMap.get(obj.Id).Used_Video__c == 0 || Trigger.oldMap.get(obj.Id).Used_Video__c == null) && Trigger.newMap.get(obj.Id).Used_Video__c > 0){
                    val0ToxUpdated = fieldMap.get('Used_Video__c').getDescribe().getLabel() +';'+val0ToxUpdated; 
                    val0ToxUpdatedList.add(fieldMap.get('Used_Video__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).Used_Video__c > 0 && (Trigger.newMap.get(obj.Id).Used_Video__c == 0 || Trigger.newMap.get(obj.Id).Used_Video__c == null)){
                    valxTo0Updated = fieldMap.get('Used_Video__c').getDescribe().getLabel()+';'+valxTo0Updated;
                    valxTo0UpdatedList.add(fieldMap.get('Used_Video__c').getDescribe().getLabel());
                }
            }
            if(Trigger.newMap.get(obj.Id).Used_Display__c != Trigger.oldMap.get(obj.Id).Used_Display__c ){
                if((Trigger.oldMap.get(obj.Id).Used_Display__c == 0 || Trigger.oldMap.get(obj.Id).Used_Display__c == null) && Trigger.newMap.get(obj.Id).Used_Display__c > 0){
                    val0ToxUpdated = fieldMap.get('Used_Display__c').getDescribe().getLabel() +';'+val0ToxUpdated; 
                    val0ToxUpdatedList.add(fieldMap.get('Used_Display__c').getDescribe().getLabel());
                }
                if(Trigger.oldMap.get(obj.Id).Used_Display__c > 0 && (Trigger.newMap.get(obj.Id).Used_Display__c == 0 || Trigger.newMap.get(obj.Id).Used_Display__c == null)){
                    valxTo0Updated = fieldMap.get('Used_Display__c').getDescribe().getLabel()+';'+valxTo0Updated;
                    valxTo0UpdatedList.add(fieldMap.get('Used_Display__c').getDescribe().getLabel());
                }
            }
            String val_0Tox = '' ;
            String val_xTo0 = '';
            if(val0ToxUpdatedList != null && !val0ToxUpdatedList.isEmpty()){
                for(String str : val0ToxUpdatedList){
                    System.debug('====val0Tox_Field==='+val0Tox_Field);
                    system.debug('=====valxTo0_Field)=='+valxTo0_Field);
                    if(val0Tox_Field != null && !val0Tox_Field.contains(str)){
                        val_0Tox = str+';'+ val_0Tox;
                    }
                    if(valxTo0_Field != null && valxTo0_Field.contains(str)){
                        if(valxTo0_Field.contains(';'+str)){
                            valxTo0_Field = valxTo0_Field.replaceAll(';'+str, '');
                        }
                        else{
                            valxTo0_Field = valxTo0_Field.replaceAll(str+';', '');
                        }
                        system.debug('=====valxTo0_Field 116=='+valxTo0_Field);
                    }
                }
            }
            if(valxTo0UpdatedList != null && !valxTo0UpdatedList.isEmpty()){
                System.debug('====valxTo0_Field==='+valxTo0_Field);
                for(String str1 : valxTo0UpdatedList){
                    if(valxTo0_Field != null && !valxTo0_Field.contains(str1)){
                        val_xTo0 = str1+';'+ val_xTo0;
                    }
                    
                    if(val0Tox_Field != null && val0Tox_Field.contains(str1)){
                        if(val0Tox_Field.contains(';'+str1)){
                            val0Tox_Field = val0Tox_Field.replaceAll(';'+str1, '');
                        }
                        else{
                            val0Tox_Field = val0Tox_Field.replaceAll(str1+';', ''); 
                        }
                        system.debug('=====val0Tox_Field 123=='+val0Tox_Field);
                    }   
                }
            }
            System.debug('===valxTo0UpdatedList===='+valxTo0UpdatedList);
            System.debug('===val0ToxUpdatedList===='+val0ToxUpdatedList);
            System.debug('===valxTo0_Field===='+valxTo0_Field);
            System.debug('===val0Tox_Field===='+val0Tox_Field);
            System.debug('===val0ToxUpdated===='+val0ToxUpdated);
            System.debug('===valxTo0Updated===='+valxTo0Updated);
            
            if((valxTo0UpdatedList != null && !valxTo0UpdatedList.isEmpty()) || (val0ToxUpdatedList != null && !val0ToxUpdatedList.isEmpty())){
                if(val0Tox_Field != null){
                    obj.From_0_to_x__c = val0Tox_Field+ val_0Tox;
                }
                else{
                    obj.From_0_to_x__c = val0ToxUpdated;
                }
                if(valxTo0_Field != null){
                    obj.From_x_to_0__c = valxTo0_Field + val_xTo0;
                }
                else{
                    obj.From_x_to_0__c = valxTo0Updated;
                }
            }
        }
        
    }
}