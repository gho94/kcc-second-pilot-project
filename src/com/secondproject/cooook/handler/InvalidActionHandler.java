package com.secondproject.cooook.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class InvalidActionHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		return "error/invalidaction.jsp";
	}
}
