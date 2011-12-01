<?php
require_once('Zend/Amf/Server.php');
require_once('TodoAMF.php');

$server = new Zend_Amf_Server();
$server->setClass('TodoAMF');

//$server->setClassMap('TrackingVO', 'TrackingVO');

echo $server -> handle();
?>
