package com.secondproject.cooook.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface CommandHandler {
	String process(HttpServletRequest request, HttpServletResponse response);
}
