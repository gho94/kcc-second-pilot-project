package com.secondproject.cooook.handler.role;

import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.RoleFeatureCode;
import com.secondproject.cooook.dao.RoleDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Role;

public class RoleHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		RoleDao dao = new RoleDao();
		
		List<Role> roles = dao.getAllRoles().stream()
				.map(role -> {
					String featureNames = RoleFeatureCode.convertFeatureCodesToNames(role.getFeatureCodes());
					role.setFeatureNames(featureNames);
					return role;
				})
				.collect(Collectors.toList());
		request.setAttribute("roles", roles);
		return "role/role.jsp";		
	}
}
