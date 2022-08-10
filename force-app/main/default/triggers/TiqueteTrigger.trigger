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
        System.debug('Se eliminará una cuenta');
    }
    when AFTER_INSERT{
        System.debug('Se Insertó una cuenta');
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