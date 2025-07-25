package com.secondproject.cooook.handler.staff;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.RoleDao;
import com.secondproject.cooook.dao.StaffDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Role;
import com.secondproject.cooook.model.Staff;

public class StaffInsertHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {		
	    String method = request.getMethod();

	    if ("GET".equalsIgnoreCase(method)) {
	    	RoleDao roleDao = new RoleDao();
	    	List<Role> roleList = roleDao.getAllRoles();
	    	
	    	request.setAttribute("action", "insert");
	    	request.setAttribute("staff", new Staff());
	    	request.setAttribute("roleList", roleList);
	        return "staff/staffeditform.jsp";
	    }

		Staff staff = new Staff();
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String phone = request.getParameter("phone");
		int roleId = Integer.parseInt(request.getParameter("roleId"));
		
		StaffDao dao = new StaffDao();
		
		staff.setFirstName(firstName);
        staff.setLastName(lastName);
        staff.setEmail(email);        
        staff.setPassword(password);
        staff.setPhone(phone);        
        staff.setRoleId(roleId);
        
        dao.insertStaff(staff);
                		
		return "redirect:/staff.do";
	}
}
