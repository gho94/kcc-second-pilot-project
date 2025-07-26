package com.secondproject.cooook.handler.category;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;

public class CategoryUpdateHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        String method = request.getMethod();
        CategoryDao dao = new CategoryDao();

        if ("GET".equalsIgnoreCase(method)) {
            // 📌 수정 대상 카테고리 ID 받기
            int categoryId = Integer.parseInt(request.getParameter("id"));

            // 📌 수정 대상 카테고리 조회
            Category category = dao.selectCategoryById(categoryId);

            // 📌 상위 카테고리 목록 전체 조회 (트리용)
            List<Category> categoryList = dao.selectCategory();

            request.setAttribute("category", category);
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("action", "update");

            return "category/category_update.jsp";
        }

        // 📌 POST 요청: 수정 처리
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String categoryName = request.getParameter("categoryName");
        System.out.println("name: " + categoryName);
        String parentIdParam = request.getParameter("parentId");

        Category updatedCategory = new Category();
        updatedCategory.setCategoryId(categoryId);
        updatedCategory.setCategoryName(categoryName);

        if (parentIdParam != null && !parentIdParam.isBlank()) {
            updatedCategory.setParentId(Integer.parseInt(parentIdParam));
        } else {
            updatedCategory.setParentId(null);
        }

        dao.updateCategory(updatedCategory, updatedCategory.getCategoryId());
        System.out.println("업데이트 내역" + updatedCategory);
        return "redirect:/category/list.do";
    }
}
