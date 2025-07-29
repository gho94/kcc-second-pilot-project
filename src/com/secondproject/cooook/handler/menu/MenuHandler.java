package com.secondproject.cooook.handler.menu;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Menu;

public class MenuHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		Locale locale = (Locale) request.getSession().getAttribute("locale");
		String localeStr = LocaleUtil.getLocale(locale);
	    
		MenuDao dao = new MenuDao(localeStr);
		
		List<Menu> menus = dao.getAllMenus();
		request.setAttribute("menus", menus);
		return "menu/menu.jsp";
	}

}
