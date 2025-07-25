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
					String featureNames = convertFeatureCodesToNames(role.getFeatureCodes());
					role.setFeatureNames(featureNames);
					return role;
				})
				.collect(Collectors.toList());
		request.setAttribute("roles", roles);
		return "role/role.jsp";		
	}

    private String convertFeatureCodesToNames(String featureCodesStr) {
        if (featureCodesStr == null || featureCodesStr.isEmpty()) return "";

        String[] codes = featureCodesStr.split(",");  // DB에서는 쉼표로 연결되어 있다고 가정
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < codes.length; i++) {
            String code = codes[i].trim();
            String name = RoleFeatureCode.FEATURE_NAME_MAP.getOrDefault(code, code);
            sb.append(name);
            if (i < codes.length - 1) {
                sb.append(", ");
            }
        }
        return sb.toString();
    }
}
