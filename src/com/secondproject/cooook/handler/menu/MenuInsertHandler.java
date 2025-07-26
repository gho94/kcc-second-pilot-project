package com.secondproject.cooook.handler.menu;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Menu;

public class MenuInsertHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String method = request.getMethod();
		
		if ("GET".equalsIgnoreCase(method)) {
			Menu menu = new Menu();
			
			request.setAttribute("action", "insert");
			request.setAttribute("menu", menu);
			
			return "menu/menu_merge.jsp";
		}
		
		Menu menu  = new Menu();
		
		String menuName = request.getParameter("menuName");
		int price = Integer.parseInt(request.getParameter("price"));
		
		menu.setMenuName(menuName);
		menu.setPrice(price);
		
		MenuDao dao = new MenuDao();
		dao.insertMenu(menu);
		
		return "redirect:/menu.do";
	}

}
