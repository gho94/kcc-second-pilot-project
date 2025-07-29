package com.secondproject.cooook.common;

import java.util.Locale;

public class LocaleUtil {
    public static String getLocale(Locale locale) {
        if (locale == null) {
            locale = Locale.getDefault();
        }
        String language = locale.getLanguage();

        switch (language) {
            case "ko":
                return "_k";
            case "en":
                return "_e";
            default:
                return "";
        }
    }
}
