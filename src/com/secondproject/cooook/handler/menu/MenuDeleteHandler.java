package com.secondproject.cooook.handler.menu;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.handler.CommandHandler;

public class MenuDeleteHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		int menuId = Integer.parseInt(request.getParameter("menuId"));

		MenuDao dao = new MenuDao();
		dao.deleteMenu(menuId);	

		return "redirect:/menu.do";
	}

}
