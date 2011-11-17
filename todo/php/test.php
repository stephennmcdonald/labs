<?php

    // Error Reporting
    ini_set('display_errors', 1);
    error_reporting(E_ALL);

    // Includes
    require_once 'Todo.class.php';

    // Magic
    $todo = new Todo();

    echo $todo->listGroups();


?>

