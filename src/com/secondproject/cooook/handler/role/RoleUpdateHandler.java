package com.secondproject.cooook.handler.role;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.RoleFeatureCode;
import com.secondproject.cooook.dao.RoleDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Role;

public class RoleUpdateHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
	    String method = request.getMethod();

	    if ("GET".equalsIgnoreCase(method)) { 	    	
			int roleId = Integer.parseInt(request.getParameter("roleId"));			

	    	RoleDao dao = new RoleDao();
	    	Role role = dao.getRoleByRoleId(roleId);

	    	request.setAttribute("action", "update");
	    	request.setAttribute("role", role);
	    	request.setAttribute("roleList", RoleFeatureCode.FEATURE_NAME_MAP);
	        return "role/role_form.jsp";
	    }	    

	    Role role = new Role();

		int roleId = Integer.parseInt(request.getParameter("roleId"));
	    String roleName = request.getParameter("roleName");
	    String description = request.getParameter("description");
	    
	    role.setRoleId(roleId);
	    role.setRoleName(roleName);
	    role.setDescription(description);
	    	    
        String[] selectedValues = request.getParameterValues("roleList");
        RoleDao dao = new RoleDao();
        dao.updateRole(role, selectedValues);

		return "redirect:/role.do";
	}

}
