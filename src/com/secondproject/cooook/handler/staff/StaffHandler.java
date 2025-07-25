package com.secondproject.cooook.handler.staff;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.StaffDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Staff;

public class StaffHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		StaffDao dao = new StaffDao();
		
		List<Staff> staffs = dao.getStaffAll();
		request.setAttribute("staffs", staffs);
	    return "staff/staff.jsp";
	}
}
