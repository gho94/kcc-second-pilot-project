package com.secondproject.cooook.handler.category;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;


public class CategoryDeleteHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
		String param = request.getParameter("categoryId");


		int categoryId = Integer.parseInt(param);

		CategoryDao dao = new CategoryDao();
		boolean deleted = dao.deleteCategory(categoryId);

		if (!deleted) {
			// 실패 시 alert 메시지 출력 (UIHelper 활용 가능)
			response.setContentType("text/html; charset=UTF-8");
			try {
				response.getWriter().write("<script>alert('삭제에 실패했습니다'); history.back();</script>");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return null;
		}

        return "redirect:/category/list.do";
	}
}
