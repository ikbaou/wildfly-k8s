package com.ibaou.experiments.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

@WebServlet(urlPatterns = "/heavy")
public class HeavyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        long start = System.currentTimeMillis();
        while (System.currentTimeMillis() - start < 1000) {
            Math.sqrt(Math.random());
        }

        // Optional: eat memory
        byte[] memoryHog = new byte[50 * 1024 * 1024];
        Arrays.fill(memoryHog, (byte) 42);

        // Print a response indicating the counter value
        response.setContentType("text/plain\n");
        try (PrintWriter out = response.getWriter()) {
            out.println( "took: " + (System.currentTimeMillis() - start ) + "ms" );
        } catch (IOException ioe) {
            // do nothing
        }
    }
}
