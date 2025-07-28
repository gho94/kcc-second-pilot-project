package com.secondproject.cooook.handler.category;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;

public class CategoryDeleteHandler2 implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		int categoryId = Integer.parseInt(request.getParameter("categoryId"));

		CategoryDao dao = new CategoryDao();
		dao.deleteCategory(categoryId);	

		return "redirect:/category.do";
	}

}
