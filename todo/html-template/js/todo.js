	var todoFlash;
	
	function flashReady (status)
	{
		if (status.success)
		{
			todoFlash = status.ref;
		}
	}

