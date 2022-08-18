trigger TiqueteTrigger on OpportunityLineItem (before insert, before update, before delete, after insert, after update, after delete,
                                    after undelete ) {

    TiqueteTriggerHandler tiquete = new TiqueteTriggerHandler(trigger.isExecuting, trigger.size);


    switch on trigger.operationType{
    when BEFORE_INSERT{
        tiquete.beforeInsert(trigger.new);
        }
    when BEFORE_UPDATE{
        tiquete.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
    when BEFORE_DELETE{
        tiquete.beforeDelete(trigger.old, trigger.oldMap);
    }
    when AFTER_INSERT{
        tiquete.afterInsert(trigger.new,trigger.newMap);
    }
    when AFTER_UPDATE{
        tiquete.afterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
    }
    when AFTER_DELETE{
        tiquete.afterDelete(trigger.old, trigger.oldMap);
    }
    when AFTER_UNDELETE{
        tiquete.afterUndelete(trigger.new, trigger.newMap);
    }
    when else {
        System.debug('no hizo nada');
    }
}
                                    

}