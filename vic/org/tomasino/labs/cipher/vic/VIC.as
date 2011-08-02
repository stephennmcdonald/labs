package org.tomasino.labs.cipher.vic
{
	public class VIC
	{
		// Series from Key Phrase
		private var _s1:Array;
		private var _s2:Array;
		
		// Message Identifier
		private var _mi:Array;
		private var _date:Array;
		
		// 5D Date expanded to 10 + S1 =
		private var _g:Array;
		
		// Substitution 1234567890 with G =
		private var _t:Array;
		
		// T expanded to 50 (5 rows of 10)
		private var _u:Array;
		
		public function Vic ():void
		{
			/* Begin with seeds for Straddling Checkerboard */
			
				// A T   O N E   S I R
				// 6-8 Digit Date (1-2 digit day, 1-2 digit month, 4 digit year)
				// 20 Character phrase
				// Random Indicator Group 
		}
		
		
		// Methods
		
		/* Chain Addition - Lagged Fibonacci */
		
		/* Sequentialize */
	}
}