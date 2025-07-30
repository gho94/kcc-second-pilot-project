package com.secondproject.cooook.handler.order;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.OrderDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Order;

public class OrderHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		Locale locale = (Locale) request.getSession().getAttribute("locale");
		String localeStr = LocaleUtil.getLocale(locale);
			
		OrderDao dao = new OrderDao(localeStr);
		List<Order> orders = dao.getAllOrders();
		request.setAttribute("orders", orders);
		return "order/order.jsp";
	}

}
