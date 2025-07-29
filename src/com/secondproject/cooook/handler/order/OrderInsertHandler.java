package com.secondproject.cooook.handler.order;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.dao.OrderDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Menu;
import com.secondproject.cooook.model.Order;
import com.secondproject.cooook.model.Staff;

public class OrderInsertHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String method = request.getMethod();
		if ("GET".equalsIgnoreCase(method)) {
			Locale locale = (Locale) request.getSession().getAttribute("locale");
			String localeStr = LocaleUtil.getLocale(locale);
	    
			MenuDao menuDao = new MenuDao(localeStr);
			List<Menu> menus = menuDao.getAllMenus();
			request.setAttribute("action", "insert");
			request.setAttribute("menus", menus);
			request.setAttribute("order", new Order());
			return "order/order_merge.jsp";
		}

		Order order = new Order();
		HttpSession session = request.getSession();
		Staff staff = (Staff) session.getAttribute("staff");

		order.setStaffId(staff.getStaffId());

		order.setMenuId(Integer.parseInt(request.getParameter("menuId").split(":")[0]));
		order.setQuantity(Integer.parseInt(request.getParameter("quantity")));
		order.setTotalPrice(Integer.parseInt(request.getParameter("menuId").split(":")[1]) * order.getQuantity());

		OrderDao orderDao = new OrderDao();
		orderDao.insertOrder(order);
		return "redirect:/order.do";
	}

}
