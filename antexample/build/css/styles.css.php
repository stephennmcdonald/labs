<?php

    //##################################################################
    //#########################  COMPRESS CSS  #########################
    //##################################################################

    ob_start ("ob_gzhandler");
    header ("content-type: text/css; charset: UTF-8");
    header ("cache-control: must-revalidate");
    header ("expires: " . gmdate ("D, d M Y H:i:s", time() + 3600) . " GMT");

    //##################################################################
    //#########################  CSS FILE LIST  ########################
    //##################################################################




    $css = array (
        'reset.css',
        'master.css',
    );




    //##################################################################
    //#########################  PROCESS  CSS  #########################
    //##################################################################


    $_inHack = true;

    function minify($css) // From Google Minify
    {
        $css = str_replace("\r\n", "\n", $css);

        // preserve empty comment after '>'
        // http://www.webdevout.net/css-hacks#in_css-selectors
        $css = preg_replace('@>/\\*\\s*\\*/@', '>/*keep*/', $css);

        // preserve empty comment between property and value
        // http://css-discuss.incutio.com/?page=BoxModelHack
        $css = preg_replace('@/\\*\\s*\\*/\\s*:@', '/*keep*/:', $css);
        $css = preg_replace('@:\\s*/\\*\\s*\\*/@', ':/*keep*/', $css);

        // apply callback to all valid comments (and strip out surrounding ws
        $css = preg_replace_callback('@\\s*/\\*([\\s\\S]*?)\\*/\\s*@', '_commentCB', $css);

        // remove ws around { } and last semicolon in declaration block
        $css = preg_replace('/\\s*{\\s*/', '{', $css);
        $css = preg_replace('/;?\\s*}\\s*/', '}', $css);

        // remove ws surrounding semicolons
        $css = preg_replace('/\\s*;\\s*/', ';', $css);

        // remove ws around urls
        $css = preg_replace('/
                url\\(      # url(
                \\s*
                ([^\\)]+?)  # 1 = the URL (really just a bunch of non right parenthesis)
                \\s*
                \\)         # )
            /x', 'url($1)', $css);

        // remove ws between rules and colons
        $css = preg_replace('/
                \\s*
                ([{;])              # 1 = beginning of block or rule separator
                \\s*
                ([\\*_]?[\\w\\-]+)  # 2 = property (and maybe IE filter)
                \\s*
                :
                \\s*
                (\\b|[#\'"-])        # 3 = first character of a value
            /x', '$1$2:$3', $css);

        // remove ws in selectors
        $css = preg_replace_callback('/
                (?:              # non-capture
                    \\s*
                    [^~>+,\\s]+  # selector part
                    \\s*
                    [,>+~]       # combinators
                )+
                \\s*
                [^~>+,\\s]+      # selector part
                {                # open declaration block
            /x', '_selectorsCB', $css);

        // minimize hex colors
        $css = preg_replace('/([^=])#([a-f\\d])\\2([a-f\\d])\\3([a-f\\d])\\4([\\s;\\}])/i'
            , '$1#$2$3$4$5', $css);

        $css = preg_replace('/@import\\s+url/', '@import url', $css);

        // replace any ws involving newlines with a single newline
        $css = preg_replace('/[ \\t]*\\n+\\s*/', "\n", $css);

        // separate common descendent selectors w/ newlines (to limit line lengths)
        $css = preg_replace('/([\\w#\\.\\*]+)\\s+([\\w#\\.\\*]+){/', "$1\n$2{", $css);

        // Use newline after 1st numeric value (to limit line lengths).
        $css = preg_replace('/
            ((?:padding|margin|border|outline):\\d+(?:px|em)?) # 1 = prop : 1st numeric value
            \\s+
            /x'
            ,"$1\n", $css);

        // prevent triggering IE6 bug: http://www.crankygeek.com/ie6pebug/
        $css = preg_replace('/:first-l(etter|ine)\\{/', ':first-l$1 {', $css);

        return trim($css);
    }

    function _selectorsCB($m)
    {
        // remove ws around the combinators
        return preg_replace('/\\s*([,>+~])\\s*/', '$1', $m[0]);
    }

    function _commentCB($m)
    {
        global $_inHack;

        $hasSurroundingWs = (trim($m[0]) !== $m[1]);
        $m = $m[1];
        // $m is the comment content w/o the surrounding tokens,
        // but the return value will replace the entire comment.
        if ($m === 'keep') {
            return '/**/';
        }
        if ($m === '" "') {
            // component of http://tantek.com/CSS/Examples/midpass.html
            return '/*" "*/';
        }
        if (preg_match('@";\\}\\s*\\}/\\*\\s+@', $m)) {
            // component of http://tantek.com/CSS/Examples/midpass.html
            return '/*";}}/* */';
        }
        if ($_inHack) {
            // inversion: feeding only to one browser
            if (preg_match('@
                    ^/               # comment started like /*/
                    \\s*
                    (\\S[\\s\\S]+?)  # has at least some non-ws content
                    \\s*
                    /\\*             # ends like /*/ or /**/
                @x', $m, $n)) {
                // end hack mode after this comment, but preserve the hack and comment content
                $_inHack = false;
                return "/*/{$n[1]}/**/";
            }
        }
        if (substr($m, -1) === '\\') { // comment ends like \*/
            // begin hack mode and preserve hack
            $_inHack = true;
            return '/*\\*/';
        }
        if ($m !== '' && $m[0] === '/') { // comment looks like /*/ foo */
            // begin hack mode and preserve hack
            $_inHack = true;
            return '/*/*/';
        }
        if ($_inHack) {
            // a regular comment ends hack mode but should be preserved
            $_inHack = false;
            return '/**/';
        }
        // Issue 107: if there's any surrounding whitespace, it may be important, so
        // replace the comment with a single space
        return $hasSurroundingWs // remove all other comments
            ? ' '
            : '';
    }


    $buffer = '';
    for ($i = 0; $i < count($css); $i++ )
    {
        $filename = $css[$i];
        if (is_file($filename))
        {
            $buffer .= "\n" . file_get_contents ($filename);
        }
    }
    $buffer = minify($buffer);
    echo $buffer;
?>

