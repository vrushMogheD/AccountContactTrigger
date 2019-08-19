/**
 * Created by vrmoghe on 8/19/2019.
 */

@IsTest
private class ContactTriggerHandlerTest {

    @testSetup static void setup() {
        // Create common test accounts
        Account account1 = new Account(Name = 'TestAcct updateAccount 1');
        insert account1;

        Account account2 = new Account(Name = 'TestAcct updateAccount 2');
        insert account2;

        List<Contact> contacts = new List<Contact>();
        for(Integer index = 0; index < 5; index++) {
            contacts.add(new Contact(AccountId = account1.id, MailingCountry = 'US',firstName='firstname'+index,lastName='lastName'+index));
        }
        for(Integer index = 0; index < 5; index++) {
            contacts.add(new Contact(AccountId = account1.id, MailingCountry = 'UK',firstName='firstname'+index,lastName='lastName'+index));
        }
        for(Integer index = 0; index < 5; index++) {
            contacts.add(new Contact(AccountId = account2.id, MailingCountry = 'US',firstName='firstname'+index,lastName='lastName'+index));
        }
        for(Integer index = 0; index < 5; index++) {
            contacts.add(new Contact(AccountId = account2.id, MailingCountry = 'UK',firstName='firstname'+index,lastName='lastName'+index));
        }

        Test.startTest();
        insert contacts;
        Test.stopTest();
    }

    static testMethod void testUpdateContactNumberONAccountOnInsert() {
        //test insert scenario
        System.assertEquals(5,[SELECT Id,Total_US_Contacts__c FROM Account where Name ='TestAcct updateAccount 1'].Total_US_Contacts__c);
        System.assertEquals(5,[SELECT Id,Total_US_Contacts__c FROM Account where Name ='TestAcct updateAccount 2'].Total_US_Contacts__c);
    }

    static testMethod void testUpdateContactNumberONAccountOnUpdate1() {
        //test update scenario
        List<Contact> contacts = [SELECT id from Contact where  account.Name ='TestAcct updateAccount 1' and  MailingCountry ='US'];
        contacts[0].MailingCountry = 'UK';
        Test.startTest();
        update contacts[0];
        Test.stopTest();

        System.assertEquals(4,[SELECT Id,Total_US_Contacts__c FROM Account where Name ='TestAcct updateAccount 1'].Total_US_Contacts__c);
    }

    static testMethod void testUpdateContactNumberONAccountOnUpdate2() {
        //test update scenario
        List<Contact> contacts = [SELECT id from Contact where  account.Name ='TestAcct updateAccount 1' and  MailingCountry ='UK'];
        contacts[0].MailingCountry = 'US';
        Test.startTest();
        update contacts[0];
        Test.stopTest();

        System.assertEquals(6,[SELECT Id,Total_US_Contacts__c FROM Account where Name ='TestAcct updateAccount 1'].Total_US_Contacts__c);
    }
}