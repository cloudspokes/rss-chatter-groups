ChatterPheed - Schedulable Class, also invokable on Button Click
RSS Feed - Object to configure Feeds
RSSFeed, RSSFeedTest and XMLDOM - Part of a Force.com Project by Ron Hess (Amended for parsing current RSS Versions, esp dates and timezone adjustments)

Salient Features :
-Sync on / off via the Sync field on RSS Feed
-Customisable Tags per feed, when posting to chatter
-Schedulable


Code for Scheduling (This eg does it 20 mins past the hour)
String sch = '0 20 * * * ?';
system.schedule('RSS Aggregator 20', sch, new ChatterPheed());

