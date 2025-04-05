package com.ibaou.experiments.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(urlPatterns = "/health")
public class HealthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        // Print a response indicating the counter value
        response.setContentType("application/json\n");
        try (PrintWriter out = response.getWriter()) {
            out.println("{\"status\" : \"UP\"}");
        } catch (IOException ioe) {
            // do nothing
        }
    }
}
