package com.secondproject.cooook.handler.role;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.LocaleUtil;
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
	        return "role/role_merge.jsp";
	    }	    
	    
	    Role role = new Role();
	    
	    String roleName = request.getParameter("roleName");
	    String description = request.getParameter("description");
	    String featureCodesStr = request.getParameter("featureCodes");
	    
	    role.setRoleName(roleName);
	    role.setDescription(description);	    
	    List<String> featureCodes = Arrays.stream(featureCodesStr.split(","))
                .map(string -> string.trim())
                .collect(Collectors.toList());

		Locale locale = (Locale) request.getSession().getAttribute("locale");
		String localeStr = LocaleUtil.getLocale(locale);
	    
        RoleDao dao = new RoleDao(localeStr);
        
        dao.insertRole(role, featureCodes);

		return "redirect:/role.do";
	}
}
