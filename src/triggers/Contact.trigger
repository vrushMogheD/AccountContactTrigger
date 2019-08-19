trigger Contact on Contact (after insert,after update) {
    if(trigger.isinsert)
		ContactTriggerhandler.afterInsert();
    if(trigger.isupdate)
        contactTriggerhandler.afterUpdate();
}