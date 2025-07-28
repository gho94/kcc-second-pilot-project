package com.secondproject.cooook.handler.role;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

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
	    	role.setFeatureNames(RoleFeatureCode.convertFeatureCodesToNames(role.getFeatureCodes()));

	    	request.setAttribute("action", "update");
	    	request.setAttribute("role", role);
	    	request.setAttribute("roleList", RoleFeatureCode.FEATURE_NAME_MAP);    	
	    	
	        return "role/role_merge.jsp";
	    }	    

	    Role role = new Role();

		int roleId = Integer.parseInt(request.getParameter("roleId"));
	    String roleName = request.getParameter("roleName");
	    String description = request.getParameter("description");
	    String featureCodesStr = request.getParameter("featureCodes");
	    
	    role.setRoleId(roleId);
	    role.setRoleName(roleName);
	    role.setDescription(description);
	    List<String> featureCodes = Arrays.stream(featureCodesStr.split(","))
                .map(string -> string.trim())
                .collect(Collectors.toList());

        RoleDao dao = new RoleDao();
        dao.updateRole(role, featureCodes);
        
		return "redirect:/role.do";
	}

}
