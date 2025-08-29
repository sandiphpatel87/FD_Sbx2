trigger UpdateDMA1 on Account (before insert, before update) {
    
    
    if(Trigger.IsInsert){
        UpdateDMA1Helper.updateDMABeforeInsert(Trigger.new);
    }
    if(Trigger.IsUpdate){
        UpdateDMA1Helper.updateDMABeforeUpdate(Trigger.new,Trigger.OldMap);
    }
   
    
}