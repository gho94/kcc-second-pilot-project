package com.secondproject.cooook.handler.order;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.OrderDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Order;

public class OrderHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		OrderDao dao = new OrderDao();
		List<Order> orders = dao.getAllOrders();
		request.setAttribute("orders", orders);
		return "order/order.jsp";
	}

}
