trigger ReservaTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete,
                                    after undelete ) {

    ReservaTriggerHandler reserva = new ReservaTriggerHandler(trigger.isExecuting, trigger.size);


    switch on trigger.operationType{
    when BEFORE_INSERT{
        reserva.beforeInsert(trigger.new);
    }
    when BEFORE_UPDATE{
        reserva.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
    when BEFORE_DELETE{
        
    }
    when AFTER_INSERT{
        
    }
    when AFTER_UPDATE{
        
    }
    when AFTER_DELETE{
        
    }
    when AFTER_UNDELETE{
        
    }
    when else {
        
    }
}
                                    

}