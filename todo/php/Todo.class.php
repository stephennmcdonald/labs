<?php

	require_once 'Mysql.class.php';

    class Todo
    {
        private $db;

        public function __construct()
        {
            $this->db = Mysql::singleton();
        }

        public function createList($label)
        {
            $result = $this->db->modify('INSERT INTO todo_group (label, status) VALUES(' . $label . ', 5)');
        }

        public function listGroups()
        {
            $result = $this->db->select('SELECT * FROM todo_group');
            return $result->getTable(true);
        }
    }

?>
