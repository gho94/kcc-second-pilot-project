package com.secondproject.cooook.handler.staff;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.StaffDao;
import com.secondproject.cooook.handler.CommandHandler;

public class StaffDeleteHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {	
		int staffId = Integer.parseInt(request.getParameter("staffId"));
		
		StaffDao dao = new StaffDao();
		
        dao.softDeleteStaff(staffId);
                		
		return "redirect:/staff.do";
	}
}
