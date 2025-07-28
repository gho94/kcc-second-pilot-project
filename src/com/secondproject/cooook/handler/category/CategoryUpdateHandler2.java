package com.secondproject.cooook.handler.category;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;

public class CategoryUpdateHandler2 implements CommandHandler {

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
			request.setAttribute("action", "update");
			request.setAttribute("category", new Category());

	        return "category/category_merge.jsp";
		}

		String action = request.getParameter("action");
		if ("merge".equalsIgnoreCase(action)) {
			String moveNodeId = request.getParameter("moveNodeId");
			String newParentIdStr = request.getParameter("newParentId");

			int parentId = "#".equalsIgnoreCase(newParentIdStr) ? 0 : Integer.parseInt(newParentIdStr);
			int categoryId = Integer.parseInt(moveNodeId);

			Category category = new Category();
			category.setCategoryId(categoryId);
			category.setParentId(parentId);

			CategoryDao dao = new CategoryDao();
			dao.updateCategory(category, 1);

			return "redirect:/category.do";
		} 

		Category category  = new Category();
		
		String categoryName = request.getParameter("categoryName");
		String parentIdStr = request.getParameter("parentId");
		int categoryId = parentIdStr.isBlank() ? 0 : Integer.parseInt(parentIdStr);

		category.setCategoryName(categoryName);
		category.setCategoryId(categoryId);

		CategoryDao dao = new CategoryDao();

		dao.updateCategory(category, 0);
		
		return "redirect:/category.do";
	}

}
