public class PaginationCtrl2
{
    public integer totalRecs{get;set;}
    public integer index {get;set;}
    public integer blockSize{get;set;}
    public integer pagevalue{get;set;}
    public integer pageNum{get;set;}
    public integer totPages{get;set;}
    public list<review__c> tempMemb{get;set;}
    
    public PaginationCtrl2()
    {
        tempMemb=new List<review__c>();
        totalRecs = 0;
        index = 0;
        pageNum =1;
        blockSize = 1000;
        pagevalue = 1000;
        totalRecs = [select count() from review__c];
        totPages = (totalRecs /1000)+1;
        gettempMemb();
    }
    
    public List<review__c> gettempMemb()
    {
        tempMemb=Database.Query('SELECT id,Name FROM review__c LIMIT :blockSize OFFSET :index');
        return tempMemb;
    }
    
    public void beginning()
    {
        index = 0;
        pagevalue = index +1000;
        pageNum =0;
        
        gettempMemb();
    }
    
    public void previous()
    {
        pagevalue = index;
        index = index - blockSize;
        pageNum = (pageNum -1)==-1?0:pageNum-1;
        
        gettempMemb();
    }
    
    public void next()
    {
        index = index + blockSize;
        pagevalue = (index +1000)>totalRecs ?totalRecs :(index +1000);
            pageNum = (pageNum == totPages || pageNum+1>totPages) ?totPages :pageNum+1;
        gettempMemb();
    }
    
    public void end()
    {
        index = totalrecs - math.mod(totalRecs,blockSize);
        pagevalue = totalRecs-1000;
        pageNum = totPages;
        gettempMemb();
    }
    
    public boolean getprev()
    {
        if(index == 0)
            return true;
        else
            return false;
    }
    
    public boolean getnxt()
    {
        if((index + blockSize) > totalRecs)
            return true;
        else
            return false;
    }
    
    public void massUpdate()
    {
        update tempMemb;
    }
}