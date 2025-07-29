package com.secondproject.cooook.handler.staff;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.PasswordUtil;
import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.RoleDao;
import com.secondproject.cooook.dao.StaffDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Role;
import com.secondproject.cooook.model.Staff;

public class StaffUpdateHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {    
	    String method = request.getMethod();

	    if ("GET".equalsIgnoreCase(method)) {
			Locale locale = (Locale) request.getSession().getAttribute("locale");
			String localeStr = LocaleUtil.getLocale(locale);
	    
			StaffDao dao = new StaffDao(localeStr);
			int staffId = Integer.parseInt(request.getParameter("staffId"));			

			Staff staff = dao.getStaffByStaffId(staffId);
		    
	    	RoleDao roleDao = new RoleDao(localeStr);
	    	List<Role> roleList = roleDao.getAllRoles();
	    	
	    	request.setAttribute("action", "update");
	    	request.setAttribute("staff", staff);
	    	request.setAttribute("roleList", roleList);
	        return "staff/staff_merge.jsp";
	    }

		Staff staff = new Staff();
		int staffId = Integer.parseInt(request.getParameter("staffId"));
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		password = PasswordUtil.hashPassword(password);
		String phone = request.getParameter("phone");
		int roleId = Integer.parseInt(request.getParameter("roleId"));
		
		StaffDao dao = new StaffDao();
		
		staff.setStaffId(staffId);
		staff.setFirstName(firstName);
        staff.setLastName(lastName);
        staff.setEmail(email);        
        staff.setPassword(password);
        staff.setPhone(phone);        
        staff.setRoleId(roleId);
        
        dao.updateStaff(staff);
                		
		return "redirect:/staff.do";
	}

}
