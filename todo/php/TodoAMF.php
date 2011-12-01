<?php
	session_start();
	require_once('Todo.class.php');

	class TodoAMF
	{

		public function __construct()
		{

		}

		function test()
		{
			return "test!";
		}
	}
?>
