package com.secondproject.cooook.handler.staff;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.StaffDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Staff;

public class StaffHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		Locale locale = (Locale) request.getSession().getAttribute("locale");
		String localeStr = LocaleUtil.getLocale(locale);
	    
		StaffDao dao = new StaffDao(localeStr);
		
		List<Staff> staffs = dao.getStaffAll();
		request.setAttribute("staffs", staffs);
	    return "staff/staff.jsp";
	}
}
