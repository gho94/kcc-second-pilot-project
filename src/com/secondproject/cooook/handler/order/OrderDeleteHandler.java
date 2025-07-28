package com.secondproject.cooook.handler.order;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.OrderDao;
import com.secondproject.cooook.handler.CommandHandler;

public class OrderDeleteHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		int orderId = Integer.parseInt(request.getParameter("orderId"));

		OrderDao dao = new OrderDao();
		dao.softDeleteOrder(orderId);

		return "redirect:/order.do";
	}

}
