package com.secondproject.cooook.common;

import java.util.Map;

public class RoleFeatureCode {
    public static final String WORKER_MANAGE   = "WORKER_MANAGE";
    public static final String ROLE_MANAGE     = "ROLE_MANAGE";
    public static final String ORDER_MANAGE    = "ORDER_MANAGE";
    public static final String MATERIAL_MANAGE = "MATERIAL_MANAGE";
    public static final String CATEGORY_MANAGE = "CATEGORY_MANAGE";
    public static final String MENU_MANAGE = "MENU_MANAGE";

    public static final Map<String, String> FEATURE_NAME_MAP = Map.of(
        WORKER_MANAGE,          "작업자",
        ROLE_MANAGE,            "권한",
        ORDER_MANAGE,           "주문",
        MATERIAL_MANAGE,        "레시피",
        CATEGORY_MANAGE,        "카테고리",
        MENU_MANAGE,            "메뉴"
    );

    public static final Map<Integer, String> menuIndexToFeature = Map.of(
    	    1, WORKER_MANAGE,
    	    2, ROLE_MANAGE,
    	    3, ORDER_MANAGE,
    	    4, MATERIAL_MANAGE,
    	    5, CATEGORY_MANAGE,
            6, MENU_MANAGE
    );    

    public static String convertFeatureCodesToNames(String featureCodesStr) {
        if (featureCodesStr == null || featureCodesStr.isEmpty()) return "";

        String[] codes = featureCodesStr.split(",");  // DB에서는 쉼표로 연결되어 있다고 가정
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < codes.length; i++) {
            String code = codes[i].trim();
            String name = RoleFeatureCode.FEATURE_NAME_MAP.getOrDefault(code, code);
            sb.append(name);
            if (i < codes.length - 1) {
                sb.append(", ");
            }
        }
        return sb.toString();
    }
}
