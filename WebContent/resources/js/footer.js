// 스크롤 시 푸터 상세 정보 표시
window.addEventListener('scroll', function() {
    const footerContent = document.getElementById('footerContent');
    const footer = document.querySelector('.footer');
    const scrollPosition = window.scrollY;
    const windowHeight = window.innerHeight;
    const documentHeight = document.documentElement.scrollHeight;
    
    // 요소가 존재하는지 확인 후 실행
    if (footerContent && footer) {
        
        // 푸터가 화면에 보이기 시작할 때 상세 정보 표시
        const footerTop = footer.getBoundingClientRect().top + window.scrollY;
        const triggerPoint = footerTop - windowHeight + 100; // 푸터 100px 전에 트리거
        
        if (scrollPosition > triggerPoint) {
            footerContent.classList.add('show');
        } else {
            footerContent.classList.remove('show');
        }
    }
});