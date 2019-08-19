/*
Created by : Vrush M
Description - Trigger to handle contact related processes.
Aug 19 - Added logic to update total number of US Contacts
*/

public class ContactTriggerHandler {
    Static String COUNTRY_NAME = 'US';

    public static void  AfterInsert(){
        CountContactsOnAccounts(trigger.new,null);
    }
    
    public static void afterUpdate(){
        List<Contact> filterContacts = new List<Contact>();
        
        for(Contact con: (List<Contact>)trigger.new){
            Contact oldCon = (Contact)trigger.oldmap.get(con.id);
            if(oldCon.MailingCountry != con.MailingCountry)
                filterContacts.add(con);
        }
        if(filterContacts.size() > 0)
        CountContactsOnAccounts(filterContacts,trigger.oldMap);
    }
    
    Public static void CountContactsOnAccounts(List<Contact> newContacts,Map<Id,sObject> oldContactMap){

        Set<Id> accountIds = new Set<Id>();
        //find out contact with country = US
        //for update check if old value is US or new value is US
        for(Contact con: newContacts){

            if((con.MailingCountry.toUpperCase() == COUNTRY_NAME && oldContactMap == null) ||
                    (oldContactMap != null && oldContactMap.containsKey(con.id) &&
                            (con.MailingCountry.toUpperCase() == COUNTRY_NAME || ((Contact)oldContactMap.get(con.id)).MailingCountry.toUpperCase() == COUNTRY_NAME))){
                accountIds.add(con.AccountId);
            }
        }

        //Reason to move logic to batch job
        //there can be a case where query can return multiple contacts and then trigger will slow down process.
        //so scheduled to run logic after 1 min of update/insert
        if(accountIds.size() > 0){
//
//            String hour = String.valueOf(Datetime.now().hour());
//            String min = String.valueOf(Datetime.now().minute() + 1);
//            String ss = String.valueOf(Datetime.now().second());
//
//             //parse to cron expression
//            String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
//            ScheduleBatchUpdateAccount scheduleUpdateAccount = new ScheduleBatchUpdateAccount(accountIds);
//            system.schedule('After 1 min', nextFireTime, scheduleUpdateAccount);
            BatchUpdateAccountsWtihContacts updateAccountBatchJob = new BatchUpdateAccountsWtihContacts(accountIds);
            database.executeBatch(updateAccountBatchJob,200);
        }
    }
}