package com.secondproject.cooook.handler.category;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;

public class CategoryInsertHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		Category category  = new Category();
		
		String categoryName = request.getParameter("categoryName");
		int parentId = Integer.parseInt(request.getParameter("parentId"));

		category.setCategoryName(categoryName);
		category.setParentId(parentId);

		Locale locale = (Locale) request.getSession().getAttribute("locale");
		String localeStr = LocaleUtil.getLocale(locale);
		
		CategoryDao dao = new CategoryDao(localeStr);
		dao.insertCategory(category);
		
		return "redirect:/category.do";
	}

}
