package com.secondproject.cooook.handler.menu;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Menu;

public class MenuUpdateHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String method = request.getMethod();
		
		if ("GET".equalsIgnoreCase(method)) {
			int menuId = Integer.parseInt(request.getParameter("menuId"));
			
			MenuDao dao = new MenuDao();
			Menu menu = dao.getMenuById(menuId);
			
			request.setAttribute("action", "update");
			request.setAttribute("menu", menu);
			return "menu/menu_merge.jsp";			
		}

		Menu menu = new Menu();

		int menuId = Integer.parseInt(request.getParameter("menuId"));		
		String menuName = request.getParameter("menuName");
		int price = Integer.parseInt(request.getParameter("price"));

		menu.setMenuId(menuId);
		menu.setMenuName(menuName);
		menu.setPrice(price);

		MenuDao dao = new MenuDao();
		dao.updateMenu(menu);

		return "redirect:/menu.do";
	}

}
