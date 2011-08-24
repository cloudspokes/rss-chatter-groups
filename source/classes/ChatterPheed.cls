global class ChatterPheed implements Schedulable{
    
    global void execute (Schedulablecontext sc){
        	
		aggregateRSSFeeds();
		        
    }
 	
 	@future(callout=true)   
    public static void aggregateRSSFeeds(){
		        FeedItem[] chatterPosts = new FeedItem[]{};
        Map<String, Id> chatterGroupIds = new Map<String, Id>{};
        
        RssFeed__c[] rssFeedsConfig = new RssFeed__c[]{};
        String[] chatterGroupNames = new String[]{};
        
        
        for (RSSFeed__c rssFeedCont : [Select Id, Name, Chatter_Group__c, Chatter_Tag__c, 
                                        Last_Run_DateTime__c, RSS_Feed_URL__c from RSSFeed__c where Sync__c = TRUE]){
			chatterGroupNames.add(rssFeedCont.Chatter_Group__c);		
			rssFeedsConfig.add(rssFeedCont);
		}
		
		for(CollaborationGroup cGrp : [Select Id, Name from CollaborationGroup where Name in :chatterGroupNames])
			chatterGroupIds.put(cGrp.Name, cGrp.Id);
		
		for(RssFeed__c rssFeedCont : rssFeedsConfig){
            RSSFeed rss = new rssFeed();
            rss.setCompFeedURL(rssFeedCont.RSS_Feed_URL__c);
            rssFeed.RssEntry[] entries = rss.getfeedcontent();
            
              for (rssFeed.RssEntry e :entries) {  
            	
               Datetime feedDateTime = e.getDate() ;
	           	if( rssFeedCont.Last_Run_DateTime__c == null || feedDateTime > rssFeedCont.Last_Run_DateTime__c){
System.debug('Selecting RSS Post for Publishing , RSSpubDate = ' + feedDateTime + ' LastRunTime = ' + rssFeedCont.Last_Run_DateTime__c);

	            		FeedItem post = new FeedItem();
					
						post.ParentId = chatterGroupIds.get(rssFeedCont.Chatter_Group__c); //eg. Opportunity id, custom object id..
						post.Body = e.getTitle() + ' ' + rssFeedCont.Chatter_Tag__c  ;
						post.LinkUrl = e.getHref();
						
						chatterPosts.add(post);
	            }
            	   
                   system.debug( e.getTitle() + '->' + 
                        e.getAuthor() + ' ' +
                         e.getHref() + e.getDate() + e.getDate2() + e.getIndex() + e.getSummary());  
               }
               
               rssFeedCont.Last_Run_DateTime__c = System.now();
                                            
        }
        
        if(chatterPosts != null && !chatterPosts.isEmpty())
			Database.insert(chatterPosts);
		
		Database.update(rssFeedsConfig)	;    	
    }
	
	
	webservice static void refreshRSSFeed(){
		aggregateRSSFeeds();
	}
	
	public static testMethod void test_ChatterPheed(){
		ChatterPheed.aggregateRSSFeeds();
		refreshRSSFeed();	
		ChatterPheed chPh = new ChatterPheed();
		chPh.execute(null);
	}
}