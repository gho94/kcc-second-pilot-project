package com.secondproject.cooook.handler.menu;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;
import com.secondproject.cooook.model.Menu;

public class MenuInsertHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String method = request.getMethod();
		
		if ("GET".equalsIgnoreCase(method)) {
			Menu menu = new Menu();
			CategoryDao cdao = new CategoryDao();
			List<Category> categories = cdao.selectCategory();
			JSONArray jsonArray = new JSONArray();
			for (Category category : categories) {
				JSONObject node = new JSONObject();

				node.put("id", category.getCategoryId());
				node.put("text", category.getCategoryName());
				node.put("parent", category.getParentId() == null ? "#" : String.valueOf(category.getParentId()));
				jsonArray.put(node);
			}
			
			request.setAttribute("action", "insert");
			request.setAttribute("menu", menu);
			request.setAttribute("categoryTree", jsonArray.toString());
			
			return "menu/menu_merge.jsp";
		}
		
		Menu menu  = new Menu();
		
		String menuName = request.getParameter("menuName");
		int price = Integer.parseInt(request.getParameter("price"));
		int categoryId = Integer.parseInt(request.getParameter("categoryId"));
		
		menu.setMenuName(menuName);
		menu.setPrice(price);
		
		MenuDao dao = new MenuDao();
		dao.insertMenu(menu);
		
		return "redirect:/menu.do";
	}

}
