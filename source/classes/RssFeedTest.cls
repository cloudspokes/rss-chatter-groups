public class RssFeedTest {
  
  
    public static testMethod void test_cache() {  
     rssFeed rss = new rssFeed();
     rss.feedcachename = 'BoardsFeed';
     rssFeed.RssEntry[] entries = rss.getfeedcontentfromCache();
     
     for (rssFeed.RssEntry e :entries) {  
        system.debug( e.getTitle() + '->' + 
            e.getAuthor() + ' ' +
             e.getHref() );  
            system.debug(e.getSummary());
     }   
    }
    public static testMethod void test_latest() {  
     rssFeed rss = new rssFeed();
     rss.feedcachename = 'latestapps';
     rssFeed.RssEntry[] entries = rss.getfeedcontentfromCache();
     
     for (rssFeed.RssEntry e :entries) {  
        system.debug( e.getTitle() + '->' + 
            e.getAuthor() + ' ' +
             e.getHref() );  
            system.debug(e.getSummary());
     }   
    }
    
    public static testMethod void test_boards() {  
     rssFeed rss = new rssFeed();
     rss.setCompFeedURL('http://community.salesforce.com/rss/board?board.id=general_development');
     rssFeed.RssEntry[] entries = rss.getfeedcontent();
     entries = rss.getfeedcontent();
     rss.getfeedcontentfromCache();
     rss.setCompFeedURL('http://feeds.feedburner.com/SforceBlog');
     entries = rss.getfeedcontent();
     rss.setCompFeedURL('http://www.salesforce.com/appexchange/rssfeed/appexchange_feed.rss?Length=10&NavCode__c=ALLAPPS');
     entries = rss.getfeedcontent();
     rss.setCompFeedURL('http://www.salesforce.com/appexchange/rssfeed/appexchange_feed.rss?Length=10&NavCode__c=ALLAPPS&SortBy=popular');
     entries = rss.getfeedcontent();

     for (rssFeed.RssEntry e :entries) {  
            
            system.debug( e.getTitle() + '->' + 
            e.getAuthor() + ' ' +
             e.getHref() + e.getDate() + e.getDate2() + e.getIndex() + e.getSummary());  
            system.debug(e.getSummary());
        }
    } 
    
    
    
    public static testMethod void test1() { 
     rssFeed rss = new rssFeed();
     rss.setCompFeedURL('');
     string s = rss.getFeedURL();
     rss.setentriesToShow(2);
     Integer rr = rss.getentriesToShow();
     system.debug( rss.getResponse() );

    } 

 
    
    public static testMethod void test_blog() {  
     rssFeed rss = new rssFeed();
     rss.setCompFeedURL('http://feeds.feedburner.com/SforceBlog');
     rssFeed.RssEntry[] entries = rss.getfeedcontent();
     for (rssFeed.RssEntry e :entries) {  
            
            system.debug( e.getTitle() + '->' + e.getAuthor() + ' ' + e.getHref() );  
            system.debug(e.getSummary());
        }
    }
     
     
    public static testMethod void t2() {                
         String testfeed = '<?xml version="1.0" encoding="UTF-8"?>'+
'<feed xmlns="http://purl.org/atom/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0" version="0.3">'+
  '<title>Force.com Blog</title>' +
  '<link rel="alternate" type="text/html" href="http://blog.sforce.com/sforce/" />' +
  '<id>tag:typepad.com,2003:weblog-125619</id>' +
  '<link rel="service.post" type="application/x.atom+xml" href="http://www.typepad.com/t/atom/weblog/blog_id=125619" title="Force.com Blog" />' +
  '<modified>2008-01-23T20:27:30Z</modified>' +
  '<tagline></tagline>' +
  '<generator url="http://www.typepad.com/">TypePad</generator>' +
  '<info type="application/xhtml+xml">' +
  '<div xmlns="http://www.w3.org/1999/xhtml">This is an Atom formatted XML site feed. It is intended to be viewed in a Newsreader or syndicated to another site. Please visit <a href="http://blog.sforce.com/sforce/">Force.com Blog</a> for more info.</div>' +
  '</info>' +
  '<entry>' +
    '<title>Tour de Force Global Kickoff - it\'s a wrap!</title>' +
    '<link rel="alternate" type="text/html" href="http://feeds.feedburner.com/~r/SforceBlog/~3/221839184/tour-de-force-g.html" />' +
    '<link rel="service.edit" type="application/x.atom+xml" href="http://www.typepad.com/t/atom/weblog/blog_id=125619/entry_id=44564390" title="Tour de Force Global Kickoff - it\'s a wrap!" />' +
    '<id>tag:typepad.com,2003:post-44564390</id>' +
    '<issued>2008-01-23T12:27:30-08:00</issued>' +
    '<modified>2008-01-23T20:27:30Z</modified>' +
    '<created>2008-01-23T20:27:30Z</created>' +
    '<summary>Thank you to everyone that joined us last Thursday in San Francisco as we kicked off Tour de Force - we\'re delighted that you were able help us launch the Tour de Force roadshow to unleash the Force.com platform around...</summary>' +
    '<author><name>Mark Trang</name></author>' +
    '<content type="application/xhtml+xml" xml:lang="en-US" xml:base="http://blog.sforce.com/sforce/"><div xmlns="http://www.w3.org/1999/xhtml">'+
    '<p>Thank you to everyone that joined us last Thursday in San Francisco as we kicked off Tour de Force - </p></div></content>'+
    '<feedburner:origLink>http://blog.sforce.com/sforce/2008/01/tour-de-force-g.html</feedburner:origLink></entry></feed>';
     
        rssFeed rss = new rssFeed();
        rss.setCompFeedURL('');
        string s = rss.getFeedURL();
        rss.setentriesToShow(2); 
        Integer rr = rss.getentriesToShow();
        rss.dom = new xmldom(testfeed);
        rss.dom.dumpAll();
        rss.getCompFeedURL();
        rss.dom.toXmlString();
        rssFeed.RssEntry[] ret = new rssFeed.RssEntry[]{};
        for( xmldom.element e: rss.dom.getElementsByTagName('entry')) {
            ret.add( new rssFeed.RssEntry( e,2) );      
        }   
        system.debug(ret);
        for (rssFeed.RssEntry e :ret) {  
            
            system.debug( e.getTitle() + '->' + e.getDate() + ' ' +e.getAuthor() + ' ' + e.getHref() );  
            system.debug(e.getSummary());
        }
    
    }    
    // another rss type looks like this
    /* TODO 
    string feed2test = '<?xml version="1.0" encoding="UTF-8"?>'+
'<rss version="2.0"><channel><title>'+
        '<![CDATA[Latest Listings]]>' +
'</title><link><![CDATA[http://www.salesforce.com/appexchange/]]></link>' +
'<description><![CDATA[Applications in the All Applications category]]></description><language>en-us</language>'+
'<item><title><![CDATA[Absolute Automation: Email to Case]]></title>'+
'<description><![CDATA[Emails going to your support email address automatically create cases in Salesforce.  Emails with an active case number in the subject are automatically logged to the correct case.]]></description>' +
'<link><![CDATA[http://www.salesforce.com/appexchange/detail_overview.jsp?id=a0330000004Zs39AAC]]></link>'+
'<category><![CDATA[Application Integration & Mashups]]></category>' +
'<pubDate><![CDATA[Wed, 30 Jan 2008 12:00:00 GMT]]></pubDate></item></channel></rss>';
                            */
     public static String testrssfeed = '<?xml version="1.0" encoding="UTF-8"?>'+
'<feed xmlns="http://purl.org/atom/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:feedburner="http://rssnamespace.org/feedburner/ext/1.0" version="0.3">'+
  '<item>'+
  '<title>Leaders demand euro governance</title>'+
  '<description>The German chancellor and the French president propose a number of measures to strength the euro, after talks on the eurozone debt crisis.</description>'+
  '<link>http://www.bbc.co.uk/go/rss/int/news/-/news/business-14549358</link>'+ 
  '<guid isPermaLink="false">http://www.bbc.co.uk/news/business-14549358</guid>'+ 
  '<pubDate>Tue, 16 Aug 2011 17:30:31 GMT</pubDate>'+
  '</item>'+
  '<title>Force.com Blog</title>' +
  '<link rel="alternate" type="text/html" href="http://blog.sforce.com/sforce/" />' +
  '<id>tag:typepad.com,2003:weblog-125619</id>' +
  '<link rel="service.post" type="application/x.atom+xml" href="http://www.typepad.com/t/atom/weblog/blog_id=125619" title="Force.com Blog" />' +
  '<modified>2008-01-23T20:27:30Z</modified>' +
  '<tagline></tagline>' +
  '<generator url="http://www.typepad.com/">TypePad</generator>' +
  '<info type="application/xhtml+xml">' +
  '<div xmlns="http://www.w3.org/1999/xhtml">This is an Atom formatted XML site feed. It is intended to be viewed in a Newsreader or syndicated to another site. Please visit <a href="http://blog.sforce.com/sforce/">Force.com Blog</a> for more info.</div>' +
  '</info>' +
  '<entry>' +
    '<title>Tour de Force Global Kickoff - it\'s a wrap!</title>' +
    '<link rel="alternate" type="text/html" href="http://feeds.feedburner.com/~r/SforceBlog/~3/221839184/tour-de-force-g.html" />' +
    '<link rel="service.edit" type="application/x.atom+xml" href="http://www.typepad.com/t/atom/weblog/blog_id=125619/entry_id=44564390" title="Tour de Force Global Kickoff - it\'s a wrap!" />' +
    '<id>tag:typepad.com,2003:post-44564390</id>' +
    '<issued>2008-01-23T12:27:30-08:00</issued>' +
    '<modified>2008-01-23T20:27:30Z</modified>' +
    '<created>2008-01-23T20:27:30Z</created>' +
    '<summary>Thank you to everyone that joined us last Thursday in San Francisco as we kicked off Tour de Force - we\'re delighted that you were able help us launch the Tour de Force roadshow to unleash the Force.com platform around...</summary>' +
    '<author><name>Mark Trang</name></author>' +
    '<content type="application/xhtml+xml" xml:lang="en-US" xml:base="http://blog.sforce.com/sforce/"><div xmlns="http://www.w3.org/1999/xhtml">'+
    '<p>Thank you to everyone that joined us last Thursday in San Francisco as we kicked off Tour de Force - </p></div></content>'+
    '<feedburner:origLink>http://blog.sforce.com/sforce/2008/01/tour-de-force-g.html</feedburner:origLink></entry></feed>';

    public static testmethod void testParsePubDate(){
        String rssPubDate = 'Tue, 16 Aug 2011 17:02:09 EDT';
        System.assertNotEquals(null,RssFeed.parsePubDate(rssPubDate));
        
        rssPubDate = 'Tue, 16 Oct 2011 17:02:09 PDT';
        System.assertNotEquals(null,RssFeed.parsePubDate(rssPubDate)); 
        
        rssPubDate = 'Tue, 16 Dec 2011 17:02:09 MDT';
        System.assertNotEquals(null,RssFeed.parsePubDate(rssPubDate));
        
        rssPubDate = 'Tue, 24 Sep 2011 17:02:09 MST';
        System.assertNotEquals(null,RssFeed.parsePubDate(rssPubDate));
    }
}