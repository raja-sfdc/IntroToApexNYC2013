trigger MerchandiseTrigger on Merchandise__c (after update) {

/*
 // This will result in multiple queries in a loop. Hence not being that effecient, but a good start!
 	for(Merchandise__c merchandise: [SELECT
                                     id,
                                     (select id, name, Invoice__r.name from Line_Items__r
                                      where Invoice__r.status__c = 'Open')
                                    FROM
                                     Merchandise__c
                                    WHERE Status__c = 'Withdrawn'
                                     AND Id in :Trigger.new] ) {

	if (merchandise.Line_Items__r.size() > 0 && Trigger.newMap.get(merchandise.Id).Status__c <> Trigger.oldMap.get(merchandise.Id).Status__c) {
        	Trigger.newMap.get(merchandise.id).Status__c.addError('Sorry.. there are ' + merchandise.line_items__r.size() + ' invoices which are open. Close them first');
    	}

 }
*/

	for (Merchandise__c merchandise : [SELECT
										Id,
										(SELECT
											Id
											FROM 
												Line_Items__r
											WHERE
												Invoice__r.Status__c = 'OPEN'
										)
										FROM
											Merchandise__c
										WHERE
											Status__c = 'Withdrawn' AND
											Id IN :Trigger.new]){
		
		if (merchandise.Line_Items__r.size() > 0 && Trigger.newMap.get(merchandise.Id).Status__c <> Trigger.oldMap.get(merchandise.Id).Status__c){
			Trigger.newMap.get(merchandise.Id).addError('You have open orders using this merchandise, close the orders first!');
		}
	}
}
