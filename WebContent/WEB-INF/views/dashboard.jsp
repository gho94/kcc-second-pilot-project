<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>COOKCOOK</title>

<!-- 구글 웹폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap"
	rel="stylesheet" />

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/normalize.css@8.0.1/" />
<!-- 슬라이드 api -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet" href="/resources/css/reset.css" />
<link rel="stylesheet" href="/resources/css/header_footer.css" />
<link rel="stylesheet" href="/resources/css/common.css" />
<link rel="stylesheet" href="/resources/css/dashboard.css" rel="stylesheet">
<script src="script/jquery-3.7.1.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<%@ include file="header.jsp"%>
	<div class="content dashboard-content">
		<div class="dashboard-header">
			<div class="container-fluid">
				<div class="row align-items-center">
					<div class="col-6">
						<h1 class="dashboard-title">대시보드</h1>
					</div>
					<div class="col-6 text-end">
						<div class="btn generate-btn">
							<i class="fas fa-chart-line me-2"></i>2025년 7월 24일
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
							<div class="stat-label">주문 수</div>
							<div class="stat-value">100건</div>
							<i class="fas fa-calendar-alt stat-icon"></i>
						</div>
					</div>
					<div class="col-xl-3 col-md-6 mb-4">
						<div class="stat-card earnings-annual">
							<div class="stat-label">레시피 수</div>
							<div class="stat-value">200건</div>
							<i class="fas fa-dollar-sign stat-icon"></i>
						</div>
					</div>
					<div class="col-xl-3 col-md-6 mb-4">
						<div class="stat-card tasks">
							<div class="stat-label">메뉴 수</div>
							<div class="stat-value">190건</div>
							<i class="fas fa-tasks stat-icon"></i>
						</div>
					</div>
					<div class="col-xl-3 col-md-6 mb-4">
						<div class="stat-card pending">
							<div class="stat-label">카테고리 수</div>
							<div class="stat-value">179건</div>
							<i class="fas fa-clock stat-icon"></i>
						</div>
					</div>
				</div>

				<!-- 차트 섹션 -->
				<div class="row">
					<div class="col-lg-8 mb-4">
						<div class="chart-card">
							<div class="chart-title">
								일주일 주문 총액 <i class="fas fa-ellipsis-v chart-menu"></i>
							</div>
							<canvas id="earningsChart"></canvas>
						</div>
					</div>


					<div class="col-lg-4 mb-4">
						<div class="chart-card menu-table">
							<div class="chart-title">
								최근 등록 메뉴 <i class="fas fa-ellipsis-v chart-menu"></i>
							</div>
							<div class="row">
								<div class="table-responsive">
									<table class="table custom-table">
										<thead>
											<tr>
												<th>메뉴명</th>
												<th>가격</th>
												<th>등록일</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td class="menu-name">김밥 세트</td>
												<td class="menu-price">₩8,500</td>
												<td class="menu-date">2025.01.23</td>
											</tr>
											<tr>
												<td class="menu-name">비빔밥</td>
												<td class="menu-price">₩9,000</td>
												<td class="menu-date">2025.01.22</td>
											</tr>
											<tr>
												<td class="menu-name">된장찌개</td>
												<td class="menu-price">₩7,000</td>
												<td class="menu-date">2025.01.21</td>
											</tr>
											<tr>
												<td class="menu-name">불고기 덮밥</td>
												<td class="menu-price">₩10,500</td>
												<td class="menu-date">2025.01.20</td>
											</tr>
											<tr>
												<td class="menu-name">치킨 마요 김밥</td>
												<td class="menu-price">₩6,500</td>
												<td class="menu-date">2025.01.19</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>

						<div class="chart-card ad-info">
							<div class="chart-title">
								광고 <i class="fas fa-ellipsis-v chart-menu"></i>
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
        const earningsCtx = document.getElementById('earningsChart').getContext('2d');
        const earningsChart = new Chart(earningsCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'Earnings',
                    data: [0, 10000, 5000, 15000, 10000, 20000, 15000, 25000, 20000, 30000, 25000, 40000],
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
                                return '$' + value.toLocaleString();
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