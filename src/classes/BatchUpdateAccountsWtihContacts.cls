/**
 * Created by vrmoghe on 8/19/2019.
 */

global class BatchUpdateAccountsWtihContacts implements Database.Batchable<sObject>, Database.Stateful {
    Static String COUNTRY_NAME = 'US';
    private Set<Id> accountIds;

    public BatchUpdateAccountsWtihContacts(Set<ID> accountsIDs) {
        accountIds = accountsIDs;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
    String query = 'select Id,AccountId from Contact where AccountId IN :accountIds and MailingCountry =: COUNTRY_NAME';
      return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        Map<Id,list<Contact>> accountMapWithContact = new Map<Id,List<contact>>();
        for(Contact con: scope){

            if (!accountMapWithContact.ContainsKey(con.accountId)) {
                accountMapWithContact.put(con.accountId, new List<Contact>());
            }
            accountMapWithContact.get(con.accountId).add(con);
        }

        List<Account> updateAccounts = new List<Account>();

        for(String key: accountMapwithContact.keyset()){
            Account updateacc = new Account(id=key,Total_US_Contacts__c = accountMapwithContact.get(key).size());
            updateAccounts.add(updateacc);
        }

        if(updateAccounts.size() > 0)
            update updateAccounts;
    }

    global void finish(Database.BatchableContext BC) {

    }
}