package com.secondproject.cooook.filter;

import java.io.IOException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpFilter;

public class LocaleFilter extends HttpFilter implements Filter {
	private static final long serialVersionUID = 1L;

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;

		Locale browserLocale = detectBrowserLocale(httpRequest);
		httpRequest.getSession().setAttribute("locale", browserLocale);
				
		chain.doFilter(request, response);
	}

	private Locale detectBrowserLocale(HttpServletRequest request) {
		String acceptLanguage = request.getHeader("Accept-Language");
		if (acceptLanguage == null || acceptLanguage.isEmpty()) {
			return Locale.KOREAN;
		}

		String primaryLanguage = acceptLanguage.split(",")[0].trim();
		String languageCode = primaryLanguage.split("-")[0].toLowerCase();

		switch (languageCode) {
			case "ko":	return Locale.KOREAN;
			case "en":	return Locale.ENGLISH;
			default:	return Locale.KOREAN;
		}
	}

}
