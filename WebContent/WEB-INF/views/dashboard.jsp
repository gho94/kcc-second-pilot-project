<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<%@ page import="java.util.List" %>
<%
request.setAttribute("pageStyles", List.of("/resources/css/dashboard.css"));
%>
<%@ include file="/WEB-INF/views/head.jsp"%>
<body>
	<%@ include file="header.jsp"%>
	<div class="content dashboard-content">
		<div class="dashboard-header">
			<div class="container-fluid">
				<div class="row align-items-center">
					<div class="col-6">
						<h1 class="dashboard-title"><fmt:message key="대시보드" /></h1>
					</div>
					<div class="col-6 text-end">
						<div class="btn generate-btn">
							<i class="fas fa-chart-line me-2"></i><fmt:formatDate value="${dashboard.today}" pattern="YYYY년  MM월 dd일"/>							
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="container-con">
			<div class="container-fluid">
				<!-- 통계 카드들 -->
				<div class="row mb-4">
					<div class="col-xl-3 col-md-6 mb-4">
						<div class="stat-card earnings-monthly">
							<div class="stat-label"><fmt:message key="주문 수" /></div>
							<div class="stat-value">${dashboard.orderCount}</div>
							<i class="fas fa-calendar-alt stat-icon"></i>
						</div>
					</div>
					<div class="col-xl-3 col-md-6 mb-4">
						<div class="stat-card earnings-annual">
							<div class="stat-label"><fmt:message key="레시피 수" /></div>
							<div class="stat-value">${dashboard.recipeCount}</div>
							<i class="fas fa-dollar-sign stat-icon"></i>
						</div>
					</div>
					<div class="col-xl-3 col-md-6 mb-4">
						<div class="stat-card tasks">
							<div class="stat-label"><fmt:message key="메뉴 수" /></div>
							<div class="stat-value">${dashboard.menuCount}</div>
							<i class="fas fa-tasks stat-icon"></i>
						</div>
					</div>
					<div class="col-xl-3 col-md-6 mb-4">
						<div class="stat-card pending">
							<div class="stat-label"><fmt:message key="카테고리 수" /></div>
							<div class="stat-value">${dashboard.categoryCount}</div>
							<i class="fas fa-clock stat-icon"></i>
						</div>
					</div>
				</div>

				<!-- 차트 섹션 -->
				<div class="row">
					<div class="col-lg-8 mb-4">
						<div class="chart-card">
							<div class="chart-title">
								<fmt:message key="일주일 주문 총액" /> <i class="fas fa-ellipsis-v chart-menu"></i>
							</div>
							<canvas id="earningsChart"></canvas>
						</div>
					</div>


					<div class="col-lg-4 mb-4">
						<div class="chart-card menu-table">
							<div class="chart-title">
								<fmt:message key="최근 등록 메뉴" /> <i class="fas fa-ellipsis-v chart-menu"></i>
							</div>
							<div class="row">
								<div class="table-responsive">
									<table class="table custom-table">
										<thead>
											<tr>
												<th><fmt:message key="메뉴명" /></th>
												<th><fmt:message key="가격" /></th>
												<th><fmt:message key="등록일" /></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="menu" items="${dashboard.menus}">
												<tr>
													<td class="menu-name">${menu.menuName}</td>
													<td class="menu-price"><fmt:formatNumber value="${menu.price}" type="number" pattern="#,###" /></td>
													<td class="menu-date"><fmt:formatDate value="${menu.createdAt}" pattern="YYYY.MM.dd"/></td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</div>
						</div>

						<div class="chart-card ad-info">
							<div class="chart-title">
								<fmt:message key="광고" /> <i class="fas fa-ellipsis-v chart-menu"></i>
							</div> 
							<div class="ad-img-con">
								<div class="ad-img"></div>
							</div>
						</div>

					</div>



				</div>
			</div>

		</div>
	</div>
	<%@ include file="footer.jsp"%>


	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
	<script>
        // Earnings Overview 차트
        const totalEarnings = ${dashboard.totalEarnings};

        const labels = [];
        const earningsData = [];

        totalEarnings.forEach(item => {
            labels.push(item.day);
            earningsData.push(item.earnings);
        });
        
        console.log(totalEarnings);
        const earningsCtx = document.getElementById('earningsChart').getContext('2d');
        const earningsChart = new Chart(earningsCtx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Earnings',
                    data: earningsData,
                    borderColor: '#74b9ff',
                    backgroundColor: 'rgba(116, 185, 255, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#74b9ff',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#6c757d'
                        }
                    },
                    y: {
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        },
                        ticks: {
                            color: '#6c757d',
                            callback: function(value) {
                                return value.toLocaleString();
                            }
                        }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });

        // 애니메이션 효과
        document.addEventListener('DOMContentLoaded', function() {
            // 카드 호버 효과
            const cards = document.querySelectorAll('.stat-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });

    </script>
</body>
</html>