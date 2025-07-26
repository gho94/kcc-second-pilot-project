package com.secondproject.cooook.handler.menu;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Menu;

public class MenuHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		MenuDao dao = new MenuDao();
		
		List<Menu> menus = dao.getAllMenus();
		request.setAttribute("menus", menus);
		return "menu/menu.jsp";
	}

}
