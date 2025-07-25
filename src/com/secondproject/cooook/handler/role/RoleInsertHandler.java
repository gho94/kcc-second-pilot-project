package com.secondproject.cooook.handler.role;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.RoleFeatureCode;
import com.secondproject.cooook.dao.RoleDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Role;

public class RoleInsertHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
	    String method = request.getMethod();

	    if ("GET".equalsIgnoreCase(method)) { 	    	
	    	Role role = new Role();
	    	
	    	request.setAttribute("action", "insert");
	    	request.setAttribute("role", role);
	    	request.setAttribute("roleList", RoleFeatureCode.FEATURE_NAME_MAP);
	        return "role/role_form.jsp";
	    }	    
	    
	    Role role = new Role();
	    
	    String roleName = request.getParameter("roleName");
	    String description = request.getParameter("description");
	    
	    role.setRoleName(roleName);
	    role.setDescription(description);
	    	    
        String[] selectedValues = request.getParameterValues("roleList");
        RoleDao dao = new RoleDao();
        dao.insertRole(role, selectedValues);

		return "redirect:/role.do";
	}
}
