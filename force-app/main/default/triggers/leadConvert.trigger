trigger leadConvert on Lead (after update) {
   
        LeadConversion.onLeadConversion(trigger.new);
       
}