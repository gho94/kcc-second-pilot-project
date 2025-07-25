package com.secondproject.cooook.filter;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;


public class FileLogFilter extends HttpFilter implements Filter {
	private static final long serialVersionUID = 1L;
	private File logFile;
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

	public void init(FilterConfig fConfig) throws ServletException {
        String logFilePath = fConfig.getServletContext().getRealPath("/") + "logs/app.log";
        File logDir = new File(fConfig.getServletContext().getRealPath("/") + "logs");
        if (!logDir.exists()) {
            logDir.mkdirs();
        }
        System.out.println(logFilePath);
        logFile = new File(logFilePath);
	}


	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;

        long start = System.currentTimeMillis();

        // 요청 전 로그 기록
        writeLog(String.format("START: %s %s", req.getMethod(), req.getRequestURI()));

        chain.doFilter(request, response);

        long duration = System.currentTimeMillis() - start;

        // 요청 후 로그 기록
        writeLog(String.format("END: %s %s - %d ms", req.getMethod(), req.getRequestURI(), duration));
	}

    private synchronized void writeLog(String message) {
        String timeStamp = sdf.format(new Date());
        String logMsg = timeStamp + " - " + message + System.lineSeparator();

        try (FileWriter fw = new FileWriter(logFile, true);
             BufferedWriter bw = new BufferedWriter(fw)) {
            bw.write(logMsg);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
