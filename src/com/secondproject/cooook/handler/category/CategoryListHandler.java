package com.secondproject.cooook.handler.category;

import java.util.List;
import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 카테고리 목록 조회 후 JSP로 포워드 (Gson 미사용)
 */
public class CategoryListHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) {
        // 1) DAO 호출
        CategoryDao dao = new CategoryDao();
        List<Category> categoryList = dao.selectCategory();

        // 2) request에 직접 List를 담아 JSP로
        req.setAttribute("categoryList", categoryList);
        // 3) JSP 경로 반환
        return "category/category_list.jsp";
    }
}
