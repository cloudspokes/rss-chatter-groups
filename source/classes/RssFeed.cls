/*  
 * read from a feed, return a list of feed entry records
 */
public class RssFeed {
    //public rssFeedController() { system.debug('rssFeedController constructor'); }
    Integer entriesCountd = 5; // provide a default for this 
    public integer getentriesToShow() { return entriesCountd; }
    public void setentriesToShow(integer i) { entriesCountd = i;}
    integer debug = 2;
    string feedURLd;
    //public void setFeedURL(String u) { 
    //      system.debug('set feed url '); 
    //      feedURLd=u; }
    public void setCompFeedURL(String u) { 
            system.debug('set feed url '); 
            feedURLd=u; }
    public String getCompFeedURL() { return feedURLd; }
    public String getFeedURL() { return feedURLd; }
         
    transient HttpResponse res = null;
    public  HttpResponse getResponse() { return this.res; }
    public transient  XMLDom dom {get; set;}

    public string feedcachename { get;set ;}
    
    public  RssEntry[] getfeedcontentfromCache() {
        RssEntry[] ret = new RssEntry[]{};
        Document d = null; 
        try { 
            d = [Select d.Body From Document d where name = :feedcachename limit 1];
        } catch(exception e) { 
            return ret; 
        }
    
        dom = new XMLDom(d.body.tostring());
        if (debug> 5) dom.dumpAll();
        integer i=1;
  
        for( xmldom.element e: dom.getElementsByTagName('entry')) {
            ret.add( new RssEntry( e , i++) );  
            if ( i> entriesCountd) break;
        }   

        if (ret.size() == 0 ) {  // look at alt formats
            list<xmldom.element> items  = dom.getElementsByTagName('item');
            // deal with different formats
            // example, community.salesforce.com has 
            // rss -> channel -> item list ( title, link, description pubDate, date, guid)         
            for( xmldom.element e:items ) {  
                if (debug > 0) { e.dumpAll(); }
                ret.add( new RssEntry( e , i++) );  
                if ( i> entriesCountd) break;
            }
        }
                
        return ret;
    } 
    public  RssEntry[] getfeedcontent() { 
        makeRequest(getCompFeedURL()); 
        string body = res.getBody();
        system.debug( 'lentth :'+body.length());
 
        if (debug> 3) system.debug(body);
         RssEntry[] ret = new RssEntry[]{};
       //  return ret;
        dom = new XMLDom(body);
        if (debug> 3) dom.dumpAll(); 
           
        integer i=1;
  
        for( xmldom.element e: dom.getElementsByTagName('entry')) {
            ret.add( new RssEntry( e , i++) );  
            if ( i> entriesCountd) break;
        }   

        if (ret.size() == 0 ) {  // look at alt formats
            list<xmldom.element> items  = dom.getElementsByTagName('item');
            // deal with different formats
            // example, community.salesforce.com has 
            // rss -> channel -> item list ( title, link, description pubDate, date, guid)         
            for( xmldom.element e:items ) {  
                if (debug > 0) { e.dumpAll(); }
                ret.add( new RssEntry( e , i++) );  
                if ( i> entriesCountd) break;
            }
        }
                
        return ret;
    }
  
    public class RssEntry {

        public RssEntry(Xmldom.Element ein, integer index) { 
            e = ein; idx = index;
        }
        
        // some feeds return <date...
        // others return <created... parse both
       public string getDate2() { 
            try { 
                Pattern p = Pattern.compile('[TZ]'); // cleanup the feed provided datetime
                Matcher m = p.matcher(e.getValue('date'));
                Datetime t = Datetime.valueof( m.replaceAll(' ') ); 
                return '(' + t.format('MMMM d') + ')';  // format it
            } catch ( exception ex) {           
                // also parse this type of date string 
                // Wed, 30 Jan 2008 12:00:00 GMT
                return e.getValue('date');
            }
        } 
        
        public Datetime getDate() { 
            try { 
                
                String longDate = e.getValue('pubDate');
                return RssFeed.parsePubDate(longDate);  // format it
            } catch ( exception ex) {           
                // also parse this type of date string 
                // Wed, 30 Jan 2008 12:00:00 GMT
                return null;
            }
        } 
        
        // some feeds differ in these details
        public integer getIndex() { return idx; }
        public string getSummary() { 
            string ret = e.getValue('summary'); 
            return ret;
        } 
        public string getTitle() { return e.getValue('title'); } 
        public string getHref() { 
            string ret = e.getValue('origLink'); 
            if ( ret == null ) ret   = e.getValue('link'); 
            return ret; 
        }  
        public string getAuthor() { 
            string ret = e.getValue('name'); 
            if ( ret == null ) ret   = e.getValue('creator'); 
            return ret;  
        }    

        Xmldom.Element e; 
        integer idx;    
    }        

    public void makeRequest(string url)  { // leaves result in res instance member
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('GET');    
        /* avoid getting more than we can process on the callout
         * max is 32000, more will throw an exception from the server
         * we could go back for a second range, but this will give ~10 normal blog entries
         */
        req.setHeader('Range','bytes=0-30000');  // not all feeds respect this
        req.setCompressed(true);
        system.debug(req);
        try {
            if(!Test.isRunningTest())
            {
                Http http = new Http();
                res = http.send(req);
                        
// below here is not tested by test methods, this is expected since tests stop at http.send();          
            
                if (res.getStatusCode() != 200 ) {
                    //system.debug(res.toString());
                    System.debug('STATUS:'+res.getStatus());System.debug('STATUS_CODE:'+res.getStatusCode());
                    System.debug('BODY: '+res.getBody());
                }
            }
            else{
                res = new Httpresponse();
                res.setBody(RssFeedTest.testrssfeed);
                res.setStatusCode(200);
            }
            
        } catch( System.Exception e) {
            System.debug('ERROR: '+ e);
        }
    }
    
    public static Datetime parsePubDate(String rssPubDate){
    
        integer dd = integer.valueof(rssPubDate.substring(5,7).trim());
        String month = rssPubDate.substring(8,11).trim();
        integer yyyy = integer.valueof(rssPubDate.substring(12,16).trim());
    
        integer hh = integer.valueof(rssPubDate.substring(17,19).trim());
        integer mi = integer.valueof(rssPubDate.substring(20,22).trim());
        integer ss = integer.valueof(rssPubDate.substring(23,25).trim());
        String timeZone = rssPubDate.substring(26,29);
        
        integer mm= 0;
        
        if(month.equalsIgnoreCase('jan')) mm = 1;  
        else if(month.equalsIgnoreCase('feb')) mm = 2;
        else if(month.equalsIgnoreCase('mar')) mm = 3;
        else if(month.equalsIgnoreCase('apr')) mm = 4;
        else if(month.equalsIgnoreCase('may')) mm = 5;
        else if(month.equalsIgnoreCase('jun')) mm = 6;
        else if(month.equalsIgnoreCase('jul')) mm = 7;
        else if(month.equalsIgnoreCase('aug')) mm = 8;
        else if(month.equalsIgnoreCase('sep')) mm = 9;
        else if(month.equalsIgnoreCase('oct')) mm = 10;
        else if(month.equalsIgnoreCase('nov')) mm = 11;
        else if(month.equalsIgnoreCase('dec')) mm = 12;
        
        Datetime pubDate = dateTime.newInstanceGMT(yyyy, mm, dd, hh, mi, ss);
        
        System.debug('Before TZ Adjustment ' + pubDate);
        if(timeZone != null){
            pubDate = pubDate.addHours(getTimezoneShift(timezone));
            System.debug('Adjusting ' + getTimezoneShift(timezone) +' hours for TimeZone ' + timeZone );
            System.debug(rssPubDate + ' Converted To in GMT' + pubDate);
        }
        return pubDate;  
    }

    private static integer getTimezoneShift(String timeZone){
        
        integer shift = 0;
        
        if(timeZone.equalsIgnoreCase('EDT'))
            shift = 4;
        else if(timeZone.equalsIgnoreCase('EST') || timeZone.equalsIgnoreCase('CDT'))
            shift = 5;
        else if(timeZone.equalsIgnoreCase('MDT'))
            shift = 6;
        else if(timeZone.equalsIgnoreCase('MST') || timeZone.equalsIgnoreCase('PDT'))
            shift = 7;
        else if(timeZone.equalsIgnoreCase('CET') || timeZone.equalsIgnoreCase('BST'))
            shift = -1;
            
        return shift;
    }
    

  
}