package com.secondproject.cooook.handler.category;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;

public class CategoryInsertHandler2 implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		Category category  = new Category();
		
		String categoryName = request.getParameter("categoryName");
		int parentId = Integer.parseInt(request.getParameter("parentId"));

		category.setCategoryName(categoryName);
		category.setParentId(parentId);
		
		CategoryDao dao = new CategoryDao();
		dao.insertCategory(category);
		
		return "redirect:/category.do";
	}

}
