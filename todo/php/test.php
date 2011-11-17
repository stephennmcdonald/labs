<?php

class Test
{

    private $db;

    public function __construct()
    {
        $this->db = Mysql::singleton();
    }

    public function createList($label)
    {

    }

    public function listGroups()
    {
        $result = $this->db->select('SELECT * FROM groups');
        return $result->getTable(true);
    }
}

$test = new Test();
echo $test->listGroups();


?>

