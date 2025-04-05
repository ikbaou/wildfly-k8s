<%@ page contentType="text/html; charset=UTF-8" %>
<!doctype html>
<html xml:lang="en">
    <head>
        <title>Welcome</title>
    </head>
    <body>
        <ul style="list-style: none">
            <li>check health via <a href="http://localhost:8080/health">health endpoint</a>
            <li>test session via <a href="http://localhost:8080/test">session endpoint</a>
            <li>invalidate session via <a href="http://localhost:8080/test?invalidate=true">session endpoint</a>
        </ul>
    </body>
</html>
