package com.secondproject.cooook.handler.category;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;

public class CategoryInsertHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        String method = request.getMethod();
        if ("GET".equalsIgnoreCase(method)) {
            CategoryDao dao = new CategoryDao();
            List<Category> categoryList = dao.selectCategory();

            request.setAttribute("categoryList", categoryList);
            request.setAttribute("action", "insert");
            request.setAttribute("category", new Category());

            return "category/category_insert.jsp";
        }

        // POST 요청
        String categoryName = request.getParameter("categoryName");
        System.out.println("post1: " + categoryName);
        String parentIdParam = request.getParameter("parentId");
        System.out.println("post1: " + parentIdParam);

        Category category = new Category();
        category.setCategoryName(categoryName);

        // ✨ null 또는 빈값이면 -1로 설정
        if (parentIdParam != null && !parentIdParam.isBlank()) {
            category.setParentId(Integer.parseInt(parentIdParam));
        } else {
            category.setParentId(-1); // 의미 없는 값으로 넘기고, insertCategory는 내부적으로 SELECT 실패 → NULL 저장됨
        }

        CategoryDao dao = new CategoryDao();
        dao.insertCategory(category);

        return "redirect:/category/list.do";
    }
}
