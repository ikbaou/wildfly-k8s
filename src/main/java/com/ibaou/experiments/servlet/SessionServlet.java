package com.ibaou.experiments.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Optional;

@WebServlet("/test")
public class SessionServlet extends HttpServlet {

    private static final String VERSION = "v1.0";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException {

        if ("true".equalsIgnoreCase(request.getParameter("invalidate"))) {
            Optional.ofNullable(request.getSession(false)).ifPresent( HttpSession::invalidate);
        }

        // Get the current session (will create a new session if it doesn't exist)
        HttpSession session = request.getSession(true);

        // Try to retrieve an existing counter from the session
        Integer counter = (Integer) session.getAttribute("counter");

        if (counter == null) {
            // If no counter exists, initialize it
            counter = 0;
        }
        // Increment the counter
        counter++;
        // Store the updated counter back in the session
        session.setAttribute("counter", counter);

        String nodeId = Optional.ofNullable(System.getenv("HOSTNAME")).orElse("N/A");

        // Print a response indicating the counter value
        response.setContentType("text/html");
        try (PrintWriter out = response.getWriter()) {
            out.println("<html><body>");
            out.println("<h3>NodeID: " + nodeId + "</h3>");
            out.println("<h4>Version: " + VERSION + "</h4>");
            out.println("<h4>Session Counter: " + counter + "</h4>");
            out.println("<p>Session ID: " + session.getId() + "</p>");
            out.println("</body></html>");
        } catch (IOException ioe) {
            // do nothing
        }
    }
}
