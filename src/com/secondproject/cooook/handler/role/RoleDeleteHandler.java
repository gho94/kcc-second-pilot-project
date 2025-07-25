package com.secondproject.cooook.handler.role;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.RoleDao;
import com.secondproject.cooook.dao.StaffDao;
import com.secondproject.cooook.handler.CommandHandler;

public class RoleDeleteHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		int roleId = Integer.parseInt(request.getParameter("roleId"));
		
		RoleDao dao = new RoleDao();
		
		dao.softDeleteRole(roleId);
		
		return "redirect:/role.do";
	}

}
