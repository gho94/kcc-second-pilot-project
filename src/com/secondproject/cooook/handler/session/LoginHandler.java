package com.secondproject.cooook.handler.session;

import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.secondproject.cooook.common.RoleFeatureCode;
import com.secondproject.cooook.dao.RoleDao;
import com.secondproject.cooook.dao.StaffDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Staff;

public class LoginHandler implements CommandHandler {
	StaffDao dao = new StaffDao();
	RoleDao roleDao = new RoleDao();

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String method = request.getMethod();

	    if ("GET".equalsIgnoreCase(method)) {
	    	return "login.jsp";
	    }
	    
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		HttpSession session = request.getSession();
		
		Staff staff = dao.login(email, password);
		
		if (staff == null) {
			session.invalidate();
			throw new RuntimeException("로그인 실패: 이메일 또는 비밀번호가 잘못되었습니다.");
		}		
		session.setAttribute("staff", staff);
        
        Map<String, String> menuMap = roleDao.getFeaturesByRoleId(staff.getRoleId())
        	    .stream()
        	    .collect(Collectors.toMap(
        	        code -> RoleFeatureCode.FEATURE_NAME_MAP.getOrDefault(code, code),
        	        code -> getMenuUrl(code)
        	    ));
    	session.setAttribute("menuMap", menuMap);
        	
		return "redirect:/";
	}
	
	private String getMenuUrl(String code) {
	    switch (code) {
	        case "WORKER_MANAGE": 			return "/staff.do";
	        case "ROLE_MANAGE": 			return "/role.do";
	        case "ORDER_MANAGE": 			return "/order.do";
	        case "MATERIAL_MANAGE": 		return "/menu/list.do";
	        case "CATEGORY_MANAGE": 		return "/category.do";
	        case "MENU_MANAGE": 			return "/menu.do";
	        case "MENU_CATEGORY_MANAGE": 	return "/menu/list.do";
	        default: 						return "#";
	    }
	}
}
