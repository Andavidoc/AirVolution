trigger VueloTrigger on Product2 (before insert, before update, before delete, after insert, after update, after delete,
                                    after undelete ) {

    VueloTriggerHandler vuelo = new VueloTriggerHandler(trigger.isExecuting, trigger.size);


    switch on trigger.operationType{
    when BEFORE_INSERT{
        vuelo.beforeInsert(trigger.new);
        }
    when BEFORE_UPDATE{
        vuelo.beforeUpdate(trigger.old,trigger.new, trigger.oldMap, trigger.newMap);
    }
    when BEFORE_DELETE{
        vuelo.beforeDelete(trigger.old, trigger.oldMap);
    }
    when AFTER_INSERT{
        vuelo.afterInsert(trigger.new,trigger.newMap);
    }
    when AFTER_UPDATE{
        vuelo.afterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
    when AFTER_DELETE{
        vuelo.afterDelete(trigger.old, trigger.oldMap);
    }
    when AFTER_UNDELETE{
        vuelo.afterUndelete(trigger.new, trigger.newMap);
    }
    when else {
        System.debug('no hizo nada');
    }
}
                                    

}