package com.secondproject.cooook.handler.category;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;

public class CategoryUpdateHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String action = request.getParameter("action");
		if ("move".equalsIgnoreCase(action)) {
			int categoryId = Integer.parseInt(request.getParameter("categoryId"));
			String parentIdStr = request.getParameter("parentId");
			int parentId = "#".equalsIgnoreCase(parentIdStr) ? 0 : Integer.parseInt(parentIdStr);
			
			Category category = new Category();
			category.setCategoryId(categoryId);
			category.setParentId(parentId);

			CategoryDao dao = new CategoryDao();
			dao.updateCategory(category, 1);

			return "redirect:/category.do";
		} 

		Category category  = new Category();
		
		String categoryName = request.getParameter("categoryName");
		int categoryId = Integer.parseInt(request.getParameter("categoryId"));

		category.setCategoryName(categoryName);
		category.setCategoryId(categoryId);

		Locale locale = (Locale) request.getSession().getAttribute("locale");
		String localeStr = LocaleUtil.getLocale(locale);
		
		CategoryDao dao = new CategoryDao(localeStr);

		dao.updateCategory(category, 0);
		
		return "redirect:/category.do";
	}

}
