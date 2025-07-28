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
		String method = request.getMethod();
		
		if ("GET".equalsIgnoreCase(method)) {
	        CategoryDao dao = new CategoryDao();
	        List<Category> categories = dao.selectCategory();
	        
	        JSONArray jsonArray = new JSONArray();
	        for (Category category : categories) {
	            JSONObject node = new JSONObject();
	            
	            node.put("id", category.getCategoryId());
	            node.put("text", category.getCategoryName());
	            node.put("parent", category.getParentId() == null ? "#" : String.valueOf(category.getParentId()));
	            jsonArray.put(node);
	        }

	        request.setAttribute("categoryTree", jsonArray.toString());
			request.setAttribute("action", "insert");
			request.setAttribute("category", new Category());

	        return "category/category_merge.jsp";
		}
		
		Category category  = new Category();
		
		String categoryName = request.getParameter("categoryName");

		String parentIdStr = request.getParameter("parentId");
		int parentId = parentIdStr.isBlank() ? 0 : Integer.parseInt(parentIdStr);

		category.setCategoryName(categoryName);
		category.setParentId(parentId);
		
		CategoryDao dao = new CategoryDao();
		dao.insertCategory(category);
		
		return "redirect:/category.do";
	}

}
