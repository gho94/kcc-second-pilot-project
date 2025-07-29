package com.secondproject.cooook.filter;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


public class FileLogFilter extends HttpFilter implements Filter {    
	private static final long serialVersionUID = 1L;
    private static final String LOG_LEVEL = "INFO";
	private File logFile;
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

	public void init(FilterConfig fConfig) throws ServletException {
        String logFilePath = fConfig.getServletContext().getRealPath("/") + "logs/" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + ".log";
        File logDir = new File(fConfig.getServletContext().getRealPath("/") + "logs");
        if (!logDir.exists()) {
            logDir.mkdirs();
        }
        logFile = new File(logFilePath);
	}


	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        long start = System.currentTimeMillis();

        String requestId = generateRequestId();
        String userAgent = req.getHeader("User-Agent");
        String referer = req.getHeader("Referer");
        String clientIP = getClientIP(req);
        HttpSession session = req.getSession(false);
        String sessionId = session != null ? session.getId() : "NO_SESSION";
        
        String userId = "ANONYMOUS";
        if (session != null && session.getAttribute("staff") != null) {
            try {
                com.secondproject.cooook.model.Staff staff = (com.secondproject.cooook.model.Staff) session.getAttribute("staff");
                userId = String.valueOf(staff.getStaffId());
            } catch (Exception e) {
                userId = "UNKNOWN_USER";
            }
        }

        //요청 전 상세 로그
        writeLog("INFO", String.format("[%s] REQUEST START", requestId));
        writeLog("INFO", String.format("[%s] Method: %s, URI: %s", requestId, req.getMethod(), req.getRequestURI()));
        writeLog("INFO", String.format("[%s] Client IP: %s, User-Agent: %s", requestId, clientIP, userAgent));
        writeLog("INFO", String.format("[%s] Session ID: %s, User ID: %s", requestId, sessionId, userId));
        
        if (referer != null) {
            writeLog("INFO", String.format("[%s] Referer: %s", requestId, referer));
        }

        if ("POST".equalsIgnoreCase(req.getMethod())) {
            logPostData(req, requestId);
        }

        try {
            chain.doFilter(request, response);
            long duration = System.currentTimeMillis() - start;
            writeLog("INFO", String.format("[%s] END: %s %s - %d ms", requestId, req.getMethod(), req.getRequestURI(), duration));

            if (duration > 1000) {
                writeLog("WARN", String.format("[%s] SLOW REQUEST: %s %s - %d ms", requestId, req.getMethod(), req.getRequestURI(), duration));
            }
        } catch (Exception e) {
            long duration = System.currentTimeMillis() - start;            
            writeLog("ERROR", String.format("[%s] REQUEST FAILED: %s %s - %d ms", requestId, req.getMethod(), req.getRequestURI(), duration));
            writeLog("ERROR", String.format("[%s] Error: %s", requestId, e.getMessage()));
            throw e;
        }
        
        // 요청 후 로그 기록
        writeLog("INFO", String.format("[%s] REQUEST END", requestId));
	}

    private String generateRequestId() {
        return "REQ_" + UUID.randomUUID().toString();
    }

    private String getClientIP(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }

        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }

        return request.getRemoteAddr();
    }

    private boolean isSensitiveData(String paramName) {
        String[] sensitiveParams = {"password", "pwd", "pass", "token", "secret", "key"};
        String lowerParamName = paramName.toLowerCase();

        for (String param : sensitiveParams) {
            if (lowerParamName.contains(param)) {
                return true;
            }
        }
        return false;
    }

    private void logPostData(HttpServletRequest request, String requestId) {
        Map<String, String> params = new HashMap<>();
        Enumeration<String> parameterNames = request.getParameterNames();

        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            String paramValue = request.getParameter(paramName);

            if (isSensitiveData(paramName)) {
                params.put(paramName, "***");
            } else {
                params.put(paramName, paramValue);
            }
        }   

        if (!params.isEmpty()) {
            writeLog("INFO", String.format("[%s] POST Data: %s", requestId, params.toString()));
        }
    }   

    private boolean shouldLog(String level) {
        switch (LOG_LEVEL) {
            case "DEBUG": return true;
            case "INFO": return !"DEBUG".equals(level);
            case "WARN": return "WARN".equals(level) || "ERROR".equals(level);
            case "ERROR": return "ERROR".equals(level);
            default: return true;
        }
    }

    private synchronized void writeLog(String level, String message) {
        if (!shouldLog(level)) {
            return;
        }

        String timeStamp = sdf.format(new Date());
        String logMsg = String.format("[%s] %s - %s%s", level, timeStamp, message, System.lineSeparator());

        try (FileWriter fw = new FileWriter(logFile, true);
             BufferedWriter bw = new BufferedWriter(fw)) {
            bw.write(logMsg);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
