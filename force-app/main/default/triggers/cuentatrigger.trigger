trigger cuentatrigger on Account (before insert, before update, before delete, after insert, after update, after delete,
                        after undelete) {

AccounTriggerHandler cuenta = new AccounTriggerHandler(trigger.isExecuting, trigger.size);

System.debug(trigger.operationType);

switch on trigger.operationType{
    when BEFORE_INSERT{
        cuenta.beforeInsert(trigger.new);
    }
    when BEFORE_UPDATE{
        cuenta.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
    when BEFORE_DELETE{
        cuenta.beforeDelete(trigger.old, trigger.oldMap);
    }
    when AFTER_INSERT{
        cuenta.afterInsert(trigger.new, trigger.newMap);
    }
    when AFTER_UPDATE{
       cuenta.afterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
    when AFTER_DELETE{
        cuenta.afterDelete(trigger.old, trigger.oldMap);
    }
    when AFTER_UNDELETE{
        cuenta.afterUndelete(trigger.new, trigger.newMap);
    }
    when else {
        System.debug('no hizo nada');
    }
}


}