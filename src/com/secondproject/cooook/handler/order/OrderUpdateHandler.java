package com.secondproject.cooook.handler.order;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.dao.OrderDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Menu;
import com.secondproject.cooook.model.Order;

public class OrderUpdateHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String method = request.getMethod();
		if ("GET".equalsIgnoreCase(method)) {
			OrderDao orderDao = new OrderDao();
			Order order = orderDao.getOrderById(Integer.parseInt(request.getParameter("orderId")));
			Locale locale = (Locale) request.getSession().getAttribute("locale");
			String localeStr = LocaleUtil.getLocale(locale);
	    
			MenuDao menuDao = new MenuDao(localeStr);
			List<Menu> menus = menuDao.getAllMenus();

			request.setAttribute("action", "update");			
			request.setAttribute("order", order);
			request.setAttribute("menus", menus);
			return "order/order_merge.jsp";
		}

		Order order = new Order();
		order.setOrderId(Integer.parseInt(request.getParameter("orderId")));
		order.setMenuId(Integer.parseInt(request.getParameter("menuId").split(":")[0]));
		order.setQuantity(Integer.parseInt(request.getParameter("quantity")));
		order.setTotalPrice(Integer.parseInt(request.getParameter("menuId").split(":")[1]) * order.getQuantity());
		OrderDao orderDao = new OrderDao();
		orderDao.updateOrder(order);
		return "redirect:/order.do";
	}

}
