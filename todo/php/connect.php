<?PHP

    if(basename(__FILE__) == basename($_SERVER['PHP_SELF'])) send_404();

    $dbHost = "localhost";
    $dbUser = "########";
    $dbPass = "########";
    $dbDatabase = "########";

    $db = mysql_connect("$dbHost", "$dbUser", "$dbPass") or die ("Error connecting to database.");
    mysql_select_db("$dbDatabase", $db) or die ("Couldn't select the database.");

    function send_404()
    {
        header('HTTP/1.x 404 Not Found');
        print '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">'."n".
        '<html><head>'."n".
        '<title>404 Not Found</title>'."n".
        '</head><body>'."n".
        '<h1>Not Found</h1>'."n".
        '<p>The requested URL '.
        str_replace(strstr($_SERVER['REQUEST_URI'], '?'), '', $_SERVER['REQUEST_URI']).
        ' was not found on this server.</p>'."n".
        '</body></html>'."n";
        exit;
    }
?>
