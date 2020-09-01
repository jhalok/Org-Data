trigger ClosedOpportunityTrigger on Opportunity (before insert) {
    List<Task> listTask=new List<Task>();
    for(Opportunity o : Trigger.new){
        if(o.StageName.equals('Closed Won')){
            Task t=new Task(Subject='Follow Up Test Task', WhatId=o.Id);
            listTask.add(t);       
        }
    }
     insert listTask;
}