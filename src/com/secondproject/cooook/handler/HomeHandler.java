package com.secondproject.cooook.handler;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.secondproject.cooook.dao.DashboardDao;
import com.secondproject.cooook.model.Dashboard;

public class HomeHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();

		DashboardDao dashboardDao = new DashboardDao(request);
		Dashboard dashboard = dashboardDao.selectDashboard();
		
		session.setAttribute("dashboard", dashboard);

		return "index.jsp";
	}

}
