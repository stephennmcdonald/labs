<?php

	require_once 'Mysql.class.php';

    class Todo
    {
        private $db;

        public function __construct()
        {
            $this->db = Mysql::singleton();
        }

        public function addGroup($groupLabel)
        {
            $result = $this->db->modify('INSERT INTO todo_group (label) VALUES(' . $groupLabel . ')');
            return $result;
        }

        public function addItem($groupID, $itemLabel)
        {
            $result = $this->db->modify('INSERT INTO todo_item (group, label) VALUES('. $groupID .', ' . $itemLabel . ')');
            return $result;
        }


        public function removeGroup($groupID)
        {
            $result = $this->db->modify('DELETE FROM todo_group WHERE id = ' . $groupID);
            return $result;
        }

        public function removeItem($itemID)
        {
            $result = $this->db->modify('DELETE FROM todo_item WHERE id = '. $itemID);
            return $result;
        }

        public function getGroup($groupID)
        {
            $result = $this->db->select('SELECT * FROM todo_group WHERE group = ' . $groupID);
            return $result;
        }

        public function getItem($itemID)
        {
            $result = $this->db->select('SELECT * FROM todo_item WHERE id = ' . $itemID);
            return $result;
        }

        public function getItemsInGroup ($groupID)
        {
            $result = $this->db->select('SELECT * FROM todo_item WHERE group = ' . $groupID);
            return $result;
        }

        public function listGroups()
        {
            $result = $this->db->select('SELECT * FROM todo_group');
            return $result->getTable(true);
        }

        public function listItems($groupID)
        {
            $result = $this->db->select('SELECT * FROME todo_item WHERE group = ' . $groupID);
            return $result->getTable(true);
        }
    }

?>
