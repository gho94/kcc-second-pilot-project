package com.secondproject.cooook.handler.menu;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.dao.MenuCategoryDao;
import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;
import com.secondproject.cooook.model.Menu;
import com.secondproject.cooook.model.MenuCategory;

public class MenuInsertHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String method = request.getMethod();
		
		if ("GET".equalsIgnoreCase(method)) {
			Menu menu = new Menu();
			Locale locale = (Locale) request.getSession().getAttribute("locale");
			String localeStr = LocaleUtil.getLocale(locale);		
			CategoryDao cdao = new CategoryDao(localeStr);
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
		MenuCategory menuCategory  = new MenuCategory();
		
		String menuName = request.getParameter("menuName");
		int price = Integer.parseInt(request.getParameter("price"));
		
		menu.setMenuName(menuName);
		menu.setPrice(price);
		
		Locale locale = (Locale) request.getSession().getAttribute("locale");
		String localeStr = LocaleUtil.getLocale(locale);
		MenuDao dao = new MenuDao(localeStr);
		int menuId = dao.insertMenu(menu);
		int categoryId = Integer.parseInt(request.getParameter("categoryId"));
		
		MenuCategoryDao cdao = new MenuCategoryDao();
		menuCategory.setMenuId(menuId);
		menuCategory.setCategoryId(categoryId);
		cdao.insertMenuCategory(menuCategory);
		
		return "redirect:/menu.do";
	}

}
