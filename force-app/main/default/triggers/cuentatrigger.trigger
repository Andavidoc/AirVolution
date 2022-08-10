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
        System.debug('Se eliminará una cuenta');
    }
    when AFTER_INSERT{
        cuenta.afterInsert(trigger.new, trigger.newMap);
    }
    when AFTER_UPDATE{
        System.debug('Se actualizó una cuenta');
    }
    when AFTER_DELETE{
        System.debug('Se eliminó una cuenta');
    }
    when AFTER_UNDELETE{
        System.debug('Se recuperó una cuenta');
    }
    when else {
        System.debug('no hizo nada');
    }
}


}