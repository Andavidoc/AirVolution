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
        reserva.beforeDelete(trigger.old, trigger.oldMap);
    }
    when AFTER_INSERT{
        reserva.afterInsert(trigger.new, trigger.newMap);
    }
    when AFTER_UPDATE{
        reserva.afterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
    when AFTER_DELETE{  
        reserva.afterDelete(trigger.old, trigger.oldMap);
    }
    when AFTER_UNDELETE{
        reserva.afterUndelete(trigger.new, trigger.newMap);
    }
    when else {
        
    }
}
                                    

}