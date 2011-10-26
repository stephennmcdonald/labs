package com.leiner.utils
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class DateUtil
	{

		public static function iso8601(iso8601Date:String):Array
		{
			//Description  	
			//This regular expression will parse an ISO8601 date into it's individual parts.
			//Matches 	
			///2009-06-18T18:50:57-06:00, 2009-06-18T18:30:01.123478-06:00, 2009-06-18T18:30:45Z, 2009-06-18T18:39Z
			//Non-Matches 	
			//January 5, 1995, or other non ISO8601 dates.
				
			//Match	             {0]                  [1]  [2] [3]  [4]   [5]  [6]  [7]  [8]   [9] [10]
			//2009-06-20T22:13:24-04:00	2009	 06 20 22	 13   24		     -	 04  00				
				//		var dt="2009-06-20T22:13:24-04:00"				
			//var result=iso8601(dt)
			//trace(result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10])
			var pat:RegExp=/(\d\d\d\d)-?(\d\d)-?(\d\d)T?(\d\d):?(\d\d)(?::?(\d\d)(\.\d+)*?)?(Z|[+-])(?:(\d\d):?(\d\d))?/
			//var result:Array = pat.exec(dt); 
			return pat.exec(iso8601Date); 
		}
		
		public static function maxdays(date:Date):int 
		{
			//get max days for current month 
			var tmp = cloneDate(date);
			tmp.date = 1;
			tmp.month += 1;
			tmp.date-= 1;
			return tmp.date;			
		}
		
		public static function getFirstDay(date:Date):Date
		{	return new Date(date.fullYear, date.month, 1);		}
		
		public static function cloneDate(date:Date):Date
		{	return new Date(date.toString());	}	








	}
	
}