<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>requester</title>
    <script>
        window.onload = function () {
            !function (d, s, u, l, c, h) {
                if (l.search) {
                    d.getElementById(s).value = l.search.substring(1).replace(/[^\d].*$/, "");
                    d.getElementById(u).value = l.search.substring(1).replace(/^\d+/, "");
                }
                h = d.getElementsByTagName("head")[0];
                setInterval(function (j, w) {
                    w = d.getElementById(u).value;
                    if (w && !(++c % d.getElementById(s).value)) {
                        j = d.createElement("script");
                        j.src = w + (w.indexOf("?") > -1 ? "&" : "?") + "__c=" + c;
                        h.appendChild(j);
                        h.removeChild(d.getElementsByTagName("script")[0]);
                    }
                }, 1000);
            }(document, "seconds", "url", location, -1);
        }
    </script>
</head>
<body>
<input id="seconds" size="10" value="" placeholder="delay seconds"/>
<input id="url" value="" placeholder="request url"/>
</body>
</html>